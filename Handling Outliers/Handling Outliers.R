boxplot(iris)

data=iris
remove_outliers_iqr <- function(data, cols = names(data)) {
  data_clean <- data
  
  for (col in cols) {
    if (is.numeric(data[[col]])) {
      Q1 <- quantile(data[[col]], 0.25, na.rm = TRUE)
      Q3 <- quantile(data[[col]], 0.75, na.rm = TRUE)
      IQR <- Q3 - Q1
      lower <- Q1 - 1.5 * IQR
      upper <- Q3 + 1.5 * IQR
      
      data_clean <- data_clean[data_clean[[col]] >= lower & data_clean[[col]] <= upper, ]
    }
  }
  
  return(data_clean)
}
data_clean <- remove_outliers_iqr(data)
boxplot(data_clean)
summary(data_clean)
summary(iris)

# data 
iris
data=iris
# Function to replace outliers with the mean of the column
replace_outliers_with_mean <- function(data, cols = names(data)) {
  data_modified <- data
  
  for (col in cols) {
    if (is.numeric(data[[col]])) {
      Q1 <- quantile(data[[col]], 0.25, na.rm = TRUE)
      Q3 <- quantile(data[[col]], 0.75, na.rm = TRUE)
      IQR <- Q3 - Q1
      lower <- Q1 - 1.5 * IQR
      upper <- Q3 + 1.5 * IQR
      
      # Replace outliers with mean
      mean_val <- mean(data[[col]], na.rm = TRUE)
      outlier_idx <- which(data[[col]] < lower | data[[col]] > upper)
      data_modified[outlier_idx, col] <- mean_val
    }
  }
  
  return(data_modified)
}
data_modified <- replace_outliers_with_mean(data)
boxplot(data_modified)
boxplot(iris)
summary(data_modified)
summary(iris)
