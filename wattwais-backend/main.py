from fastapi import FastAPI
from fastapi import HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from pydantic import Field
from typing import List, Optional
import pandas as pd
import numpy as np
import joblib
from datetime import datetime
import hashlib
import os
from pathlib import Path

app = FastAPI(title="wattwais prediction api")

def _get_allowed_origins():
    env = os.getenv("ENV", "development").lower()
    raw = os.getenv("CORS_ORIGINS", "").strip()

    if raw:
        return [origin.strip() for origin in raw.split(",") if origin.strip()]

    # Development convenience: allow everything.
    if env != "production":
        return ["*"]

    # Production default: require explicit allowlist.
    return []


allowed_origins = _get_allowed_origins()
app.add_middleware(
    CORSMiddleware,
    allow_origins=allowed_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

MODEL_PATH = "models/wattwais_iflex_xgboost.pkl"
model_path = Path(MODEL_PATH)


def _sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


try:
    model = joblib.load(MODEL_PATH)
except Exception as e:
    model = None
    model_load_error = str(e)
else:
    model_load_error = None


class ApplianceInput(BaseModel):
    name: str = Field(min_length=1, max_length=80)
    quantity: int = Field(ge=1, le=1000)
    watts: float = Field(ge=0.0, le=100000.0)
    hours_per_day: float = Field(ge=0.0, le=24.0)
    days_per_week: int = Field(ge=0, le=7)


class PredictionRequest(BaseModel):
    appliances: List[ApplianceInput]
    base_rate: float = Field(ge=0.0, le=1000.0)
    six_month_total_bill: float = Field(ge=0.0)
    six_month_total_kwh: float = Field(ge=0.0)
    monthly_budget: Optional[float] = Field(default=None, ge=0.0, le=1e9)


@app.get("/")
def health_check():
    return {"status": "ok", "message": "wattwais backend running"}


@app.get("/version")
def version():
    build_time = os.getenv("BUILD_TIME") or datetime.utcnow().isoformat() + "Z"
    if model_path.exists():
        try:
            model_sha256 = _sha256_file(model_path)
        except Exception as e:
            model_sha256 = None
            sha_err = str(e)
        else:
            sha_err = None
    else:
        model_sha256 = None
        sha_err = "model file not found"

    return {
        "build_time": build_time,
        "env": os.getenv("ENV", "development"),
        "model_file": str(model_path),
        "model_sha256": model_sha256,
        "model_loaded": model is not None,
        "model_load_error": model_load_error,
        "sha256_error": sha_err,
    }


def compute_appliance_monthly_kwh(appliances: List[ApplianceInput]):
    appliance_breakdown = []
    total_monthly_kwh = 0

    for item in appliances:
        daily_kwh = (item.watts * item.quantity * item.hours_per_day) / 1000
        weekly_kwh = daily_kwh * item.days_per_week
        monthly_kwh = weekly_kwh * 4.345

        total_monthly_kwh += monthly_kwh

        appliance_breakdown.append({
            "name": item.name,
            "quantity": item.quantity,
            "watts": item.watts,
            "hours_per_day": item.hours_per_day,
            "days_per_week": item.days_per_week,
            "monthly_kwh": round(monthly_kwh, 2)
        })

    return total_monthly_kwh, appliance_breakdown


def build_model_features(avg_hourly_kwh: float):
    now = datetime.now()

    hour = now.hour
    day_of_week = now.weekday()
    month = now.month
    day = now.day
    is_weekend = 1 if day_of_week in [5, 6] else 0

    features = pd.DataFrame([{
        "hour": hour,
        "day_of_week": day_of_week,
        "month": month,
        "day": day,
        "is_weekend": is_weekend,

        "Experiment_price_NOK_kWh": 1.0,
        "Temperature": 28.0,
        "Temperature24": 28.0,
        "Temperature48": 28.0,
        "Temperature72": 28.0,

        "lag_1": avg_hourly_kwh,
        "lag_24": avg_hourly_kwh,
        "lag_168": avg_hourly_kwh,
        "rolling_24": avg_hourly_kwh,
        "rolling_168": avg_hourly_kwh,

        "Region": "Oslo",
        "Municipality": "Oslo",
        "Participation_Phase": "Phase_2",
        "Control_Price_Phase2": "Price group",
        "Group_Phase2": "H1"
    }])

    return features


@app.post("/predict")
def predict_bill(request: PredictionRequest):
    if model is None:
        raise HTTPException(
            status_code=503,
            detail="Model not loaded. Check /version for model_load_error.",
        )

    if request.six_month_total_kwh == 0 and request.base_rate == 0:
        raise HTTPException(
            status_code=400,
            detail="Provide base_rate > 0 when six_month_total_kwh is 0.",
        )

    appliance_monthly_kwh, appliance_breakdown = compute_appliance_monthly_kwh(request.appliances)

    historical_monthly_kwh = request.six_month_total_kwh / 6
    historical_monthly_bill = request.six_month_total_bill / 6

    historical_rate = (
        request.six_month_total_bill / request.six_month_total_kwh
        if request.six_month_total_kwh > 0
        else request.base_rate
    )

    effective_rate = request.base_rate if request.base_rate > 0 else historical_rate

    blended_monthly_kwh = (
        0.6 * historical_monthly_kwh +
        0.4 * appliance_monthly_kwh
    )

    avg_hourly_kwh = blended_monthly_kwh / 30 / 24

    features = build_model_features(avg_hourly_kwh)

    try:
        predicted_hourly_kwh = float(model.predict(features)[0])
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Prediction failed: {e}")
    model_monthly_kwh = predicted_hourly_kwh * 24 * 30

    estimated_monthly_kwh = (
        0.5 * historical_monthly_kwh +
        0.3 * appliance_monthly_kwh +
        0.2 * model_monthly_kwh
    )

    estimated_bill = estimated_monthly_kwh * effective_rate

    exceeds_budget = (
        estimated_bill > request.monthly_budget
        if request.monthly_budget is not None
        else None
    )

    return {
        "predicted_hourly_kwh": round(predicted_hourly_kwh, 3),
        "model_monthly_kwh": round(model_monthly_kwh, 2),
        "appliance_monthly_kwh": round(appliance_monthly_kwh, 2),
        "historical_monthly_kwh": round(historical_monthly_kwh, 2),
        "estimated_monthly_kwh": round(estimated_monthly_kwh, 2),
        "estimated_bill": round(estimated_bill, 2),
        "effective_rate": round(effective_rate, 2),
        "historical_monthly_bill": round(historical_monthly_bill, 2),
        "exceeds_budget": exceeds_budget,
        "appliance_breakdown": appliance_breakdown,
        "recommendation": "ai recommendation endpoint can use this prediction result plus appliance breakdown."
    }
