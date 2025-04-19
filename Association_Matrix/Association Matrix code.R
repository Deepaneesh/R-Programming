association_Matrix_for_Categorical_data <- function(x) {
  require(dplyr)
  require(tidyr)
  require(ggplot2)
  require(lsr)
  require(reshape2)
  require(viridis)
  
  result_df <- data.frame(
    Variable1 = character(),
    Variable2 = character(),
    chi_Squared_P_Value = numeric(),
    Chi_Squared_Value = numeric(),
    Association_Strength = numeric()
  )
  
  categorical_variables <- colnames(x)
  
  for (i in categorical_variables) {
    for (j in categorical_variables) {
      contingency_table <- table(x[[i]], x[[j]])
      chi_squared_test <- suppressWarnings(chisq.test(contingency_table))
      
      chi_sq_pvalue <- chi_squared_test$p.value
      chi_sq_statistic <- chi_squared_test$statistic
      
      # Optional: Compute Cramér's V only if significant
      association_strength <- ifelse(chi_sq_pvalue < 0.05, cramersV(contingency_table), 0)
      
      result_df <- rbind(result_df, data.frame(
        Variable1 = i,
        Variable2 = j,
        chi_Squared_P_Value = chi_sq_pvalue,
        Chi_Squared_Value = chi_sq_statistic,
        Association_Strength = association_strength
      ))
    }
  }
  
  correlation_matrix <- result_df %>% 
    dplyr::select(Variable1, Variable2, Association_Strength)
  
  graph1 <- correlation_matrix %>%
    ggplot(aes(x = Variable1, y = Variable2, fill = Association_Strength)) +
    geom_tile(color = "white") +
    scale_fill_viridis_c(option = "Z")+
    geom_text(aes(label = round(Association_Strength, 2)), vjust = 1,colour="red") +
    theme_minimal() +
    labs(title = "Association Matrix (Cramér's V)", x = "Variables", y = "Variables") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1),
          axis.text.y = element_text(angle = 45, hjust = 1),
          plot.title = element_text(face = "bold", size = 12, hjust = 0.5))
  
  return(list(result_df = result_df, graph1 = graph1))
}
# Sample categorical dataset
example_data <- data.frame(
  Gender = sample(c("Male", "Female"), 50, replace = TRUE),
  Education = sample(c("HighSchool", "Graduate", "PostGraduate"), 50, replace = TRUE),
  MaritalStatus = sample(c("Single", "Married", "Divorced"), 50, replace = TRUE),
  Employment = sample(c("Employed", "Unemployed", "Student"), 50, replace = TRUE)
)

# View the data
head(example_data)

# Run your function on this dataset
result <- association_Matrix_for_Categorical_data(example_data)

# View results
result$result_df  # Table with p-values and Cramer's V
result$graph1     # Heatmap plot
