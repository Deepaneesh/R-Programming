library(tidyverse)
library(httr)
library(jsonlite)
library(listviewer)

year <- 2024
# -------------------------------
# 1. Fetch OFF values dynamically
# -------------------------------

url_list <- "https://api.ipstatsdc.deda.prd.web1.wipo.int/api/v1/public/ips-search/loadOffOrgTechList?indicator=30&rpType=11"

resp_list <- GET(
  url_list,
  add_headers(
    "accept" = "application/json, text/plain, */*",
    "accept-language" = "en",
    "origin" = "https://www3.wipo.int",
    "priority" = "u=1, i",
    "referer" = "https://www3.wipo.int/",
    "sec-ch-ua" = "\"Chromium\";v=\"142\", \"Google Chrome\";v=\"142\", \"Not_A Brand\";v=\"99\"",
    "sec-ch-ua-mobile" = "?0",
    "sec-ch-ua-platform" = "\"Windows\"",
    "sec-fetch-dest" = "empty",
    "sec-fetch-mode" = "cors",
    "sec-fetch-site" = "same-site",
    "user-agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
  )
)

json_data <- content(resp_list, "text")
parsed <- fromJSON(json_data)

# Extract all OFF codes
all_codes <- parsed$ipsOffListSeq %>% unlist() %>% names()

# Collapse into comma-separated list
ipsOffSelValues <- paste(all_codes, collapse = ",")

cat("Total codes:", length(all_codes), "\n")
cat("Codes preview:", substr(ipsOffSelValues, 1, 150), "...\n\n")

# -------------------------------
# 2. Build download URL
# -------------------------------

download_url <- paste0(
  "https://api.ipstatsdc.deda.prd.web1.wipo.int/api/v1/public/ips-search/downloadCsv?",
  "selectedTab=trademark",
  "&indicator=30",
  "&reportType=11",
  "&fromYear=1980",
  "&toYear=", year,
  "&ipsOffSelValues=", ipsOffSelValues,
  "&ipsTechSelValues=900"
)

# -------------------------------
# 3. Send GET request (browser headers required)
# -------------------------------

resp_csv <- GET(
  download_url,
  add_headers(
    "accept" = "application/json, text/plain, */*",
    "accept-language" = "en",
    "origin" = "https://www3.wipo.int",
    "priority" = "u=1, i",
    "referer" = "https://www3.wipo.int/",
    "sec-ch-ua" = "\"Chromium\";v=\"142\", \"Google Chrome\";v=\"142\", \"Not_A Brand\";v=\"99\"",
    "sec-ch-ua-mobile" = "?0",
    "sec-ch-ua-platform" = "\"Windows\"",
    "sec-fetch-dest" = "empty",
    "sec-fetch-mode" = "cors",
    "sec-fetch-site" = "same-site",
    "user-agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
  )
)

# -------------------------------
# 4. Save downloaded CSV
# -------------------------------

writeBin(content(resp_csv, "raw"), "C:/Users/deepa/Downloads/Telegram Desktop/wipo_data.csv")


df <- read.csv(
  "C:/Users/deepa/Downloads/Telegram Desktop/wipo_data.csv",
  skip = 6,
  header = TRUE,
  row.names = NULL,
  check.names = FALSE
)

df1 <- setNames(df[ , -ncol(df)], names(df)[-1])

