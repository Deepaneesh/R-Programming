Colour Name & Hex code
================

``` r
library(dplyr)
library(knitr)
library(kableExtra)
library(tidyverse)
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
