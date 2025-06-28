library("tseries")
library("forecast")
library("ggplot2")

data= AirPassengers
ts_data <- ts(data, frequency = 12, start = c(1949, 1))
plot(ts_data, main = "AirPassengers Time Series", ylab = "Passengers", xlab = "Time")

split_ts_by_ratio <- function(ts_data, split_ratio = 0.8) {
  # Validate input
  if (!is.ts(ts_data)) stop("Input must be a 'ts' object.")
  if (!is.numeric(split_ratio) || split_ratio <= 0 || split_ratio >= 1) {
    stop("split_ratio must be a number between 0 and 1 (e.g., 0.8 for 80/20).")
  }
  
  n_total <- length(ts_data)
  n_train <- floor(split_ratio * n_total)
  
  if (n_train < 1 || n_train >= n_total) {
    stop("Invalid split: not enough data for train/test split.")
  }
  
  # Time values for splitting
  time_index <- time(ts_data)
  
  # Split using window()
  ts_train <- window(ts_data, end = time_index[n_train])
  ts_test  <- window(ts_data, start = time_index[n_train + 1])
  
  return(list(
    train = ts_train,
    test = ts_test,
    split_ratio = split_ratio,
    n_train = n_train,
    n_test = n_total - n_train
  ))
}

split_result <- split_ts_by_ratio(ts_data, split_ratio = 0.8)
# Print the split results
print(split_result)
split_result$train %>% autoplot() +
  ggtitle("Training Set") +
  ylab("Passengers") +
  xlab("Time")
