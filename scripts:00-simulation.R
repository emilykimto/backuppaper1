#### Workspace set-up ####
install.packages("opendatatoronto")
install.packages("lubridate")
install.packages("knitr")
install.packages("tidyverse")

library(knitr)
library(janitor)
library(lubridate)
library(opendatatoronto)
library(tidyverse)

set.seed(853)

simulated_languageduration_data <-
  tibble(
    date = rep(x = as.Date("2021-01-01") + c(0:364), times = 3),
    language = c(
      rep(x = "Language 1", times = 365),
      rep(x = "Language 2", times = 365),
      rep(x = "Language 3", times = 365)
    ),
    call_duration =
      rpois(
        n = 365 * 3,
        lambda = 15
      )
  )

head(simulated_languageduration_data)
