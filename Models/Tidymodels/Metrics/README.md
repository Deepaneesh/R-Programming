Metrics
================

In tidymodels, the metric_set() function is used to bundle together
multiple performance metrics that you want to evaluate for a model.

📌 Common functions available in metric_set() These functions are part
of the yardstick package, which tidymodels uses for metrics. Here’s a
categorized list of available metrics:

    library(tidymodels)

    # Choose metrics
    my_metrics <- metric_set(accuracy, roc_auc, kap)

    # Then use with `last_fit()` or `fit_resamples()` like:
    last_fit(my_workflow, resample_split, metrics = my_metrics)

## Common Functions Available in metric_set() (Tidymodels)

| Function       | Description                               |
|----------------|-------------------------------------------|
| `rmse()`       | Root Mean Squared Error                   |
| `rsq()`        | R-squared                                 |
| `mae()`        | Mean Absolute Error                       |
| `mape()`       | Mean Absolute Percentage Error            |
| `smape()`      | Symmetric Mean Absolute Percentage Error  |
| `ccc()`        | Lin’s Concordance Correlation Coefficient |
| `mse()`        | Mean Squared Error                        |
| `huber_loss()` | Robust regression loss                    |

## Classification Metrics (Binary & Multiclass)

| Function                   | Description                           |
|----------------------------|---------------------------------------|
| `accuracy()`               | Classification accuracy               |
| `roc_auc()`                | Area under the ROC Curve              |
| `kap()`                    | Cohen’s Kappa                         |
| `sens()` / `sensitivity()` | True positive rate (Recall)           |
| `spec()` / `specificity()` | True negative rate                    |
| `ppv()`                    | Positive Predictive Value (Precision) |
| `npv()`                    | Negative Predictive Value             |
| `f_meas()`                 | F-measure (F1 Score)                  |
| `mcc()`                    | Matthews Correlation Coefficient      |
| `j_index()`                | Youden’s J Statistic                  |
| `bal_accuracy()`           | Balanced Accuracy                     |
| `mn_log_loss()`            | Multinomial Log Loss                  |
| `pr_auc()`                 | Precision-Recall AUC                  |

## Probability-based Metrics

| Function        | Description                    |
|-----------------|--------------------------------|
| `roc_auc()`     | Area under the ROC Curve       |
| `pr_auc()`      | Precision-Recall AUC           |
| `mn_log_loss()` | Multinomial Log Loss           |
| `brier_class()` | Brier Score for Classification |
