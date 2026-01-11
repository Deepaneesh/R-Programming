df <- data.frame(
  Country = c("India", "USA", "UK", "Germany"),
  
  # ---- 2020 ----
  `2020Q1` = c(10,  NA,  8, 12),
  `2020Q2` = c(30, 40, NA, 25),   # H1 total
  `2020Q3` = c(15, NA, 12, NA),
  `2020Q4` = c(70, 100, 35, 60),  # Annual total
  
  # ---- 2021 ----
  `2021Q1` = c(12,  9, NA, 14),
  `2021Q2` = c(35, 18, 20, NA),
  `2021Q3` = c(20, NA, NA, 10),
  `2021Q4` = c(80, 50, 45, 55)
)
library(dplyr)
library(tidyr)

long <- df %>%
  pivot_longer(
    -Country,
    names_to = c("Year", "Quarter"),
    names_pattern = "(\\d{4})Q(\\d)",
    values_to = "value"
  )
library(dplyr)

library(dplyr)

actual <- long %>%
  group_by(Country, Year) %>%
  arrange(Quarter, .by_group = TRUE) %>%
  mutate(
    actual_value = case_when(
      # Q1
      Quarter == "1" ~ value,
      
      # Q2 (H1 - Q1)
      Quarter == "2" ~ value - coalesce(lag(value), 0),
      
      # Q3
      Quarter == "3" ~ value,
      
      # Q4 with proper logic
      Quarter == "4" & !is.na(value[Quarter == "2"]) ~
        value - (
          value[Quarter == "2"] +
            coalesce(value[Quarter == "3"], 0)
        ),
      
      Quarter == "4" &
        is.na(value[Quarter == "2"]) &
        !is.na(value[Quarter == "1"]) ~
        value - (
          value[Quarter == "1"] +
            coalesce(value[Quarter == "3"], 0)
        ),
      
      TRUE ~ NA_real_
    )
  ) %>%
  ungroup()

View(actual)
