
library(modeltime)
library(tidymodels)
library(timetk)
library(dplyr)
library(lubridate)
library(ggplot2)
library(zoo)
library(modeltime.ensemble)

#defining data
data <- tibble(
  date  = as.Date(as.yearmon(time(AirPassengers))),
  value = as.numeric(AirPassengers)
)
# data Spliting
splits <- initial_time_split(data, prop = 0.9)

# Model Defining
model_arima <- arima_reg() %>%
  set_engine("auto_arima") %>%
  fit(value ~ date, data = training(splits))

model_ets <- exp_smoothing(seasonal_period = 12) %>%
  set_engine("ets") %>%
  fit(value ~ date, data = training(splits))

model_prophet <- prophet_reg() %>%
  set_engine("prophet") %>%
  fit(value ~ date, data = training(splits))

# model table
models_tbl <- modeltime_table(
  model_arima,
  model_ets,
  model_prophet
)

# predicting for test data
calibration_tbl <- models_tbl %>%
  modeltime_calibrate(new_data = testing(splits))

calibration_tbl %>%
  modeltime_forecast(
    new_data = testing(splits),
    actual_data = data
  ) %>%
  plot_modeltime_forecast()

# Evolution of models
calibration_tbl %>%
  modeltime_accuracy() %>%
  arrange(rmse)

# Refit for the entire dataset
refit_tbl <- calibration_tbl %>%
  modeltime_refit(data = data)

# Forecasting for the next 12 months
future_tbl <- data %>%
  future_frame(.date_var = date, .length_out = 12)

forecast_future <- refit_tbl %>%
  modeltime_forecast(new_data = future_tbl, actual_data = data)

# Plotting the forecast
forecast_future %>%
  plot_modeltime_forecast()

# View future values
forecast_future %>%
  select(.model_desc, .index, .value, .conf_lo, .conf_hi) %>% View()

forecast_future %>% View()



