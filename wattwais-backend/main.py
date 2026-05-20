from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional
import pandas as pd
import numpy as np
import joblib
from datetime import datetime

app = FastAPI(title="wattwais prediction api")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

MODEL_PATH = "models/wattwais_iflex_xgboost.pkl"
model = joblib.load(MODEL_PATH)


class ApplianceInput(BaseModel):
    name: str
    quantity: int
    watts: float
    hours_per_day: float
    days_per_week: int


class PredictionRequest(BaseModel):
    appliances: List[ApplianceInput]
    base_rate: float
    six_month_total_bill: float
    six_month_total_kwh: float
    monthly_budget: Optional[float] = None


@app.get("/")
def health_check():
    return {"status": "ok", "message": "wattwais backend running"}


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

    predicted_hourly_kwh = float(model.predict(features)[0])
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
