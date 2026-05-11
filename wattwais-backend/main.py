from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from xgboost import XGBRegressor
import pandas as pd
import os

app = FastAPI(title="WattwAIs XGBoost Inference API")

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost",
        "http://127.0.0.1",
        "http://localhost:8000",
        "http://127.0.0.1:8000",
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

FEATURE_COLUMNS = [
    "lag_1",
    "lag_2",
    "lag_3",
    "lag_7",
    "rolling_mean_3",
    "rolling_mean_7",
    "day_of_week",
    "month",
    "trend",
]

# Load model with error handling
model = None
model_path = "wattwais_xgboost_daily_model.json"

if os.path.exists(model_path):
    try:
        model = XGBRegressor()
        model.load_model(model_path)
    except Exception as e:
        print(f"Warning: Failed to load model from {model_path}: {str(e)}")
        model = None
else:
    print(f"Warning: Model file not found at {model_path}")
    print("Please place the trained XGBoost model file in the wattwais-backend/ directory")


class PredictionRequest(BaseModel):
    lag_1: float
    lag_2: float
    lag_3: float
    lag_7: float
    rolling_mean_3: float
    rolling_mean_7: float
    day_of_week: int
    month: int
    trend: int
    rate_per_kwh: float
    budget: float


@app.get("/")
def health_check():
    return {"status": "ok", "message": "wattwais inference api running"}


@app.post("/predict")
def predict_bill(data: PredictionRequest):
    if model is None:
        raise HTTPException(
            status_code=503,
            detail="Model is not loaded. Please ensure wattwais_xgboost_daily_model.json is placed in the wattwais-backend/ directory."
        )
    
    try:
        input_df = pd.DataFrame([{
            "lag_1": data.lag_1,
            "lag_2": data.lag_2,
            "lag_3": data.lag_3,
            "lag_7": data.lag_7,
            "rolling_mean_3": data.rolling_mean_3,
            "rolling_mean_7": data.rolling_mean_7,
            "day_of_week": data.day_of_week,
            "month": data.month,
            "trend": data.trend,
        }], columns=FEATURE_COLUMNS)

        predicted_daily_kwh = float(model.predict(input_df)[0])
        predicted_daily_kwh = max(predicted_daily_kwh, 0)

        estimated_monthly_kwh = predicted_daily_kwh * 30
        estimated_bill = estimated_monthly_kwh * data.rate_per_kwh
        exceeds_budget = estimated_bill > data.budget

        budget_gap = estimated_bill - data.budget

        if exceeds_budget:
            recommendation = (
                f"your predicted bill may exceed your budget by approximately ₱{budget_gap:.2f}. "
                "consider reducing usage of high-consumption appliances such as air conditioners, heaters, or dryers."
            )
        else:
            recommendation = (
                "your predicted bill is within budget. continue monitoring high-consumption appliances to maintain usage."
            )

        return {
            "predicted_daily_kwh": round(predicted_daily_kwh, 2),
            "estimated_monthly_kwh": round(estimated_monthly_kwh, 2),
            "estimated_bill": round(estimated_bill, 2),
            "budget": round(data.budget, 2),
            "exceeds_budget": exceeds_budget,
            "recommendation": recommendation,
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))