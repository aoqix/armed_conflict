##### Week 2 in class assignment CHL8010 disaster script
#####

library(here)
library(dplyr)
library(tidyr)
library(usethis)

here()

disaster <- read.csv(here("original", "disaster.csv"), header = TRUE)

disaster_new <- disaster %>% filter(Disaster.Type 
                                    %in% c("Earthquake","Drought") &
                                      Year %in% 2000:2019)

disaster_new <- disaster_new %>% select(Year, ISO,
                                        Disaster.Type)

disaster_new$drought <- ifelse(disaster_new$Disaster.Type == "Drought", 1, 0)

disaster_new$earthquake <- ifelse(disaster_new$Disaster.Type == "Earthquake", 1, 0)

disaster_new_1 <- disaster_new %>% group_by(ISO, Year) %>% 
  summarize(drought = sum(drought), earthquake = sum(earthquake))
