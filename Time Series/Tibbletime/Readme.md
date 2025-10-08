
## 📘 Tibbletime Package in R

``` r
library(tibbletime)
```

| **Topic** | **Explanation** |
|----|----|
| **Introduction** | The `tibbletime` package in R extends the `tibble` data structure to handle time-based data efficiently. It provides tools for creating, manipulating, aggregating, and filtering time series data within the tidyverse framework. It allows you to perform time-based operations directly on tibbles without converting them into other time series objects. |
| **Main Purpose** | To make time-based data manipulation easier and more consistent within the `tidyverse` grammar. |
| **Key Features** | 1\. Converts tibbles into time-aware data frames using an index (date/time column).<br>2. Enables filtering data by specific time periods.<br>3. Provides functions to aggregate or collapse data by regular time intervals.<br>4. Integrates with `dplyr` for time-based grouping and summarizing. |

In Tibble time only 3 functions are so good to use

1.  as_tbl_time()

2.  Create_Series()

3.  filter_time()

# as_tbl_time()

tbl_time objects have a time index that contains information about which
column should be used for time-based subsetting and other time-based
manipulation. Otherwise, they function as normal tibbles.

``` r
data <- tibble::tibble(
  date  = as.Date('2023-01-01') + 0:6,
  sales = c(120, 150, 160, 180, 175, 200, 210)
)

# Convert to time-aware tibble using as_tbl_time()
time_data <- as_tbl_time(data, index = date)

# Display the result
time_data
```

    ## # A time tibble: 7 × 2
    ## # Index:         date
    ##   date       sales
    ##   <date>     <dbl>
    ## 1 2023-01-01   120
    ## 2 2023-01-02   150
    ## 3 2023-01-03   160
    ## 4 2023-01-04   180
    ## 5 2023-01-05   175
    ## 6 2023-01-06   200
    ## 7 2023-01-07   210

**making in Tibbletime style**

# Create_Series()

**create_series()** allows the user to quickly create a tbl_time object
with a date column populated with a sequence of dates.

    create_series(
      time_formula,
      period = "day",
      class = "POSIXct",
      include_end = FALSE,
      tz = "UTC",
      as_vector = FALSE
    )

## 🕒 Available Period Types in `create_series()`

| **Period Type** | **Meaning** | **Example Range Created** |
|----|----|----|
| `"second"` | Creates a sequence at every second. | 2023-01-01 00:00:00, 2023-01-01 00:00:01, 2023-01-01 00:00:02, … |
| `"minute"` | Creates a sequence at every minute. | 2023-01-01 00:00, 2023-01-01 00:01, 2023-01-01 00:02, … |
| `"hour"` | Creates a sequence at every hour. | 2023-01-01 00:00, 2023-01-01 01:00, 2023-01-01 02:00, … |
| `"day"` | Creates a sequence for each day. | 2023-01-01, 2023-01-02, 2023-01-03, … |
| `"week"` | Creates a sequence for each week (by default starts on Sunday). | 2023-01-01, 2023-01-08, 2023-01-15, … |
| `"month"` | Creates a sequence for each month. | 2023-01-01, 2023-02-01, 2023-03-01, … |
| `"quarter"` | Creates a sequence every 3 months. | 2023-01-01, 2023-04-01, 2023-07-01, 2023-10-01 |
| `"year"` | Creates a sequence for each year. | 2020-01-01, 2021-01-01, 2022-01-01, … |

``` r
# Monthly series for 2023
create_series(as.Date('2023-01-01') ~ as.Date('2023-12-31'), period = "month")
```

    ## # A time tibble: 12 × 1
    ## # Index:         date
    ##    date               
    ##    <dttm>             
    ##  1 2023-01-01 00:00:00
    ##  2 2023-02-01 00:00:00
    ##  3 2023-03-01 00:00:00
    ##  4 2023-04-01 00:00:00
    ##  5 2023-05-01 00:00:00
    ##  6 2023-06-01 00:00:00
    ##  7 2023-07-01 00:00:00
    ##  8 2023-08-01 00:00:00
    ##  9 2023-09-01 00:00:00
    ## 10 2023-10-01 00:00:00
    ## 11 2023-11-01 00:00:00
    ## 12 2023-12-01 00:00:00

``` r
# Weekly series for 3 months
create_series(as.Date('2023-01-01') ~ as.Date('2023-03-31'), period = "week")
```

    ## # A time tibble: 13 × 1
    ## # Index:         date
    ##    date               
    ##    <dttm>             
    ##  1 2023-01-01 00:00:00
    ##  2 2023-01-08 00:00:00
    ##  3 2023-01-15 00:00:00
    ##  4 2023-01-22 00:00:00
    ##  5 2023-01-29 00:00:00
    ##  6 2023-02-05 00:00:00
    ##  7 2023-02-12 00:00:00
    ##  8 2023-02-19 00:00:00
    ##  9 2023-02-26 00:00:00
    ## 10 2023-03-05 00:00:00
    ## 11 2023-03-12 00:00:00
    ## 12 2023-03-19 00:00:00
    ## 13 2023-03-26 00:00:00

# filter_time ()

Use a concise filtering method to filter a tbl_time object by its index

    filter_time(.tbl_time, time_formula)

| **Period Type** | **Example Range** | **Description** |
|----|----|----|
| **Year** | `'2013' ~ '2015'` | Filters data between years 2013 and 2015 |
| **Month** | `'2013-01' ~ '2016-06'` | Filters data from Jan 2013 to Jun 2016 |
| **Day** | `'2013-01-05' ~ '2016-06-04'` | Filters data from Jan 5, 2013 to Jun 4, 2016 |
| **Second** | `'2013-01-05 10:22:15' ~ '2018-06-03 12:14:22'` | Filters data between two specific timestamps |
| **Variations** | `'2013' ~ '2016-06'` | Allows mixed precision (year to month) |
| **One-sided Formula (Year)** | `~'2015'` | Filters only data in the year 2015 |
| **One-sided Formula (Month)** | `~'2015-03'` | Filters only data in March 2015 |
| **Start to Specific Year** | `'start' ~ '2015'` | Filters from beginning of series to end of 2015 |
| **Specific Year to End** | `'2014' ~ 'end'` | Filters from start of 2014 to end of series |
