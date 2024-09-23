##### Week 2 in class assignment CHL8010
#####

library(here)
library(dplyr)
library(tidyr)
library(usethis)
library(countrycode)

here()
maternal <- read.csv(here("original", "maternalmortality.csv"), header = TRUE)
infant <- read.csv(here("original", "infantmortality.csv"), header = TRUE)
neonatal <- read.csv(here("original", "neonatalmortality.csv"), header = TRUE)
under5 <- read.csv(here("original", "under5mortality.csv"), header = TRUE)

# head(new_maternal, n = 20)

clean_data <- function(data,datname){
  new_data <- select(data, c(Country.Name,
                             X2000:X2019))
  colnames(new_data) <- gsub("X","",colnames(new_data))
  new_data <- pivot_longer(new_data, cols=starts_with("20"),
                           names_to='Year',
                           values_to= paste0(substr(datname, 1, 3),'Mor'))
  new_data$Year = as.numeric(new_data$Year)
  return(new_data)
}

cleaned_infant <- clean_data(infant, "Infant")
cleaned_neonatal <- clean_data(neonatal, "Neonatal")
cleaned_under5 <- clean_data(under5, "Under5")
cleaned_maternal <- clean_data(maternal, "Maternal")

cleaned_mortlst <- list(cleaned_infant,
                        cleaned_neonatal,
                        cleaned_under5,
                        cleaned_maternal)

combined_data <- reduce(cleaned_mortlst, full_join)

combined_data$ISO <- countrycode(combined_data$Country.Name,
                                 origin = "country.name",
                                 destination = "iso3c")

combined_data$Country.Name <- NULL
