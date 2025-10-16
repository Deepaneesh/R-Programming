lubridate
================

lubridate is an R package that makes it easier to work with dates and
times. It simplifies parsing, extraction, modification, and arithmetic
operations on dates.

``` r
library(lubridate)
```

# 1. Parsing Dates and Date-Times

Common lubridate Parsing Functions:

- ymd() – Year-Month-Day

- dmy() – Day-Month-Year

- mdy() – Month-Day-Year

- ydm(), myd(), dym() – Other formats

- ymd_hms(), dmy_hms() – Include time (hour, minute, second)

``` r
ymd("2025-07-17")             # "2025-07-17"
```

    ## [1] "2025-07-17"

``` r
dmy("17-07-2025")             # "2025-07-17"
```

    ## [1] "2025-07-17"

``` r
mdy("July 17, 2025")          # "2025-07-17"
```

    ## [1] "2025-07-17"

``` r
ydm("2025-17-07")             # "2025-07-17"
```

    ## [1] "2025-07-17"

``` r
ymd_hms("2025-07-17 14:30:00")# "2025-07-17 14:30:00 UTC"
```

    ## [1] "2025-07-17 14:30:00 UTC"

# 2. Extracting Date-Time Components Functions:

- year(), month(), day()

- hour(), minute(), second()

- wday(), yday(), mday()

- week(), quarter(), semester()

``` r
dt <- ymd_hms("2025-07-17 14:45:30")

year(dt)      # 2025
```

    ## [1] 2025

``` r
month(dt)     # 7
```

    ## [1] 7

``` r
month(dt, label = TRUE)        # Jul
```

    ## [1] Jul
    ## 12 Levels: Jan < Feb < Mar < Apr < May < Jun < Jul < Aug < Sep < ... < Dec

``` r
month(dt, label = TRUE, abbr = FALSE) # July
```

    ## [1] July
    ## 12 Levels: January < February < March < April < May < June < ... < December

``` r
day(dt)       # 17
```

    ## [1] 17

``` r
hour(dt)      # 14
```

    ## [1] 14

``` r
minute(dt)    # 45
```

    ## [1] 45

``` r
second(dt)    # 30
```

    ## [1] 30

``` r
wday(dt, label = TRUE)         # Thu
```

    ## [1] Thu
    ## Levels: Sun < Mon < Tue < Wed < Thu < Fri < Sat

``` r
wday(dt, label = TRUE, abbr = FALSE) # Thursday
```

    ## [1] Thursday
    ## 7 Levels: Sunday < Monday < Tuesday < Wednesday < Thursday < ... < Saturday

``` r
yday(dt)      # day of the year ( 1 to 365)
```

    ## [1] 198

``` r
quarter(dt)   # quarter of the year (1 to 4)
```

    ## [1] 3

``` r
week(dt)     # week of the year (1 to 53)
```

    ## [1] 29

``` r
semester(dt)  # semester of the year (1 or 2)
```

    ## [1] 2

``` r
mday(dt)      # day of the month (17)
```

    ## [1] 17

# 4. Time Zones ✅ Functions:

- tz() – Get time zone

- with_tz() – Convert to new zone (adjusts time)

- force_tz() – Change zone without changing clock time

``` r
dt <- ymd_hms("2025-07-17 10:00:00", tz = "Asia/Kolkata")

with_tz(dt, "UTC")     # "2025-07-17 04:30:00 UTC"
```

    ## [1] "2025-07-17 04:30:00 UTC"

``` r
force_tz(dt, "UTC")    # "2025-07-17 10:00:00 UTC"
```

    ## [1] "2025-07-17 10:00:00 UTC"

# 5. Rounding Dates

✅ Functions:

- round_date()

- floor_date()

- ceiling_date()

``` r
x <- ymd_hms("2025-07-17 10:34:50")

round_date(x, "hour")    # "2025-07-17 11:00:00 UTC"
```

    ## [1] "2025-07-17 11:00:00 UTC"

``` r
floor_date(x, "hour")    # "2025-07-17 10:00:00 UTC"
```

    ## [1] "2025-07-17 10:00:00 UTC"

``` r
ceiling_date(x, "hour")  # "2025-07-17 11:00:00 UTC"
```

    ## [1] "2025-07-17 11:00:00 UTC"

# 6. Time Arithmetic

- +, - – Add/subtract durations

- days(), months(), years()

- duration(), period()

``` r
date <- ymd("2025-07-17")

date + days(10)               # "2025-07-27"
```

    ## [1] "2025-07-27"

``` r
date + period(1, "month")     # "2025-08-17"
```

    ## [1] "2025-08-17"

``` r
date + duration(3600)         # "2025-07-17 01:00:00 UTC"
```

    ## [1] "2025-07-17 01:00:00 UTC"

# 7. Differences and Durations

| Function | Description | Example |
|----|----|----|
| `difftime()` | Base R (works with lubridate too) | `difftime(ymd("2025-10-16"), ymd("2025-01-01"))` |
| `time_length()` | Express difference in specific units | `time_length(interval(ymd("2025-01-01"), ymd("2025-10-16")), "month")` |
| `make_difftime()` | Construct difftime directly | `make_difftime(hour = 1, min = 20)` |

``` r
difftime(ymd("2025-10-16"), ymd("2025-01-01"),units = "weeks")
```

    ## Time difference of 41.14286 weeks

units can be **“auto”, “secs”, “mins”, “hours”, “days”, or “weeks”.**

``` r
time_length(interval(ymd("2025-01-01"), ymd("2025-10-16")), unit = "month") 
```

    ## [1] 9.483871

units can be anything

``` r
make_difftime(hour = 1, min = 20)
```

    ## Time difference of 1.333333 hours

# 8. Intervals and Durations

✅ Functions:

- interval(start, end)

- %within% – Check if a date falls within an interval

``` r
int <- interval(ymd("2025-07-01"), ymd("2025-07-31"))

# length in days
int_length(int)/86400
```

    ## [1] 30

``` r
target <- ymd("2025-07-17")
target %within% int
```

    ## [1] TRUE

# 9. Other Useful Functions

Below are some handy functions in `lubridate` for working with dates and
times:

| **Function**      | **Purpose**                             |
|-------------------|-----------------------------------------|
| `today()`         | Current date                            |
| `now()`           | Current date-time                       |
| `leap_year()`     | Check for leap year                     |
| `is.Date()`       | Check if object is of Date class        |
| `make_date()`     | Create a date from year, month, and day |
| `make_datetime()` | Create a datetime from components       |

``` r
today()
```

    ## [1] "2025-10-16"

``` r
now()
```

    ## [1] "2025-10-16 19:32:24 IST"

``` r
leap_year(2024)
```

    ## [1] TRUE

``` r
make_date(2025, 12, 31)
```

    ## [1] "2025-12-31"

``` r
make_datetime(2025, 12, 31, 14, 30, 0)
```

    ## [1] "2025-12-31 14:30:00 UTC"

# Summary Table of `lubridate` Functions

| **Category**  | **Functions**                          |
|---------------|----------------------------------------|
| Parsing       | `ymd()`, `dmy()`, `mdy()`, `ymd_hms()` |
| Extraction    | `year()`, `month()`, `day()`, `hour()` |
| Modification  | `year() <-`, `month() <-`, etc.        |
| Time Zones    | `with_tz()`, `force_tz()`, `tz()`      |
| Rounding      | `round_date()`, `floor_date()`         |
| Arithmetic    | `days()`, `months()`, `duration()`     |
| Intervals     | `interval()`, `%within%`               |
| Current Dates | `today()`, `now()`, `leap_year()`      |

# System date functions

| **Function** | **Returns**         | **Class** | **Time Included** |
|--------------|---------------------|-----------|-------------------|
| `Sys.Date()` | System Date         | `Date`    | ❌ No             |
| `Sys.time()` | System Date-Time    | `POSIXct` | ✅ Yes            |
| `now()`      | lubridate Date-Time | `POSIXct` | ✅ Yes            |

``` r
Sys.Date()          # "2025-07-17"
```

    ## [1] "2025-10-16"

``` r
Sys.time()          
```

    ## [1] "2025-10-16 19:32:24 IST"

## Formate changing

``` r
format(Sys.time(), "%Y-%m-%d")   # Just the date
```

    ## [1] "2025-10-16"

``` r
format(Sys.time(), "%H:%M:%S")   # Just the time
```

    ## [1] "19:32:24"

``` r
format(Sys.time(), "%Y-%m-%d %H:%M:%S") # Full date-time  
```

    ## [1] "2025-10-16 19:32:24"

## Adding

``` r
Sys.Date()+ 1  # Adds one day
```

    ## [1] "2025-10-17"

``` r
Sys.Date()+ month(1)  # Adds one month
```

    ## [1] "2025-10-17"

``` r
Sys.Date() + years(1)  # Adds one year
```

    ## [1] "2026-10-16"

``` r
Sys.Date() + days(10)  # Adds 10 days
```

    ## [1] "2025-10-26"

``` r
Sys.time() + hours(2)  # Adds 2 hours
```

    ## [1] "2025-10-16 21:32:24 IST"

``` r
Sys.time() + minutes(30)  # Adds 30 minutes
```

    ## [1] "2025-10-16 20:02:24 IST"

``` r
Sys.time() + seconds(45)  # Adds 45 seconds
```

    ## [1] "2025-10-16 19:33:09 IST"

``` r
Sys.time() + days(1)  # Adds 1 day
```

    ## [1] "2025-10-17 19:32:24 IST"

``` r
Sys.time() + weeks(1)  # Adds 1 week
```

    ## [1] "2025-10-23 19:32:24 IST"

``` r
Sys.time() + months(1)  # Adds 1 month
```

    ## [1] "2025-11-16 19:32:24 IST"

``` r
Sys.time() + years(1)  # Adds 1 year
```

    ## [1] "2026-10-16 19:32:24 IST"
