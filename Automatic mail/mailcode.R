library(blastula)

data <- data.frame(
  name = c("Deepan1", "Deepan2", "Deepan3"),
  email = c("deepaneesh98@gmail.com", "deepaneeshrv@gmail.com", "deepanrv98@gmail.com"),
  score = c(25, 15, 30)
)

id=creds(
  user = "deepaneesh98@gmail.com",
  provider = "gmail",
  use_ssl = TRUE
)

# Loop through each person
for (i in 1:nrow(data)) {
  
  person_name <- data$name[i]
  person_email <- data$email[i]
  person_score <- data$score[i]
  
  # Message based on score
  if (person_score > 20) {
    msg_body <- paste0("Hi ", person_name, ",\n\nCongratulations! You have passed the test with a score of ", person_score, ".")
  } else {
    msg_body <- paste0("Hi ", person_name, ",\n\nUnfortunately, you have not passed the test. Your score is ", person_score, ". Please try again.")
  }
  
  email_inner <- ifelse(person_score > 20,
                        render_email("pass.Rmd"),
                        render_email("fail.Rmd"))
  
  footer= paste0("Best regards","\nDeepaneesh")
  # Create email
  email1 <- compose_email(
    header = md(msg_body),
    body = md(email_inner),
    footer = md(footer)
  )
  
  email2 <- add_attachment(
    email = email1,
    file = "C:/Users/deepa/OneDrive/Desktop/Mail br r/FILLED FORM.pdf",  # <-- Your file path
    filename = "Your_Filled_Form.pdf"  # optional: rename the file in email
  )
  
  email3 <- add_attachment(
    email = email2,
    file = "C:/Users/deepa/OneDrive/Desktop/Mail br r/pass.html",  # <-- Your file path
    filename = "htmlfile"  # optional: rename the file in email
  )
  # Send email
  smtp_send(
    email3,
    from = "deepaneesh98@gmail.com",
    to = person_email,
    subject = "Test Results",
    credentials = id
  )
}

