# Packages & Building Connection -------------------------------------------------------------------

library(dplyr)
library(DBI)
library(tidyverse)
library(xlsx)
library(stringr)


library(odbc)
datamart <- dbConnect(odbc::odbc(), dsn = 'BioSense_Platform')


# Query for one or a few Raw messages --------------------------------------------------------------


raw_msg_id <- dbGetQuery(datamart,
  "SELECT *
   FROM ks_pr_raw
   WHERE message_id in ('000000', '1111111')")

# Queries for all raw messages for a given time frame -----------------------------------------------

# Query Processed Tables
msgs <- dbGetQuery(datamart,
    "select Message
     from ks_pr_processed left join ks_pr_raw
        on [ks_pr_processed].Message_ID=[ks_pr_raw].Message_ID
     where C_Visit_Date = '2022-07-15' and C_Biosense_Facility_ID='0000'")
write.table(msgs, file = "msgs.txt", quote = F, row.names=F, col.names=F)

# Query Staging Tables
msgs <- dbGetQuery(datamart,
    "select Message
    from ks_st_processed left join ks_st_raw
      on [ks_st_processed].Message_ID=[ks_st_raw].Message_ID
    where c_visit_date > '2022-06-01' and C_Biosense_Facility_ID='3848'")
write.table(msgs, file = "msgs.txt", quote = F, row.names=F, col.names=F)

# Query uses arrived_date_time instead of c_visit_date_time
msgs <- dbGetQuery(datamart,
    "select Message
     from ks_st_processed left join ks_st_raw
         on [ks_st_processed].Message_ID=[ks_st_raw].Message_ID
     where [ks_st_processed].Arrived_Date_Time > '2022-05-24' and C_Biosense_Facility_ID='3895'")
write.table(msgs, file = "msgs.txt", quote = F, row.names=F, col.names=F)

