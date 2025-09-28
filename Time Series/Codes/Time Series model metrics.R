# Load necessary packages
library(Metrics)

# Define the function
time_accuracy <- function(actual, predicted) {
  # Convert to numeric
  actual <- as.numeric(actual)
  predicted <- as.numeric(predicted)
  
  # Basic length check
  if (length(actual) != length(predicted)) {
    stop("Length of actual and predicted must be the same.")
  }
  
  # Compute metrics
  ss_res <- sum((actual - predicted)^2)
  ss_tot <- sum((actual - mean(actual))^2)
  
  r_squared <- 1 - (ss_res / ss_tot)
  rmse_val <- sqrt(mean((actual - predicted)^2))
  mse_val <- mse(actual, predicted)
  mae_val <- mae(actual, predicted)
  mape_val <- mape(actual, predicted)
  
  # Return as a named vector
  return(c(
    "R-squared" = round(r_squared, 4),
    "RMSE"      = round(rmse_val, 4),
    "MSE"       = round(mse_val, 4),
    "MAE"       = round(mae_val, 4),
    "MAPE (%)"  = round(mape_val * 100, 2)
  ))
}
time_accuracy(actual = test, predicted = forecasted_values$mean)

