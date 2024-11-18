library(here)
library(dplyr)
library(tidyr)
library(usethis)
library(boot)

finaldata <- read.csv(here("data", "finaldata.csv"))
data2017 <- finaldata |>
  dplyr::filter(year == 2017) |>
  dplyr::filter(!is.na(infmor)) 

data2017 |>
  group_by(armconf1) |>
  summarise(n = n(),
            median.infmor = median(infmor, na.rm = T))

obs.med.diff <- median(data2017[data2017$armconf1 == 1,]$infmor) -
  median(data2017[data2017$armconf1 == 0,]$infmor)
obs.med.diff

infmor.arm1 <- finaldata |>
  dplyr::filter(year == 2017 & !is.na(infmor) & armconf1 == 1) |>
  dplyr::select(ISO, infmor)
infmor.arm0 <- finaldata|>
  dplyr::filter(year == 2017 & !is.na(infmor) & armconf1 == 0) |>
  dplyr::select(ISO, infmor)

set.seed(2024)
B <- 1000
med.diff <- rep(NA, B)
for(b in 1:B){
  resamp.arm1 <- infmor.arm1[sample(nrow(infmor.arm1), size = nrow(infmor.arm1), replace = TRUE),]
  resamp.arm0 <- infmor.arm0[sample(nrow(infmor.arm0), size = nrow(infmor.arm0), replace = TRUE),]
  med.diff[b] <- median(resamp.arm1$infmor) - median(resamp.arm0$infmor)
}
head(resamp.arm1, 12)

getmeddiff <- function(data, indices) {
  sample_data <- data[indices, ]
  group_meds <- tapply(sample_data$matmor, sample_data$armconf1, FUN = function(x) median(x,na.rm=TRUE))
  meddiff <- group_meds[2] - group_meds[1]
  return(meddiff)
}

bootout <- boot(data2017, statistic = getmeddiff, strata = data2017$armconf1, R = 1000)
boot.ci(boot.out = bootout, conf = 0.95, type = c("basic", "perc", "bca"))