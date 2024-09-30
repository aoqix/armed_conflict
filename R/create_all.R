source(here("R", "create_binary.R"))
source(here("R", "create_maternal.R"))
source(here("R", "create_disaster.R"))

covars <- read.csv(here("original", "covariates.csv"), header = TRUE)

covars <- rename(covars, Year = year) #heidi

final_data_1 <- left_join(combined_data, con.df, by = c('ISO','Year'))

final_data_2 <- left_join(final_data_1, covars, by = c('ISO','Year'))

final_data <- left_join(final_data_2, disaster_final, by = c('ISO','Year'))

table(final_data$ISO)

write.csv(final_data, here("original", "primaryanalysis_data.csv"))
