library(knitr)
library(janitor)
library(lubridate)
library(opendatatoronto)
library(tidyverse)

#### Acquire ####
language_services <-
  # https://open.toronto.ca/dataset/paramedic-services-911-language-interpretation/
  list_package_resources("42315239-36a8-4b7f-b2ab-6ab60fb0b935") |>
  filter(name ==
           "Language Services Data (2014 - 2021)") |>
  get_resource()

write_csv(
  x = language_services,
  file = "language_services.csv"
)

head(language_services)

language_services_clean <-
  clean_names(language_services) |>
  select(time_stamp, language, duration)

head(language_services_clean)

write_csv(
  x = language_services_clean,
  file = "cleaned_language_services.csv"
)
