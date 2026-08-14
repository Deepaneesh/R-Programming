mean_series <- function(x, na.rm = FALSE) {
  if (na.rm) {
    x[is.na(x)] <- 0
    count <- cumsum(!is.na(x))
    cumsum(x) / count
  } else {
    cumsum(x) / seq_along(x)
  }
}
de_mean_series <- function(mean_series) {
  n <- length(mean_series)
  
  x <- numeric(n)
  x[1] <- mean_series[1]
  
  if (n > 1) {
    for (i in 2:n) {
      x[i] <- i * mean_series[i] - (i - 1) * mean_series[i - 1]
    }
  }
  
  x
}
