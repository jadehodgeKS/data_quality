
library(Rnssp)

#create profile for accessing API data from ESSENCE
ProfileJH <- Credentials$new(
  username = "jhodge01",
  password = askme()
)

# save profile object to file for future use
saveRDS(ProfileJH, "/opt/sas/shared/homes/jhodge01/ProfileJH.rds")


# Load profile object
ProfileJH <- readRDS("~/ProfileJH.rds")
