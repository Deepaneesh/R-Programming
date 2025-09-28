library(prophet)
library(tibble)
library(dplyr)
library(ggplot2)

prophet_data <- tibble(
  ds = seq(from = as.Date("1949-01-01"), by = "month", length.out = length(AirPassengers)),
  y  = as.numeric(AirPassengers)
)

n <- nrow(prophet_data)
split_index <- floor(0.8 * n)

train <- prophet_data[1:split_index, ]
test  <- prophet_data[(split_index + 1):n, ]

m <- prophet(train, seasonality.mode = "multiplicative")
nrow(train)
h <- nrow(test)  # forecast horizon
future <- make_future_dataframe(m, periods = h, freq = "month")
forecast <- predict(m, future)

plot(m, forecast) 

results=s <- data.frame(
  y = test$y,
  yhat = forecast$yhat[(nrow(train) + 1):nrow(forecast)],
  ds = test$ds
)

# Calculate accuracy metrics
library(Metrics)
rmse_val <- rmse(results$y, results$yhat)
mae_val  <- mae(results$y, results$yhat)
mape_val <- mape(results$y, results$yhat)

cat("RMSE:", rmse_val, "\nMAE:", mae_val, "\nMAPE:", mape_val, "\n")


# Actual values (full series)
actual <- prophet_data$y

# Get only predicted values for the test period
n_train <- nrow(train)
n_total <- nrow(prophet_data)
predicted <- c(rep(NA, n_train), forecast$yhat[(n_train + 1):n_total])

# Combine into a data frame
data1 <- data.frame(
  date = prophet_data$ds,
  actual = actual,
  predicted = predicted
)
library(ggplot2)

ggplot(data1, aes(x = date)) +
  geom_line(aes(y = actual), color = "black", size = 1) +
  geom_line(aes(y = predicted), color = "blue", size = 1, linetype = "dashed") +
  labs(title = "Actual vs Predicted (Prophet)", y = "Passengers") +
  theme_minimal()

# prophet for whole data
m_full <- prophet(prophet_data, seasonality.mode = "multiplicative")
future_full <- make_future_dataframe(m_full, periods = 24, freq = "month")
forecast_full <- predict(m_full, future_full)
plot(m_full, forecast_full)


# full result
results_full <- data.frame(
  y = prophet_data$y,
  yhat = forecast_full$yhat[1:nrow(prophet_data)],
  ds = prophet_data$ds
)
# Calculate accuracy metrics for full data
rmse_val_full <- rmse(results_full$y, results_full$yhat)
mae_val_full  <- mae(results_full$y, results_full$yhat)
mape_val_full <- mape(results_full$y, results_full$yhat)
cat("Full Data RMSE:", rmse_val_full, "\nMAE:", mae_val_full, "\nMAPE:", mape_val_full, "\n")
