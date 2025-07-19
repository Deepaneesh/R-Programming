library(rmarkdown)

# Data with roll number
df <- data.frame(
  user_name = c("Alice", "Bob", "Charlie"),
  roll_no = c("R101", "R102", "R103"),
  Math = c(90, 75, 60),
  Physics = c(85, 70, 65),
  Chemistry = c(88, 68, 58),
  Biology = c(92, 72, 62),
  English = c(80, 77, 67),
  stringsAsFactors = FALSE
)

# Create output folder
output_dir <- "md_reports"
if (!dir.exists(output_dir)) {
  dir.create(output_dir)
}

# Loop to generate reports
for (i in 1:nrow(df)) {
  user <- df$user_name[i]
  roll <- df$roll_no[i]
  marks <- as.numeric(df[i, 3:7])
  subjects_df <- data.frame(
    Subject = names(df)[3:7],
    Marks = marks
  )
  
  rmarkdown::render(
    input = "report_template.Rmd",
    output_file = paste0(user, "_report.pdf"),
    output_dir = output_dir,
    params = list(
      user_name = user,
      roll_no = roll,
      subjects = subjects_df
    ),
    envir = new.env()
  )
}
