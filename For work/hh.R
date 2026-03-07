ibrary(dplyr)
library(tidyverse)

# Function to calculate weighted variable
weighted_variable <- function(data, weight_data, year_col = "Year") {
  
  w <- weight_data$weight
  names(w) <- weight_data$category
  
  cal <- data %>%
    mutate(
      weighted_total = rowSums(
        across(all_of(names(w)), ~ . * w[cur_column()]) 
      )
    ) %>% pull(weighted_total)
  return(cal)
}

data <- data.frame(
  Year = c(2020, 2021),
  A = c(10, 12),
  B = c(20, 18),
  C = c(30, 35)
)
weights_df <- data.frame(
  category = c("A","B","C"),
  weight = c(0.2,0.3,0.5)
)

result <- weighted_variable(data, weights_df)

result
