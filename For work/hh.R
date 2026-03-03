rm(list = ls()); gc()

pacman::p_load(dplyr, stringr)

data <- data.frame(
  Country = c("A","A","B","B"),
  Year = c(2020,2021,2020,2021),
  Total_Household = c(100,120,80,90),   # Notice: renamed
  H1 = c(20,30,10,NA),
  H2 = c(30,25,20,30),
  H3 = c(25,20,15,20),
  H4 = c(10,15,10,15),
  H5 = c(5,10,5,10),
  H6_plus = c(15,45,30,20)
)

# -------------------------------
# Soft coding starts here
# -------------------------------

# Detect split columns (H1 to H6 type)
split_cols <- names(data)[str_detect(names(data), "^H[1-6]")]

# Detect total column automatically
total_col <- names(data)[str_detect(names(data), "Total")]

data_new <- data %>%
  
  # Step 1: If any split is NA → make Total NA
  mutate(
    across(all_of(total_col),
           ~ ifelse(rowSums(is.na(across(all_of(split_cols)))) > 0 & !is.na(.),
                    NA, .))
  ) %>%
  
  # Step 2: Calculate split sum
  rowwise() %>%
  mutate(
    Split_Sum = sum(c_across(all_of(split_cols)), na.rm = TRUE)
  ) %>%
  ungroup() %>%
  
  # Step 3: Calculate Extra
  mutate(
    Extra = case_when(
      is.na(.data[[total_col]]) ~ Split_Sum,
      TRUE ~ .data[[total_col]] - Split_Sum
    )
  ) %>%
  
  # Step 4: Adjust Total if no NA in splits
  mutate(
    across(all_of(total_col),
           ~ ifelse(rowSums(is.na(across(all_of(split_cols)))) == 0,
                    . - Extra, .)),
    
    Extra = ifelse(rowSums(is.na(across(all_of(split_cols)))) == 0,
                   0, Extra)
  )

data_new
