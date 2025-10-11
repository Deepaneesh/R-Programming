
data = iris

data$letters=rep(letters,length.out=nrow(data))
data

trimed_data = function(data){
  # Loading package
  suppressPackageStartupMessages(require(tidyverse))
  # Variable selection
  numeric_var=data %>% select_if(is.numeric) %>% colnames()
  factor_var = data %>% select_if(is.factor) %>% colnames()
  non_numeric_var=data %>% select_if(~!is.numeric(.)) %>% colnames()
  
  # Data trimming
  trim_data=data %>% 
    mutate(across(everything(),~as.character(.))) %>%
    mutate(across(everything(),~str_trim(.))) %>% 
    mutate(across(all_of(factor_var),~as.factor(.))) %>% 
    mutate(across(all_of(numeric_var),~as.numeric(.)))
  
  # Return the trimmed data
  return(trim_data)
  
}

new_data = trimed_data(data)
str(new_data)
summary(new_data)
