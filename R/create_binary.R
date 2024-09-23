library(here)
library(dplyr)
library(tidyr)
library(usethis)
library(purrr)
library(countrycode)

here()

con.df <- read.csv(here("original", "conflictdata.csv"), 
                     header = TRUE)

con.df <- con.df %>% group_by(ISO, year) %>% 
  summarize(best = sum(best))

con.df$conflict <- ifelse(con.df$best>25, 1, 0)

con.df$best <- NULL

con.df$country.name <- NULL

con.df <- rename(con.df, Year = year)