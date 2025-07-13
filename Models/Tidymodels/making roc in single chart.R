

library(tidymodels)
library(tidyverse)

# Define test set for truth
truth_data <- iris_test %>% select(Species)

# Prepare list of all model IDs
model_ids <- Model_tuned$wflow_id

# Initialize list to store ROC data for each model
all_roc <- list()

# Loop through each model
for (id in model_ids) {
  
  # Get best parameters
  result <- extract_workflow_set_result(Model_tuned, id)
  best_params <- select_best(result, metric = "accuracy")
  
  # Finalize and fit the model
  wf <- extract_workflow(Model_tuned, id)
  final_wf <- finalize_workflow(wf, best_params)
  fitted_model <- fit(final_wf, data = iris_train)
  
  # Predict probabilities on test set
  probs <- predict(fitted_model, iris_test, type = "prob") %>%
    bind_cols(truth_data)
  
  # Compute ROC (one-vs-all for each class)
  roc_data <- roc_curve(probs, truth = Species, 
                        .pred_setosa, .pred_versicolor, .pred_virginica) %>%
    mutate(Model = id)
  
  # Store
  all_roc[[id]] <- roc_data
}

# Combine all ROC data
roc_all <- bind_rows(all_roc)

# Plot ROC curves
ggplot(roc_all, aes(x = 1 - specificity, y = sensitivity, color = Model)) +
  geom_path(size = 1) +
  geom_abline(lty = 3) +
  facet_wrap(~.level, nrow = 1) +
  labs(
    title = "ROC Curves for All Tuned Models (One-vs-All)",
    x = "1 - Specificity", y = "Sensitivity", color = "Model"
  ) +
  theme_minimal()
