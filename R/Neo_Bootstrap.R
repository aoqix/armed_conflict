library(here)
library(dplyr)
library(tidyr)
library(usethis)
library(boot)

finaldata <- read.csv(here("data", "finaldata.csv"))
data2017 <- finaldata |>
  dplyr::filter(year == 2017) |>
  dplyr::filter(!is.na(neomor)) 

data2017 |>
  group_by(armconf1) |>
  summarise(n = n(),
            median.neomor = median(neomor, na.rm = T))

obs.med.diff <- median(data2017[data2017$armconf1 == 1,]$neomor) -
  median(data2017[data2017$armconf1 == 0,]$neomor)
obs.med.diff

neomor.arm1 <- finaldata |>
  dplyr::filter(year == 2017 & !is.na(neomor) & armconf1 == 1) |>
  dplyr::select(ISO, neomor)
neomor.arm0 <- finaldata|>
  dplyr::filter(year == 2017 & !is.na(neomor) & armconf1 == 0) |>
  dplyr::select(ISO, neomor)

set.seed(2024)
B <- 1000
med.diff <- rep(NA, B)
for(b in 1:B){
  resamp.arm1 <- neomor.arm1[sample(nrow(neomor.arm1), size = nrow(neomor.arm1), replace = TRUE),]
  resamp.arm0 <- neomor.arm0[sample(nrow(neomor.arm0), size = nrow(neomor.arm0), replace = TRUE),]
  med.diff[b] <- median(resamp.arm1$neomor) - median(resamp.arm0$neomor)
}
head(resamp.arm1, 12)

getmeddiff <- function(data, indices) {
  sample_data <- data[indices, ]
  group_meds <- tapply(sample_data$neomor, sample_data$armconf1, FUN = function(x) median(x,na.rm=TRUE))
  meddiff <- group_meds[2] - group_meds[1]
  return(meddiff)
}

bootout <- boot(data2017, statistic = getmeddiff, strata = data2017$armconf1, R = 1000)
boot.ci(boot.out = bootout, conf = 0.95, type = c("basic", "perc", "bca"))