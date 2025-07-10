# 📦 Load required libraries
library(tidymodels)
library(modeltime)
library(timetk)
library(dplyr)
library(lubridate)
library(ggplot2)

# 📈 Step 1: Load and Prepare Data
data("AirPassengers")
air_df <- tibble(
  date  = as.Date(as.yearmon(time(AirPassengers))),
  value = as.numeric(AirPassengers)
)

# Split into training and testing
splits <- initial_time_split(air_df, prop = 0.9)

# ──────────────────────────────────────────────
# 🧱 Step 2: Fit Models on Training Data
# ──────────────────────────────────────────────

model_fit_arima <- arima_reg() %>%
  set_engine("auto_arima") %>%
  fit(value ~ date, data = training(splits))

model_fit_ets <- exp_smoothing() %>%
  set_engine("ets") %>%
  fit(value ~ date, data = training(splits))

model_fit_prophet <- prophet_reg() %>%
  set_engine("prophet") %>%
  fit(value ~ date, data = training(splits))

# Create a modeltime table
models_tbl <- modeltime_table(
  model_fit_arima,
  model_fit_ets,
  model_fit_prophet
)

# 🌟 Create an Ensemble Model (Average)
ensemble_model <- ensemble_average(models_tbl)
ensemble_tbl <- modeltime_table(ensemble_model)

# Combine all 4 models
all_models_tbl <- bind_rows(models_tbl, ensemble_tbl)

# ──────────────────────────────────────────────
# 📊 Step 3: Evaluate on Testing Set
# ──────────────────────────────────────────────

calibration_tbl <- all_models_tbl %>%
  modeltime_calibrate(new_data = testing(splits))

# Show Accuracy Metrics
print("🔍 Accuracy Metrics (Test Set):")
calibration_tbl %>%
  modeltime_accuracy()

# Plot Predictions vs Actuals (Testing Period)
calibration_tbl %>%
  modeltime_forecast(
    new_data = testing(splits),
    actual_data = air_df
  ) %>%
  plot_modeltime_forecast()

# ──────────────────────────────────────────────
# 🔄 Step 4: Refit All Models on Full Dataset
# ──────────────────────────────────────────────

all_models_refit <- all_models_tbl %>%
  modeltime_refit(data = air_df)

# 🔮 Step 5: Forecast for Next 12 Months
future_tbl <- air_df %>%
  future_frame(.date_var = date, .length_out = 12)

forecast_tbl <- all_models_refit %>%
  modeltime_forecast(new_data = future_tbl, actual_data = air_df)

# 📈 Plot All Forecasts
forecast_tbl %>%
  plot_modeltime_forecast()

# 🧾 View Forecast Table
View(forecast_tbl)
