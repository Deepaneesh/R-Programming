library(dplyr)
library(tidyr)

# Recent chunk tidy -------------------------------------------------------


keep_recent_chunk_tidy <- function(df, country_col = "country",
                                   value_col = "value",
                                   year_col = "year",
                                   k = 2) {
  
  df %>%
    arrange(.data[[country_col]], .data[[year_col]]) %>%
    group_by(.data[[country_col]]) %>%
    mutate(
      block = rleid(is.na(.data[[value_col]]))
    ) %>%
    group_by(.data[[country_col]], block) %>%
    mutate(
      block_all_na = all(is.na(.data[[value_col]])),
      block_id = cur_group_id()
    ) %>%
    ungroup() %>%
    group_by(.data[[country_col]]) %>%
    mutate(
      last_non_missing_block =
        max(block_id[!block_all_na]),
      prev_block = last_non_missing_block - 1,
      gap_len = ifelse(block_id == prev_block & block_all_na,
                       sum(block_id == prev_block), 0),
      gap_len = max(gap_len),
      new_value = ifelse(gap_len >= k & block_id != last_non_missing_block,
                         NA,
                         .data[[value_col]])
    ) %>%
    ungroup() %>%
    select(all_of(country_col), all_of(year_col), value = new_value)
}

# Recent missing Tidy -----------------------------------------------------


remove_country_if_recent_missing_tidy <- function(df,
                                                  country_col = "country",
                                                  value_col   = "value",
                                                  year_col    = "year",
                                                  k = 2) {
  
  df %>%
    group_by(across(all_of(country_col))) %>%
    arrange(across(all_of(year_col)), .by_group = TRUE) %>%
    mutate(
      # Reverse values to check recent region
      rev_val = rev(.data[[value_col]]),
      
      # Count recent non-missing run
      recent_non_missing = {
        # rle where !is.na
        r <- rle(!is.na(rev_val))
        # If the first block is non-missing, take its length
        if (r$values[1] == TRUE) r$lengths[1] else 0
      },
      
      # If recent non-missing < k → entire country must be NA
      "{value_col}" := ifelse(recent_non_missing < k, NA, .data[[value_col]])
    ) %>%
    select(-rev_val, -recent_non_missing) %>%
    ungroup()
}


# Recent chunk data.table --------------------------------------------------

remove_before_large_gap <- function(dt,
                                    value_col = "value",
                                    year_col  = "year",
                                    k         = 3) {
  
  dt <- as.data.table(dt)
  setorderv(dt, year_col)
  
  v <- dt[[value_col]]
  n <- length(v)
  is_na <- is.na(v)
  
  run_id <- rleid(is_na)
  
  cutoff_positions <- c()
  
  # Find all large gaps
  for (id in unique(run_id[is_na])) {
    idx <- which(run_id == id)
    
    if (length(idx) >= k) {
      last_na <- max(idx)
      next_pos <- which(!is_na & seq_len(n) > last_na)
      
      if (length(next_pos) > 0) {
        cutoff_positions <- c(cutoff_positions, min(next_pos))
      }
    }
  }
  
  # If no large gaps, return unchanged
  if (length(cutoff_positions) == 0) return(dt)
  
  # We remove everything before the **largest** cutoff
  final_cutoff <- max(cutoff_positions)
  
  v[seq_len(final_cutoff - 1)] <- NA
  
  dt[[value_col]] <- v
  dt
}



# Recent missing data.table ------------------------------------------------


remove_country_if_recent_missing_dt <- function(dt,
                                                country_col = "country",
                                                value_col   = "value",
                                                year_col    = "year",
                                                k = 2) {
  
  dt <- as.data.table(dt)
  
  # rename internally
  setnames(dt, c(country_col, value_col, year_col),
           c("country", "value", "year"))
  
  result <- dt[
    order(country, year)
  ][
    , {
      vals_rev <- rev(value)
      
      # rle of non-missing
      r <- rle(!is.na(vals_rev))
      
      # recent good non-missing
      recent_good <- if (r$values[1]) r$lengths[1] else 0
      
      # always keep numeric type
      out_value <- as.numeric(value)
      
      # rule: if recent good < k → all NA
      if (recent_good < k) out_value <- rep(NA_real_, .N)
      
      .(year, value = out_value)
    },
    by = country
  ]
  
  # rename back
  setnames(result,
           c("country", "value", "year"),
           c(country_col, value_col, year_col))
  
  return(result[])
}



# Example data ------------------------------------------------------------


df <- data.frame(
  country = c(rep("A", 10), rep("B", 10)),
  year    = rep(2011:2020, 2),
  value   = c(
    1, 2, 3, NA, NA, NA, 1, 2, 3, NA,   # A
    5, 6, NA, NA, NA, NA,NA,NA, 11, 12  # B
  )
)

df_test <- data.frame(
  country = c(rep("A", 8), rep("B", 8), rep("C", 8)),
  year    = rep(2014:2021, 3),
  value   = c(
    # Country A (recent missing = 3 years → should become all NA if k = 3)
    10, 12, 14, 15, NA, 2, NA, 1,
    
    # Country B (recent missing = 1 year → should NOT change if k >= 2)
    20, 22, 23, 24, 25, 26, 27, NA,
    
    # Country C (recent missing = 4 years → will become NA if k = 3 or 4)
    5, 6, NA, NA, NA, 3, 2, 1
  )
)
# Testing the functions ---------------------------------------------------
dt <- data.table(
  year   = 2000:2011,
  value  = c(1,2,3,NA,NA,NA,7,NA,NA,10,11,NA)
)

remove_before_large_gap(dt, k = 3)

#----------------------------------------------------------------
 remove_country_if_recent_missing_dt(
  df_test,
  country_col = "country",
  value_col = "value",
  year_col = "year",
  k = 1
)



# Testing the tidyverse versions ------------------------------------------
keep_recent_chunk_tidy(
  df,
  country_col = "country",
  value_col = "value",
  year_col   = "year",
  k = 3
)
#----------------------------------------------------------------
remove_country_if_recent_missing_tidy(
  df_test,
  country_col = "country",
  value_col   = "value",
  year_col    = "year",
  k = 1
) 

