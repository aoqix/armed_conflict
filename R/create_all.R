library(here)
library(dplyr)
library(tidyr)
library(usethis)
library(purrr)
library(countrycode)
source(here("R", "create_binary.R"))
source(here("R", "create_maternal.R"))
source(here("R", "create_disaster.R"))

covars <- read.csv(here("original", "covariates.csv"), header = TRUE)

covars <- rename(covars, Year = year)

final_data_1 <- left_join(combined_data, con.df, by = c('ISO','Year'))

final_data_2 <- left_join(final_data_1, covars, by = c('ISO','Year'))

final_data <- left_join(final_data_2, disaster_final, by = c('ISO','Year'))

final_data$totdeath[is.na(final_data$totdeath)] <- 0
final_data$conflict[is.na(final_data$conflict)] <- 0
final_data$drought[is.na(final_data$drought)] <- 0
final_data$earthquake[is.na(final_data$earthquake)] <- 0

table(final_data$ISO)
write.csv(final_data, here("data", "primaryanalysis_data.csv"), row.names = FALSE)
