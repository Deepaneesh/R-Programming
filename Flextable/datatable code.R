library(flextable)
library(officer)  # for fp_border()
table_data <- data.frame(
  Gender = c("Male", "Female", "Total"),
  A = c(10, 15, 25),
  B = c(20, 25, 45),
  Total = c(30, 40, 70)
)
ft <- flextable(table_data) %>%
  set_header_labels(Gender = "Gender") %>%
  add_header_row(
    values = c("", "Group"),
    colwidths = c(1, ncol(table_data) - 1)
  ) %>%
  bold(part = "header") %>%
  bold(j = 1, part = "body") %>%
  align(align = "center", part = "all") %>%
  padding(padding = 5, part = "all") %>%
  vline(
    j = 1:(ncol(table_data)-1),
    border = fp_border(color = "black", width = 1)
  ) %>%
  hline(
    i = 1:(nrow(table_data)-1),
    part = "body",
    border = fp_border(color = "black", width = 1)
  ) %>%
  hline(
    i = 1,
    part = "header",
    border = fp_border(color = "black", width = 1)
  ) %>%
  border_outer(border = fp_border(color = "black", width = 1)) %>%
  add_footer_row(values = "Observed Frequency Table", colwidths = ncol(table_data)) %>%
  italic(part = "footer") %>%
  align(align = "center", part = "footer") %>% 
  set_caption("Observed Frequency Table") 
ft
