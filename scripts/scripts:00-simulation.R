#### Preamble ####
# Purpose: Get data on Toronto Language Services data during the 2021 year and make a table
# Author: Emily Kim
# Email: emilyuna.kim@mail.utoronto.ca
# Date: 28 January 2023
# Pre-req: None

#### Workspace set-up ####
install.packages("opendatatoronto")
install.packages("lubridate")
install.packages("tidyverse")

library(opendatatoronto)
library(janitor)
library(lubridate)
library(tidyverse)

#### Simulate ####
set.seed(853)

simulated_languageduration_data <-
  tibble(
    date = rep(x = as.Date("2014-01-01") + c(0:364*7), times = 3),
    language = c(
      rep(x = "Language 1", times = 365*8),
      rep(x = "Language 2", times = 365*8),
      rep(x = "Language 3", times = 365*8)
    ),
    call_duration =
      rpois(
        n = 365*8*3,
        lambda = 15
      )
  )

head(simulated_languageduration_data)

# This will generate a simulated dataset with a constant number of calls and
# constant language distribution over the 8 years between 2014-2021, which will
# not be representative of true data.
