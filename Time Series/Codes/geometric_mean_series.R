geometric_mean_series <- function(x) { 
  if (any(x <= 0, na.rm = TRUE)) { 
    stop("All non-NA values of x must be greater than 0.") 
  } 
  exp(cumsum(log(x)) / seq_along(x)) 
}

de_geometric_mean_series <- function(x) {
  
  if (any(x <= 0, na.rm = TRUE)) {
    stop("All non-NA values of x must be greater than 0.")
  }
  
  n <- seq_along(x)
  
  result <- numeric(length(x))
  
  result[1] <- x[1]
  
  if (length(x) > 1) {
    result[-1] <- x[-1]^n[-1] / x[-length(x)]^n[-length(x)]
  }
  
  result
}


