
check_seasonality <- function(x,
                              metric = c("AICc", "RMSE", "MAE")) {
  
  metric <- match.arg(metric)
  
  # Fit additive model
  fit_add <- ets(x, model = "AAA")
  
  # Fit multiplicative model
  fit_mul <- tryCatch(
    ets(x, model = "MMM"),
    error = function(e) NULL
  )
  
  # If multiplicative model cannot be fitted
  if (is.null(fit_mul))
    return("Additive")
  
  # Compare selected metric
  err_add <- switch(metric,
                    AICc = fit_add$aicc,
                    RMSE = accuracy(fit_add)[1, "RMSE"],
                    MAE  = accuracy(fit_add)[1, "MAE"])
  
  err_mul <- switch(metric,
                    AICc = fit_mul$aicc,
                    RMSE = accuracy(fit_mul)[1, "RMSE"],
                    MAE  = accuracy(fit_mul)[1, "MAE"])
  
  if (err_add < err_mul) {
    return("Additive")
  } else {
    return("Multiplicative")
  }
}
