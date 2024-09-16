##### Week 2 in class assignment CHL8010
#####

library(here)
library(dplyr)
library(tidyr)
library(usethis)

here()
maternal <- read.csv(here("original", "maternalmortality.csv"), header = TRUE)

new_maternal <- select(maternal, c(Country.Name,
                                   X2000:X2019))

colnames(new_maternal) <- gsub("X","",colnames(new_maternal))

new_maternal <- pivot_longer(new_maternal, cols=starts_with("20"),
                             names_to='Year',
                             values_to='MatMor')

# head(new_maternal, n = 20)

usethis::use_git_config(user.name = "aoqix", 
                        user.email = "aoqi.xie@mail.utoronto.ca")
usethis::use_git()
usethis::create_github_token()
gitcreds::gitcreds_set()
usethis::use_github()


