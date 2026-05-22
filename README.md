# WattwAIs

WattwAIs is a mobile application designed to help households predict electricity bills, monitor energy usage, and receive recommendations for reducing electricity consumption.

##  Developers

This project was developed by **Bretana, Buerom, Melchor, and Verde**  
for **CMSC 156: Mobile Development Final Project**.

## Features

### Predict Bill Form
- Enter appliance usage details  
- Provide 6‑month bill history  
- Set base rate and monthly budget  
- Predict and save results  

### Home Dashboard
- View latest estimated bill and kWh  
- Calculate daily average from prediction  
- Highlight top appliance usage share  
- Display AI insight with fallback  

### Stats
- Chart monthly kWh trend  
- Show next billing estimate  
- Explain trend using AI insight  
- Use latest prediction data source  

### Tips
- Summarize latest prediction status  
- Provide appliance‑based recommendations  
- Use Gemini tips when available  
- Fall back to rule‑based tips  

## Tech Stack

- **Flutter** – for UI, navigation, and local interaction  
- **Firebase** – for authentication and storing user/prediction records  
- **Dart** - programming language used together with Flutter
- **FastAPI** – backend service for prediction and AI insights endpoints  
- **XGBoost** – machine learning model for bill prediction and usage forecasting  
- **Gemini AI** – contextual recommendations with fallback rule-based models  

## Backend (local)

From `wattwais-backend/`:

```bash
pip install -r requirements-render.txt
uvicorn main:app --host 0.0.0.0 --port 8000
```

## App run commands

- Firebase config is now read from compile-time env values.
  - Copy `.env.example` to `.env` and fill in your real Firebase values.
  - Run with `--dart-define-from-file=.env`.

- Android emulator (backend running on your machine):
  - `flutter run --dart-define-from-file=.env --dart-define=PREDICT_API_BASE_URL=http://10.0.2.2:8000`
- Physical phone / Web (use Render backend):
  - `flutter run --dart-define-from-file=.env --dart-define=PREDICT_API_BASE_URL=https://wattwais.onrender.com`

Note: In release builds, the app falls back to the URL in `lib/core/config/app_config.dart` if `PREDICT_API_BASE_URL` is not provided.
