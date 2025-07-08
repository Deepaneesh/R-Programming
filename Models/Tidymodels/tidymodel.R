# Load libraries
library(tidymodels)
library(ranger)
library(kernlab)  # for SVM
library(xgboost)  # for XGBoost

# Load the iris dataset
# datasplit
set.seed(123)
iris_split <- initial_split(iris, prop = 0.8)
iris_train <- training(iris_split)
iris_test  <- testing(iris_split)

# Define a recipe for preprocessing
iris_recipe <- recipe(Species ~ ., data = iris_train) %>% 
  step_normalize(all_predictors()) 

#extracing the recipe
iris_recipe %>% 
  prep() %>% 
  juice()

## model Specification 

boost_tree_xgboost_spec <-
  boost_tree(tree_depth = tune(), trees = tune(), learn_rate = tune(), min_n = tune(), loss_reduction = tune(), sample_size = tune(), stop_iter = tune()) |>
  set_engine('xgboost') |>
  set_mode('classification')

multinom_reg_glmnet_spec <-
  multinom_reg(penalty = tune(), mixture = tune()) |>
  set_engine('glmnet')

rand_forest_randomForest_spec <-
  rand_forest(mtry = tune(), min_n = tune()) |>
  set_engine('randomForest') |>
  set_mode('classification')


Model_workflow=workflow_set(
  preproc=list(rec=iris_recipe),
  model=list(boost_tree_xgboost=boost_tree_xgboost_spec,
             multinom_reg_glmnet=multinom_reg_glmnet_spec,
             rand_forest_randomForest=rand_forest_randomForest_spec)
)

cv_folds <- vfold_cv(iris_train, v = 5)
set.seed(123)
Model_tuned <- workflow_map(
  Model_workflow,
  resamples = cv_folds,
  grid = 10,
  metrics = metric_set(accuracy),
  verbose = TRUE
)
Model_tuned %>% collect_metrics()


collect_metrics(Model_tuned) %>%
  filter(.metric == "accuracy") %>%
  select(wflow_id, .metric, mean, std_err) %>%
  arrange(desc(mean))

best_result <- Model_tuned %>%
  select_best("accuracy")

Model_tuned$wflow_id

# For multinomial logistic regression
glmnet_result <- Model_tuned %>%
  extract_workflow_set_result("rec_multinom_reg_glmnet")


# 2. Select best params
best_params <- select_best(glmnet_result, metric = "accuracy")

# 3. Finalize workflow
final_workflow <- Model_tuned %>%
  extract_workflow("rec_multinom_reg_glmnet") %>%
  finalize_workflow(best_params)

# 4. Fit final model
final_model <- final_workflow %>%
  fit(data = iris_train)

final_workflow %>% last_fit(iris_split,
                            metrics = metric_set(accuracy, roc_auc, kap)) %>% 
  collect_predictions()  %>% 
  roc_curve(truth = Species, 
                                      .pred_setosa, .pred_versicolor, .pred_virginica,
                                      estimator = "hand_till") %>% autoplot()
# 5. Predict and evaluate
final_preds <- predict(final_model, iris_test) %>%
  bind_cols(iris_test)

metrics(final_preds, truth = Species, estimate = .pred_class)
