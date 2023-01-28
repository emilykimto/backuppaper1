#### Preamble ####
# Purpose: Clean Language Services data downloaded from Toronto Open Data
# Author: Emily Kim
# Date: 28 January 2023
# Contact: emilyuna.kim@mail.utoronto.ca
# License: MIT
# Pre-req: None

#### Workspace Set-up ####
# install.packages("opendatatoronto")
# install.packages("tidyverse")
# install.packages("ggplot2")
# install.packages("knitr")
# install.packages("janitor")
# install.packages("lubridate")
# install.packages("tibble")
# install.packages("dplyr")

library(knitr)
library(janitor)
library(lubridate)
library(opendatatoronto)
library(tidyverse)
library(dplyr)
library(ggplot2)

#### Acquire the dataset from Toronto Open Data ####
language_services <-
  # https://open.toronto.ca/dataset/paramedic-services-911-language-interpretation/
  list_package_resources("42315239-36a8-4b7f-b2ab-6ab60fb0b935") |>
  filter(name ==
           "Language Services Data (2014 - 2021)") |>
  get_resource()

#### Saving the dataset ####
write_csv(
  x = language_services,
  file = "language_services.csv"
)

head(language_services)

#### Clean names and reduce data to relevant columns ####
language_services_clean <-
  clean_names(language_services) |>
  select(time_stamp, language, duration)

head(language_services_clean)

#### Saving cleaned dataset ####
write_csv(
  x = language_services_clean,
  file = "cleaned_language_services.csv"
)
