# packages
library(glmnet)
library(dplyr)
library(tidyverse)
library(ggplot2)
library(rsample)
library(caret)
library(plotly)

# dataset 
data1=iris
data1

## data Spliting 
set.seed(123)
data_split=initial_split(data1, prop = 0.7, strata = "Species")
train_data <- training(data_split)
test_data <- testing(data_split)

## Model Fitting
x_train <- model.matrix(Species ~ ., data = train_data)[, -1]
y_train <- train_data$Species
x_test <- model.matrix(Species ~ ., data = test_data)[, -1]
y_test <- test_data$Species

# Fit the multinomial logistic regression model using glmnet
model <- glmnet(x_train, y_train, family = "multinomial", alpha = 0.5)
model 
plot(model, xvar = "lambda", label = TRUE)

# cv model
cv_model <- cv.glmnet(x_train, y_train, family = "multinomial", alpha = 0.5)
cv_model
plot(cv_model)
lambda_min <- cv_model$lambda.min
lambda_min
# best model
best_model <- glmnet(x_train, y_train, family = "multinomial", alpha = 0.5, lambda = lambda_min)
best_model

# Model Coefficients
coef(best_model)
# Predictions
predictions <- predict(best_model, newx = x_test, type = "class")
# Confusion Matrix
confusion_matrix <- confusionMatrix(as.factor(predictions), as.factor(y_test))
confusion_matrix

# train predict
train_predictions <- predict(best_model, newx = x_train, type = "class")
# Train Confusion Matrix
train_confusion_matrix <- confusionMatrix(as.factor(train_predictions), as.factor(y_train))
train_confusion_matrix

cm_table= as.data.frame(train_confusion_matrix$table)
k=ggplot(data = cm_table, aes(x = Reference, y = Prediction, fill = Freq)) +
  geom_tile(color = "black") +
  geom_text(aes(label = Freq), size = 5) +
  scale_fill_gradient(low = "white", high = "steelblue") +
  labs(title = "Confusion Matrix", x = "Actual", y = "Predicted") +
  theme_minimal()+
  theme(plot.title = element_text(hjust = 0.5, size = 20),
        axis.title.x = element_text(size = 15),
        axis.title.y = element_text(size = 15),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12))
ggplotly(k)
