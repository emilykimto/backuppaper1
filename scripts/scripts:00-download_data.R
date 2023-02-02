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
# install.packages("dplyr")
# install.packages("ggplot2")
# install.packages("knitr")
# install.packages("lubridate")
# install.packages("kableExtra")

library(opendatatoronto)
library(tidyverse)
library(knitr)
library(dplyr)
library(ggplot2)
library(lubridate)
library(janitor)
library(tibble)
library(kableExtra)

#### Acquire the dataset from Toronto Open Data ####
language_services <-
  # https://open.toronto.ca/dataset/paramedic-services-911-language-interpretation/
  list_package_resources("42315239-36a8-4b7f-b2ab-6ab60fb0b935") |>
  filter(name == "Language Services Data (2014 - 2021)") |>
  get_resource()

#### Saving the dataset ####
write_csv(
  x = language_services,
  file = "language_services.csv"
)

#### Calculate the sum of call duration for each language ####
language_services_summary <-
  language_services |>
  group_by(Language) |>
  summarize(total_duration = sum(Duration))

head(language_services_summary)

#### Rename "total_duration" column to "Total Duration" ####
language_services_summary <-
  language_services_summary |>
  rename("Total Duration" = total_duration)

head(language_services_summary)

#### Find the top 10 languages that require language services ####
top_10_languages <-
  language_services_summary |>
  arrange(desc("Total Duration")) |>
  top_n(10)

#### Create table ####
top_10_languages |>
  knitr::kable(caption = "Top 10 languages based on the total duration of calls requiring language services", 
               col.names = c("Language", "Duration"),
               align = c('l', 'l'),
               booktabs = T) |>
  kable_styling(full_width = T) |>
  column_spec(1, width = "12cm")

#### Visualizing the fluctuations in the total duration of different languages
#### in emergency calls between the years 2014-2021

# Change the Time Stamp column in dataset into date-format and exclude rows with
# missing values in Time Stamp column
language_services_cleaned <- language_services |>
  mutate(Timestamp = as.POSIXct(`Time Stamp`, format = "%m/%d/%Y %H:%M:%S")) |>
  filter(!is.na(Timestamp)
  )

# Save file
write_csv(
  x = language_services_cleaned,
  file = "language_services_cleaned.csv"
)

#### Resulting dataset contains 26225 rows of emergency instances, while
#### the original had 27673 rows}

#### Creating a line graph showing the cumulative duration per year for the top
#### ten languages between 2014-2021

# Selecting the top 10 languages for the line graph
graph_languages <- c("ARABIC", "CANTONESE", "FARSI", "HUNGARIAN", 
                     "ITALIAN", "MANDARIN", "PORTUGESE", "RUSSIAN", 
                     "SPANISH", "TAMIL")

# Filter the data to include only the selected languages
language_services_cleaned_filtered <-
  language_services_cleaned |>
  filter(Language %in% graph_languages)

# Calculate the cumulative duration per year for each language
language_services_by_year <-
  language_services_cleaned_filtered |>
  group_by(Language, year = format(Timestamp, "%Y")) |>
  summarize(cumulative_duration = sum(Duration))

# Plot the line graph
ggplot(data = language_services_by_year, aes(x = year, y = cumulative_duration, color = Language, group = Language)) +
  geom_line() +
  labs(x = "Year",
       y = "Cumulative Duration (in minutes)") +
  scale_x_discrete(limits = c("2014", "2015", "2016", "2017", "2018", "2019", "2020", "2021"))