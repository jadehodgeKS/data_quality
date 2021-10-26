
# Time series of Arrive_date

# Packages ------------------------------------------------------------------------

library(lubridate)
library(stringr)
library(dplyr)
library(tidyverse)
library(ggplot2)
library(plotly)
library(plyr)
library(gghighlight)
library(xts)
library(scales)
library(glue)

library(DBI)
library(odbc)
datamart <- dbConnect(odbc::odbc(), dsn = 'BioSense_Platform')


# Clean Data ----------------------------------------------------------------------

#SQL querry to retrieve data

date_seq <- seq.Date(from = as_date("2021-09-15"),
                     to = as_date("2021-10-15"), 
                     by = "day")

arrived_dates_df <- dbGetQuery(datamart, 
    "SELECT message_id, arrived_date
     FROM ks_pr_processed
     WHERE c_biosense_facility_id = 3838 and arrived_date between '2021-09-15' and '2021-10-15'")

# Adjust class of variables

arrived_dates_df$arrived_date <- as_datetime(arrived_dates_df$arrived_date)
class(arrived_dates_df$arrived_date)

arrived_dates_df$message_id <- str_remove_all(arrived_dates_df$message_id, "[:alpha:]|[:blank:]")
arrived_dates_df$message_id <- as.character(arrived_dates_df$message_id)
class(arrived_dates_df$message_id)

# Group by arrived_date to count daily records

arrived_counts <- arrived_dates_df %>%
  group_by(arrived_date) %>%
  dplyr::summarise(message_id) %>% 
  dplyr::count(arrived_date, name = "record_count") %>%
  ungroup(arrived_date)

# Fill in days with zero counts

daily_record_counts <- tidyr::complete(arrived_counts, arrived_date = date_seq,
                                       fill = list(record_count = 0))


# Time Series -----------------------------------------------------------------------

daily_record_counts %>%
  ggplot(aes(x = arrived_date, y = record_count)) +
  geom_line(size = .75, colour = "purple2") +
  geom_point(size = 1.25, aes(x = arrived_date, y = record_count, colour = record_count > 0)) +
  scale_colour_manual(name = 'flag', values = setNames(c('black','red'),c(T, F))) +
  ggtitle("Daily Record Count") +
  theme(plot.title = element_text(hjust = 0.5),
        panel.background = element_rect(fill = "gray87", colour = "black"),
        legend.position = "None") +
  xlab("Date") +
  ylab("Records") +
  scale_x_datetime(name = waiver(), 
                   date_breaks = "3 day",
                   date_labels = "%b %d")

# Save Plot ------------------------------------------------------------------------

ggsave("daily_record_count.png")
