library(dplyr)
library(tidyverse)
###############################################################################################3
# Function to remove outliers using IQR method for all numeric columns
remove_outliers_iqr_groupwise <- function(data, group_col, cols = names(data)) {
  data %>%
    group_by(across(all_of(group_col))) %>%
    filter(across(
      .cols = all_of(cols),
      .fns = ~ {
        if (is.numeric(.)) {
          Q1 <- quantile(., 0.25, na.rm = TRUE)
          Q3 <- quantile(., 0.75, na.rm = TRUE)
          IQR <- Q3 - Q1
          lower <- Q1 - 1.5 * IQR
          upper <- Q3 + 1.5 * IQR
          . >= lower & . <= upper
        } else {
          TRUE
        }
      }
    )) %>%
    ungroup()
}

# Use it
data_clean_groupwise <- remove_outliers_iqr_groupwise(iris, group_col = "Species", cols = names(iris)[1:4])

####################################################################################################################
# repalce outliers with mean using IQR method for all numeric columns

replace_outliers_with_mean_groupwise <- function(data, group_col, cols = names(data)) {
  data %>%
    group_by(across(all_of(group_col))) %>%
    mutate(across(
      .cols = all_of(cols),
      .fns = ~ {
        if (is.numeric(.)) {
          Q1 <- quantile(., 0.25, na.rm = TRUE)
          Q3 <- quantile(., 0.75, na.rm = TRUE)
          IQR <- Q3 - Q1
          lower <- Q1 - 1.5 * IQR
          upper <- Q3 + 1.5 * IQR
          mean_val <- mean(.[. >= lower & . <= upper], na.rm = TRUE)
          replace(., . < lower | . > upper, mean_val)
        } else {
          .
        }
      }
    )) %>%
    ungroup()
}

# Use it
data_modified_groupwise <- replace_outliers_with_mean_groupwise(iris, group_col = "Species", cols = names(iris)[1:4])

boxplot(data_modified_groupwise[1:4], main = "After Replacing Outliers with Mean (Groupwise)")

#####################################################################################################################################3
# boxplot by groups 

iris_long <- data_modified_groupwise %>%
  pivot_longer(cols = where(is.numeric), names_to = "Variable", values_to = "Value")

# Boxplot for each numeric variable
ggplot(iris_long, aes(x = Variable, y = Value)) +
  stat_boxplot(geom = "errorbar", width = 0.2) +
  facet_wrap(~ Species) +
  geom_boxplot(outlier.colour = "red", fill = "lightblue") +
  labs(title = "Boxplots of All Numeric Variables in Iris Dataset")