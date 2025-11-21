library(data.table)
library(tidyverse)

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


# Testing the functions ---------------------------------------------------
dt <- data.frame(
  year   = 2000:2011,
  value  = c(1,2,3,NA,NA,NA,7,NA,NA,10,11,NA)
) %>% as.data.table()

remove_before_large_gap(dt, k = 3)


l

# remove recent missing ---------------------------------------------------


remove_if_recent_missing <- function(dt,
                                     value_col = "value",
                                     year_col  = "year",
                                     n         = 5,
                                     k         = 2) {
  
  dt <- as.data.table(dt)
  setorderv(dt, year_col)
  
  v <- dt[[value_col]]
  years <- dt[[year_col]]
  n_total <- length(v)
  
  # Identify last n years
  recent_idx <- (n_total - n + 1):n_total
  
  # Count missing values in recent period
  recent_NA_count <- sum(is.na(v[recent_idx]))
  
  # If missing >= k → entire series becomes NA
  if (recent_NA_count >= k) {
    dt[[value_col]] <- NA
  }
  
  return(dt)
}
# Testing the function ----------------------------------------------------
dt <- data.table(
  year  = 2000:2012,
  value = c(1,2,3,4,5,6,7,8,9,NA,11,NA,12)
)

remove_if_recent_missing(dt, n = 3, k = 2)
remove_if_recent_missing(dt, n = 4, k = 3)
