
# Rnssp
# Using instructions at https://github.com/CDCgov/Rnssp

# Packages
# devtools::install_github("cdcgov/Rnssp")
library(Rnssp)

library(tidyverse)

# URL from ESSENCE
url <- "https://essence.syndromicsurveillance.org/nssp_essence/api/dataDetails/csv?facetIGHeight=150&endDate=13Jul22&geography=34185&facetIGWidth=300&_dc=1657725057015&percentParam=noPercent&datasource=va_hosp&startDate=14Apr22&filterDateRange=14Apr22&medicalGroupingSystem=essencesyndromes&userId=594&aqtTarget=TimeSeries&sortDateRangeMax=14Apr22&forceRefresh=true&geographySystem=hospital&detector=nodetectordetector&dateconfig=2&timeResolution=daily&hasBeenE=1&facetFreeY=true&filterDateRangeMax=14Apr22&sortDateRange=14Apr22"

# Update Start and End dates in ESSENCE API URL
#url <- change_dates(url, start_date = Sys.Date() - 30, end_date = Sys.Date())

# Data Pull from ESSENCE
api_data <- get_api_data(url, fromCSV = TRUE, profile = ProfileJH)

# Inspect data object structure
names(api_data)

glimpse(api_data)

# Save data as excel spreadsheet

write.xlsx(api_data, file = "ascension_manhattan_20220619.xlsx", sheetName = "data", 
           col.names = TRUE, row.names = TRUE, append = FALSE)









