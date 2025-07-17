library(DT)
data=iris
datatable(
  data,
  filter = "top",
  rownames = FALSE,
  editable = FALSE,
  extensions = c("Buttons", "Scroller", "Responsive", "KeyTable", "SearchBuilder","RowReorder"),
  options = list(
    rowReorder = TRUE,
    keys = TRUE,
    scrollY = 400,
    scrollX = 200,
    responsive = FALSE,
    pageLength = 10,
    lengthMenu = c(10, 25, 30),
    dom = 'QBlfrtip',  # ✅ Q = SearchBuilder, B = Buttons
    searchBuilder = TRUE,
    buttons = c('copy', 'csv', 'pdf', 'print')
  )
)
