Colour Name & Hex code
================

``` r
library(dplyr)
library(knitr)
library(kableExtra)
library(tidyverse)
library(DT)
```

``` r
colourdata <- data.frame(
  colourname = colors(),
  hex_code   = rgb(t(col2rgb(colors())), maxColorValue = 255)
)
colourdata %>% nrow()
```

    ## [1] 657

```
colourdata %>% 
  mutate(colour = cell_spec(colourname, "html", 
                            background = hex_code, color = "white")) %>%
  select(colourname, hex_code, colour) %>%
  kable("html", escape = FALSE) %>%
  kable_styling(full_width = FALSE)
```

This code is used to select the specific colour by using hex code you
use filter options inbetween for better selection


    # Create styled HTML cell
    datatable_data <- colourdata %>%
      mutate(colour = paste0(
        '<div style="background-color:', hex_code,
        '; color:white; padding:5px; border-radius:4px;">',
        colourname, '</div>'
      ))


    datatable(
      datatable_data,
      escape = FALSE,
      filter = "top",
      rownames = FALSE,
      editable = FALSE,
      extensions = c("Buttons", "Scroller", "Responsive", "KeyTable", "SearchBuilder","RowReorder"),
      options = list(
        rowReorder = TRUE,
        keys = TRUE,
        scrollY = 600,
        scrollX = 200,
        responsive = FALSE,
        pageLength = 10,
        lengthMenu = c(10, 25, 50,100),
        dom = 'QBlfrtip',  # ✅ Q = SearchBuilder, B = Buttons
        searchBuilder = TRUE,
        buttons = c('copy', 'csv', 'pdf', 'print')
      )
    )

Viewing this in a datatable structure
