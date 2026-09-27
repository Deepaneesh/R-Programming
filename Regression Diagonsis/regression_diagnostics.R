regression_diagnostics <- function(
    data,
    dependent,
    independent,
    intercept = TRUE,
    use_weights = FALSE,
    weights = NULL,
    alpha = 0.05,
    bg_order = 1
) {
  
  # =========================================================
  # 1. VALIDATION
  # =========================================================
  
  if (!is.data.frame(data)) {
    stop("data must be a data.frame.")
  }
  
  if (!is.character(dependent) || length(dependent) != 1) {
    stop("dependent must be a single column name.")
  }
  
  if (!dependent %in% names(data)) {
    stop("Dependent variable not found in data.")
  }
  
  if (!is.character(independent) || length(independent) == 0) {
    stop("independent must contain at least one column name.")
  }
  
  if (!all(independent %in% names(data))) {
    missing_vars <- independent[
      !independent %in% names(data)
    ]
    
    stop(
      "Independent variable(s) not found: ",
      paste(missing_vars, collapse = ", ")
    )
  }
  
  if (!is.logical(intercept) || length(intercept) != 1) {
    stop("intercept must be TRUE or FALSE.")
  }
  
  if (!is.logical(use_weights) || length(use_weights) != 1) {
    stop("use_weights must be TRUE or FALSE.")
  }
  
  if (!is.null(weights)) {
    
    if (!is.character(weights) || length(weights) != 1) {
      stop("weights must be a single column name or NULL.")
    }
    
    if (!weights %in% names(data)) {
      stop("Weight column not found in data.")
    }
  }
  
  if (!is.numeric(alpha) ||
      length(alpha) != 1 ||
      alpha <= 0 ||
      alpha >= 1) {
    
    stop("alpha must be between 0 and 1.")
  }
  
  if (!is.numeric(bg_order) ||
      length(bg_order) != 1 ||
      bg_order < 1) {
    
    stop("bg_order must be a positive integer.")
  }
  
  bg_order <- as.integer(bg_order)
  
  
  # =========================================================
  # 2. PREPARE DATA
  # =========================================================
  
  required_columns <- unique(
    c(dependent, independent, weights)
  )
  
  model_data <- data[
    ,
    required_columns,
    drop = FALSE
  ]
  
  model_data <- model_data[
    complete.cases(model_data),
    ,
    drop = FALSE
  ]
  
  if (nrow(model_data) < 3) {
    stop("Not enough complete observations.")
  }
  
  
  # =========================================================
  # 3. CREATE FORMULA
  # =========================================================
  
  rhs <- paste(
    independent,
    collapse = " + "
  )
  
  if (intercept) {
    
    formula_text <- paste(
      dependent,
      "~",
      rhs
    )
    
  } else {
    
    formula_text <- paste(
      dependent,
      "~ 0 +",
      rhs
    )
  }
  
  model_formula <- as.formula(
    formula_text
  )
  
  
  # =========================================================
  # 4. INITIAL OLS MODEL
  # =========================================================
  
  initial_model <- lm(
    model_formula,
    data = model_data
  )
  
  
  # =========================================================
  # 5. WEIGHT LOGIC
  # =========================================================
  
  weight_info <- list(
    Used = FALSE,
    Type = "Ordinary Least Squares",
    Column = NULL,
    Formula = NULL
  )
  
  if (!use_weights) {
    
    model <- initial_model
    
  } else {
    
    # -----------------------------------------------------
    # User supplied weights
    # -----------------------------------------------------
    
    if (!is.null(weights)) {
      
      supplied_weights <- model_data[[weights]]
      
      if (!is.numeric(supplied_weights)) {
        stop("Weight column must be numeric.")
      }
      
      if (any(
        !is.finite(supplied_weights) |
        supplied_weights <= 0
      )) {
        
        stop(
          "Weights must contain only positive finite values."
        )
      }
      
      model <- lm(
        model_formula,
        data = model_data,
        weights = supplied_weights
      )
      
      weight_info <- list(
        Used = TRUE,
        Type = "User supplied weights",
        Column = weights,
        Formula = NULL
      )
      
    } else {
      
      # -------------------------------------------------
      # Automatic weights
      # -------------------------------------------------
      
      initial_residuals <- residuals(
        initial_model
      )
      
      automatic_weights <- 1 /
        (1 + initial_residuals^2)
      
      model <- lm(
        model_formula,
        data = model_data,
        weights = automatic_weights
      )
      
      weight_info <- list(
        Used = TRUE,
        Type = "Automatic residual-based weights",
        Column = NULL,
        Formula = "1 / (1 + residual^2)",
        Weights = automatic_weights
      )
    }
  }
  
  
  # =========================================================
  # 6. MODEL SUMMARY
  # =========================================================
  
  model_summary <- summary(model)
  
  actual <- model.response(
    model.frame(model)
  )
  
  fitted_values <- fitted(model)
  
  residuals_model <- residuals(model)
  
  
  # =========================================================
  # 7. REGRESSION METRICS
  # =========================================================
  
  error <- actual - fitted_values
  
  rmse <- sqrt(
    mean(error^2)
  )
  
  mse <- mean(
    error^2
  )
  
  mae <- mean(
    abs(error)
  )
  
  me <- mean(
    error
  )
  
  mpe <- mean(
    ifelse(
      actual != 0,
      error / actual * 100,
      NA_real_
    ),
    na.rm = TRUE
  )
  
  mape <- mean(
    ifelse(
      actual != 0,
      abs(error / actual) * 100,
      NA_real_
    ),
    na.rm = TRUE
  )
  
  smape <- mean(
    ifelse(
      abs(actual) + abs(fitted_values) != 0,
      2 * abs(error) /
        (abs(actual) + abs(fitted_values)) * 100,
      NA_real_
    ),
    na.rm = TRUE
  )
  
  # MASE
  naive_errors <- diff(actual)
  
  if (
    length(naive_errors) > 0 &&
    mean(
      abs(naive_errors),
      na.rm = TRUE
    ) != 0
  ) {
    
    mase <- mae /
      mean(
        abs(naive_errors),
        na.rm = TRUE
      )
    
  } else {
    
    mase <- NA_real_
  }
  
  metrics <- data.frame(
    Metric = c(
      "R2",
      "Adjusted R2",
      "RMSE",
      "MSE",
      "MAE",
      "ME",
      "MPE",
      "MAPE",
      "sMAPE",
      "MASE",
      "AIC",
      "BIC",
      "N",
      "Residual DF"
    ),
    Value = c(
      model_summary$r.squared,
      model_summary$adj.r.squared,
      rmse,
      mse,
      mae,
      me,
      mpe,
      mape,
      smape,
      mase,
      AIC(model),
      BIC(model),
      nobs(model),
      df.residual(model)
    ),
    row.names = NULL
  )
  
  
  # =========================================================
  # 8. CORRELATION MATRIX
  #    Dependent + Independent + Residuals
  # =========================================================
  
  correlation_data <- model.frame(model)
  
  correlation_data$Residuals <- residuals_model
  
  numeric_data <- correlation_data[
    vapply(
      correlation_data,
      is.numeric,
      logical(1)
    )
  ]
  
  correlation <- cor(
    numeric_data,
    use = "pairwise.complete.obs",
    method = "pearson"
  )
  
  
  # =========================================================
  # 9. MULTICOLLINEARITY
  # =========================================================
  
  if (length(independent) >= 2) {
    
    vif_error <- NULL
    
    vif_raw <- tryCatch(
      car::vif(model),
      error = function(e) {
        
        vif_error <<- conditionMessage(e)
        
        NULL
      }
    )
    
    if (!is.null(vif_raw)) {
      
      if (is.matrix(vif_raw)) {
        
        vif_values <- vif_raw[, 1]
        
        if ("Df" %in% colnames(vif_raw)) {
          
          vif_values <- vif_values ^
            (
              1 /
                (
                  2 *
                    vif_raw[, "Df"]
                )
            )
        }
        
      } else {
        
        vif_values <- vif_raw
      }
      
      tolerance <- 1 / vif_values
      
      vif_table <- data.frame(
        Variable = names(vif_values),
        VIF = as.numeric(vif_values),
        Tolerance = as.numeric(tolerance),
        Status = ifelse(
          vif_values > 5,
          "MULTICOLLINEARITY PRESENT",
          "No significant multicollinearity detected"
        ),
        row.names = NULL
      )
      
      multicollinearity <- list(
        Test = "Variance Inflation Factor",
        VIF = vif_table,
        Threshold = 5,
        Status = ifelse(
          any(
            vif_values > 5,
            na.rm = TRUE
          ),
          "MULTICOLLINEARITY PRESENT",
          "No significant multicollinearity detected"
        ),
        Reason = ifelse(
          any(
            vif_values > 5,
            na.rm = TRUE
          ),
          paste(
            "VIF > 5 for:",
            paste(
              names(vif_values)[
                vif_values > 5
              ],
              collapse = ", "
            )
          ),
          "All VIF values are <= 5."
        )
      )
      
    } else {
      
      vif_table <- data.frame(
        Variable = independent,
        VIF = NA_real_,
        Tolerance = NA_real_,
        Status = "VIF could not be calculated"
      )
      
      multicollinearity <- list(
        Test = "Variance Inflation Factor",
        VIF = vif_table,
        Threshold = 5,
        Status = "Test could not be performed",
        Reason = vif_error
      )
    }
    
  } else {
    
    vif_table <- data.frame(
      Variable = independent,
      VIF = NA_real_,
      Tolerance = NA_real_,
      Status = "VIF requires at least two predictors"
    )
    
    multicollinearity <- list(
      Test = "Variance Inflation Factor",
      VIF = vif_table,
      Threshold = 5,
      Status = "Not applicable",
      Reason = "Only one independent variable was supplied."
    )
  }
  
  
  # =========================================================
  # 10. BREUSCH-PAGAN TEST
  # =========================================================
  
  bp_error <- NULL
  
  bp_test <- tryCatch(
    lmtest::bptest(model),
    error = function(e) {
      
      bp_error <<- conditionMessage(e)
      
      NULL
    }
  )
  
  if (!is.null(bp_test)) {
    
    bp_statistic <- as.numeric(
      bp_test$statistic
    )
    
    bp_pvalue <- as.numeric(
      bp_test$p.value
    )
    
    bp_status <- ifelse(
      bp_pvalue < alpha,
      "HETEROSCEDASTICITY PRESENT",
      "No significant heteroscedasticity detected"
    )
    
    bp_reason <- ifelse(
      bp_pvalue < alpha,
      paste0(
        "p-value (",
        signif(bp_pvalue, 4),
        ") < alpha (",
        alpha,
        ")"
      ),
      paste0(
        "p-value (",
        signif(bp_pvalue, 4),
        ") >= alpha (",
        alpha,
        ")"
      )
    )
    
    homoscedasticity <- list(
      Test = "Breusch-Pagan Test",
      Statistic = bp_statistic,
      P_Value = bp_pvalue,
      Alpha = alpha,
      Status = bp_status,
      Reason = bp_reason,
      Result = bp_test
    )
    
  } else {
    
    homoscedasticity <- list(
      Test = "Breusch-Pagan Test",
      Statistic = NA_real_,
      P_Value = NA_real_,
      Alpha = alpha,
      Status = "Test could not be performed",
      Reason = bp_error,
      Result = NULL
    )
  }
  
  
  # =========================================================
  # 11. DURBIN-WATSON TEST
  # =========================================================
  
  dw_error <- NULL
  
  dw_test <- tryCatch(
    lmtest::dwtest(model),
    error = function(e) {
      
      dw_error <<- conditionMessage(e)
      
      NULL
    }
  )
  
  if (!is.null(dw_test)) {
    
    dw_statistic <- as.numeric(
      dw_test$statistic
    )
    
    dw_pvalue <- as.numeric(
      dw_test$p.value
    )
    
    dw_status <- ifelse(
      dw_pvalue < alpha,
      "AUTOCORRELATION PRESENT",
      "No significant first-order autocorrelation detected"
    )
    
    dw_reason <- ifelse(
      dw_pvalue < alpha,
      paste0(
        "p-value (",
        signif(dw_pvalue, 4),
        ") < alpha (",
        alpha,
        ")"
      ),
      paste0(
        "p-value (",
        signif(dw_pvalue, 4),
        ") >= alpha (",
        alpha,
        ")"
      )
    )
    
    durbin_watson <- list(
      Test = "Durbin-Watson Test",
      Statistic = dw_statistic,
      P_Value = dw_pvalue,
      Alpha = alpha,
      Status = dw_status,
      Reason = dw_reason,
      Result = dw_test
    )
    
  } else {
    
    durbin_watson <- list(
      Test = "Durbin-Watson Test",
      Statistic = NA_real_,
      P_Value = NA_real_,
      Alpha = alpha,
      Status = "Test could not be performed",
      Reason = dw_error,
      Result = NULL
    )
  }
  
  
  # =========================================================
  # 12. BREUSCH-GODFREY TEST
  # =========================================================
  
  bg_error <- NULL
  
  bg_test <- tryCatch(
    lmtest::bgtest(
      model,
      order = bg_order
    ),
    error = function(e) {
      
      bg_error <<- conditionMessage(e)
      
      NULL
    }
  )
  
  if (!is.null(bg_test)) {
    
    bg_statistic <- as.numeric(
      bg_test$statistic
    )
    
    bg_pvalue <- as.numeric(
      bg_test$p.value
    )
    
    bg_status <- ifelse(
      bg_pvalue < alpha,
      "AUTOCORRELATION PRESENT",
      paste0(
        "No significant serial correlation detected up to lag ",
        bg_order
      )
    )
    
    bg_reason <- ifelse(
      bg_pvalue < alpha,
      paste0(
        "p-value (",
        signif(bg_pvalue, 4),
        ") < alpha (",
        alpha,
        ")"
      ),
      paste0(
        "p-value (",
        signif(bg_pvalue, 4),
        ") >= alpha (",
        alpha,
        ")"
      )
    )
    
    breusch_godfrey <- list(
      Test = "Breusch-Godfrey Test",
      Order = bg_order,
      Statistic = bg_statistic,
      P_Value = bg_pvalue,
      Alpha = alpha,
      Status = bg_status,
      Reason = bg_reason,
      Result = bg_test
    )
    
  } else {
    
    breusch_godfrey <- list(
      Test = "Breusch-Godfrey Test",
      Order = bg_order,
      Statistic = NA_real_,
      P_Value = NA_real_,
      Alpha = alpha,
      Status = "Test could not be performed",
      Reason = bg_error,
      Result = NULL
    )
  }
  
  
  # =========================================================
  # 13. AUTOCORRELATION
  # =========================================================
  
  autocorrelation <- list(
    Durbin_Watson = durbin_watson,
    Breusch_Godfrey = breusch_godfrey
  )
  
  
  # =========================================================
  # 14. RESIDUAL DIAGNOSTICS
  # =========================================================
  
  residual_diagnostics <- data.frame(
    Metric = c(
      "Mean Residual",
      "SD Residual",
      "Minimum Residual",
      "Maximum Residual"
    ),
    Value = c(
      mean(residuals_model),
      sd(residuals_model),
      min(residuals_model),
      max(residuals_model)
    ),
    row.names = NULL
  )
  
  
  # =========================================================
  # 15. FINAL RESULT OBJECT
  # =========================================================
  
  result <- list(
    model = model,
    formula = formula(model),
    metrics = metrics,
    summary = model_summary,
    correlation = correlation,
    multicollinearity = multicollinearity,
    homoscedasticity = homoscedasticity,
    autocorrelation = autocorrelation,
    residual_diagnostics = residual_diagnostics,
    weights = weight_info
  )
  
  
  # =========================================================
  # 16. PRINT REPORT
  # =========================================================
  
  cat("\n")
  cat("============================================================\n")
  cat("             REGRESSION DIAGNOSTICS REPORT\n")
  cat("============================================================\n")
  
  
  # ---------------------------------------------------------
  # Formula
  # ---------------------------------------------------------
  
  cat("\nMODEL FORMULA\n")
  cat("------------------------------------------------------------\n")
  print(formula(model))
  
  
  # ---------------------------------------------------------
  # Metrics
  # ---------------------------------------------------------
  
  cat("\n1. MODEL METRICS\n")
  cat("------------------------------------------------------------\n")
  
  print(
    metrics,
    row.names = FALSE
  )
  
  
  # ---------------------------------------------------------
  # Summary
  # ---------------------------------------------------------
  
  cat("\n2. REGRESSION SUMMARY\n")
  cat("------------------------------------------------------------\n")
  
  print(model_summary)
  
  
  # ---------------------------------------------------------
  # Correlation
  # ---------------------------------------------------------
  
  cat("\n3. CORRELATION MATRIX\n")
  cat("------------------------------------------------------------\n")
  
  print(
    round(
      correlation,
      3
    )
  )
  
  
  # ---------------------------------------------------------
  # Multicollinearity
  # ---------------------------------------------------------
  
  cat("\n4. MULTICOLLINEARITY\n")
  cat("------------------------------------------------------------\n")
  
  print(
    vif_table,
    row.names = FALSE
  )
  
  cat(
    "\nThreshold:",
    multicollinearity$Threshold,
    "\n"
  )
  
  cat(
    "Result:",
    multicollinearity$Status,
    "\n"
  )
  
  cat(
    "Reason:",
    multicollinearity$Reason,
    "\n"
  )
  
  
  # ---------------------------------------------------------
  # Homoscedasticity
  # ---------------------------------------------------------
  
  cat("\n5. HOMOSCEDASTICITY\n")
  cat("------------------------------------------------------------\n")
  
  cat(
    "Test:",
    homoscedasticity$Test,
    "\n"
  )
  
  if (
    is.numeric(homoscedasticity$Statistic) &&
    length(homoscedasticity$Statistic) == 1 &&
    !is.na(homoscedasticity$Statistic)
  ) {
    
    cat(
      "Statistic:",
      round(
        homoscedasticity$Statistic,
        4
      ),
      "\n"
    )
    
  } else {
    
    cat(
      "Statistic: Not available\n"
    )
  }
  
  if (
    is.numeric(homoscedasticity$P_Value) &&
    length(homoscedasticity$P_Value) == 1 &&
    !is.na(homoscedasticity$P_Value)
  ) {
    
    cat(
      "P-value:",
      signif(
        homoscedasticity$P_Value,
        5
      ),
      "\n"
    )
    
  } else {
    
    cat(
      "P-value: Not available\n"
    )
  }
  
  cat(
    "Result:",
    homoscedasticity$Status,
    "\n"
  )
  
  cat(
    "Reason:",
    homoscedasticity$Reason,
    "\n"
  )
  
  
  # ---------------------------------------------------------
  # Autocorrelation
  # ---------------------------------------------------------
  
  cat("\n6. AUTOCORRELATION\n")
  cat("------------------------------------------------------------\n")
  
  
  # Durbin-Watson
  
  cat(
    "\n",
    durbin_watson$Test,
    "\n",
    sep = ""
  )
  
  if (
    is.numeric(durbin_watson$Statistic) &&
    length(durbin_watson$Statistic) == 1 &&
    !is.na(durbin_watson$Statistic)
  ) {
    
    cat(
      "Statistic:",
      round(
        durbin_watson$Statistic,
        4
      ),
      "\n"
    )
    
  } else {
    
    cat(
      "Statistic: Not available\n"
    )
  }
  
  if (
    is.numeric(durbin_watson$P_Value) &&
    length(durbin_watson$P_Value) == 1 &&
    !is.na(durbin_watson$P_Value)
  ) {
    
    cat(
      "P-value:",
      signif(
        durbin_watson$P_Value,
        5
      ),
      "\n"
    )
    
  } else {
    
    cat(
      "P-value: Not available\n"
    )
  }
  
  cat(
    "Result:",
    durbin_watson$Status,
    "\n"
  )
  
  cat(
    "Reason:",
    durbin_watson$Reason,
    "\n"
  )
  
  
  # Breusch-Godfrey
  
  cat(
    "\n",
    breusch_godfrey$Test,
    " (lag ",
    bg_order,
    ")\n",
    sep = ""
  )
  
  if (
    is.numeric(breusch_godfrey$Statistic) &&
    length(breusch_godfrey$Statistic) == 1 &&
    !is.na(breusch_godfrey$Statistic)
  ) {
    
    cat(
      "Statistic:",
      round(
        breusch_godfrey$Statistic,
        4
      ),
      "\n"
    )
    
  } else {
    
    cat(
      "Statistic: Not available\n"
    )
  }
  
  if (
    is.numeric(breusch_godfrey$P_Value) &&
    length(breusch_godfrey$P_Value) == 1 &&
    !is.na(breusch_godfrey$P_Value)
  ) {
    
    cat(
      "P-value:",
      signif(
        breusch_godfrey$P_Value,
        5
      ),
      "\n"
    )
    
  } else {
    
    cat(
      "P-value: Not available\n"
    )
  }
  
  cat(
    "Result:",
    breusch_godfrey$Status,
    "\n"
  )
  
  cat(
    "Reason:",
    breusch_godfrey$Reason,
    "\n"
  )
  
  
  # ---------------------------------------------------------
  # Weight Information
  # ---------------------------------------------------------
  
  cat("\n7. WEIGHT INFORMATION\n")
  cat("------------------------------------------------------------\n")
  
  cat(
    "Weights used:",
    weight_info$Used,
    "\n"
  )
  
  cat(
    "Type:",
    weight_info$Type,
    "\n"
  )
  
  if (!is.null(weight_info$Column)) {
    
    cat(
      "Weight column:",
      weight_info$Column,
      "\n"
    )
  }
  
  if (!is.null(weight_info$Formula)) {
    
    cat(
      "Weight formula:",
      weight_info$Formula,
      "\n"
    )
  }
  
  
  # ---------------------------------------------------------
  # Residual Diagnostics
  # ---------------------------------------------------------
  
  cat("\n8. RESIDUAL DIAGNOSTICS\n")
  cat("------------------------------------------------------------\n")
  
  print(
    residual_diagnostics,
    row.names = FALSE
  )
  
  
  # ---------------------------------------------------------
  # End
  # ---------------------------------------------------------
  
  cat("\n")
  cat("============================================================\n")
  cat("                 END OF DIAGNOSTICS\n")
  cat("============================================================\n")
  
  
  # Return result
  invisible(result)
}