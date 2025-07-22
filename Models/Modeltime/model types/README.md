model types
================

There are several time series model available in modeltime package.

## 📦 Models Supported by `modeltime`

### 1️⃣ Classical Time Series Models

| Model | Function | Engine(s) | Notes |
|----|----|----|----|
| ARIMA | `arima_reg()` | `"auto_arima"`, `"arima"` | Auto & manual ARIMA/SARIMA |
| Exponential Smoothing (ETS) | `exp_smoothing()` | `"ets"` | Includes Holt, Holt-Winters |
| TBATS | `seasonal_reg()` | `"tbats"` | Handles multiple/complex seasonality |
| STLM with ARIMA | `seasonal_reg()` | `"stlm_arima"` | Seasonal decomposition + ARIMA |
| STLM with ETS | `seasonal_reg()` | `"stlm_ets"` | Seasonal decomposition + ETS |
| NNETAR (Neural Network TS) | `nnetar_reg()` | `"nnetar"` | Feedforward NN from forecast pkg |

### 2️⃣ Bayesian / Additive Models

| Model | Function | Engine | Notes |
|----|----|----|----|
| Prophet | `prophet_reg()` | `"prophet"` | Trend changepoints, holidays, seasonality |

### 3️⃣ Machine Learning Models

#### 🔸 Tree-Based Models

| Model         | Function          | Engine(s)                               |
|---------------|-------------------|-----------------------------------------|
| Decision Tree | `decision_tree()` | `"rpart"`                               |
| Random Forest | `rand_forest()`   | `"ranger"`, `"randomForest"`            |
| Boosted Trees | `boost_tree()`    | `"xgboost"`, `"lightgbm"`, `"catboost"` |

#### 🔸 Linear & Regularized Models

| Model               | Function       | Engine(s)       |
|---------------------|----------------|-----------------|
| Linear Regression   | `linear_reg()` | `"lm"`, `"glm"` |
| Elastic Net / Ridge | `linear_reg()` | `"glmnet"`      |

#### 🔸 Other ML Models

| Model                    | Function             | Engine(s)   |
|--------------------------|----------------------|-------------|
| Support Vector Machine   | `svm_rbf()`          | `"kernlab"` |
| K-Nearest Neighbors      | `nearest_neighbor()` | `"kknn"`    |
| MARS (Spline Regression) | `mars()`             | `"earth"`   |

### 4️⃣ Deep Learning (via Extensions)

| Model | Package | Function | Engine |
|----|----|----|----|
| DeepAR | `modeltime.gluonts` | `deep_ar()` | `"gluonts_deepar"` |
| LSTM | `modeltime.gluonts` | `lstm()` | `"gluonts_lstm"` |
| Temporal Fusion Transformer (TFT) | `modeltime.gluonts` | `temporal_fusion_transformer()` | `"gluonts_tft"` |
| H2O Deep Learning | `modeltime.h2o` | `deep_learning()` | `"h2o"` |

### 5️⃣ Hybrid Models

| Model | Function | Engine(s) | Notes |
|----|----|----|----|
| ARIMA + XGBoost | `arima_boost()` | `"arima_xgboost"` | Residual modeling using XGBoost |
| Prophet + XGBoost | `prophet_boost()` | `"prophet_xgboost"` | Residual modeling using XGBoost |

### Ensemble Models

| Ensemble Type | Function | Notes |
|----|----|----|
| Model Averaging | `ensemble_average()` | Averages predictions of base models |
| Weighted Ensemble | `ensemble_weighted()` | Weighted average of base models |
| Stacking Ensemble | `ensemble_model_spec()` | Meta-learner on top of base models |

## Structure of Modeltime Models

    model_fit_prophet <- prophet_reg() %>%
      set_engine("prophet") %>%
      fit(value ~ date, data = training(splits))
