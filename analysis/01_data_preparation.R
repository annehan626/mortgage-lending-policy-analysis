# Mortgage Lending Policy Impact Analysis
# 01 - Data Preparation
# Author: Anne Han
#
# Objective:
# Prepare California HMDA mortgage application data from 2019-2024
# for descriptive and logistic regression analysis.
#
# The public HMDA raw files are not included in this repository.
# Place the six annual HMDA LAR files in data/raw/ before running.

library(tidyverse)
library(data.table)


# -------------------------------------------------------------------
# 1. File paths
# -------------------------------------------------------------------

raw_data_dir <- "data/raw"
processed_data_dir <- "data/processed"

dir.create(
  processed_data_dir,
  recursive = TRUE,
  showWarnings = FALSE
)

file_2019 <- file.path(raw_data_dir, "2019_public_lar_csv.csv")
file_2020 <- file.path(raw_data_dir, "2020_lar_csv.csv")
file_2021 <- file.path(raw_data_dir, "2021_public_lar.csv")
file_2022 <- file.path(raw_data_dir, "2022_public_lar_csv.csv")
file_2023 <- file.path(raw_data_dir, "2023_public_lar_csv.csv")
file_2024 <- file.path(raw_data_dir, "2024_public_lar_csv.csv")


# -------------------------------------------------------------------
# 2. Define variables needed for the final analysis
# -------------------------------------------------------------------

needed_cols <- c(
  "activity_year",
  "state_code",
  "derived_race",
  "action_taken",
  "loan_amount",
  "property_value",
  "income",
  "debt_to_income_ratio"
)

dti_levels <- c(
  "<20%",
  "20%-<30%",
  "30%-<36%",
  "36",
  "37",
  "38",
  "39",
  "40",
  "41",
  "42",
  "43",
  "44",
  "45",
  "46",
  "47",
  "48",
  "49",
  "50%-60%",
  ">60%"
)


# -------------------------------------------------------------------
# 3. Define annual cleaning function
# -------------------------------------------------------------------

clean_hmda_year <- function(file_path) {
  
  hmda_raw <- fread(
    file_path,
    select = needed_cols
  )
  
  hmda_clean <- hmda_raw |>
    as_tibble() |>
    
    filter(
      state_code == "CA",
      action_taken %in% c(1, 3),
      
      derived_race %in% c(
        "White",
        "Black or African American"
      ),
      
      !is.na(income),
      
      # HMDA reports income in thousands of dollars.
      # 10-1000 therefore corresponds to $10,000-$1,000,000.
      income >= 10,
      income <= 1000,
      
      !is.na(property_value),
      property_value != "Exempt",
      
      !is.na(debt_to_income_ratio),
      debt_to_income_ratio != "Exempt"
    ) |>
    
    mutate(
      approved = if_else(
        action_taken == 1,
        1,
        0
      ),
      
      income = as.numeric(income),
      loan_amount = as.numeric(loan_amount),
      property_value = as.numeric(property_value),
      
      derived_race = relevel(
        factor(derived_race),
        ref = "White"
      ),
      
      debt_to_income_ratio = factor(
        debt_to_income_ratio,
        levels = dti_levels
      )
    ) |>
    
    filter(
      !is.na(property_value),
      !is.na(debt_to_income_ratio)
    ) |>
    
    select(
      activity_year,
      derived_race,
      approved,
      income,
      loan_amount,
      property_value,
      debt_to_income_ratio
    )
  
  rm(hmda_raw)
  gc()
  
  return(hmda_clean)
}


# -------------------------------------------------------------------
# 4. Process and save one year at a time
# -------------------------------------------------------------------

process_and_save_year <- function(
    file_path,
    output_name
) {
  
  clean_data <- clean_hmda_year(file_path)
  
  n_obs <- nrow(clean_data)
  
  saveRDS(
    clean_data,
    file.path(
      processed_data_dir,
      output_name
    )
  )
  
  rm(clean_data)
  gc()
  
  return(n_obs)
}


# -------------------------------------------------------------------
# 5. Clean all six years
# -------------------------------------------------------------------

annual_counts <- tibble(
  year = 2019:2024,
  
  observations = c(
    process_and_save_year(
      file_2019,
      "hmda_2019_clean.rds"
    ),
    
    process_and_save_year(
      file_2020,
      "hmda_2020_clean.rds"
    ),
    
    process_and_save_year(
      file_2021,
      "hmda_2021_clean.rds"
    ),
    
    process_and_save_year(
      file_2022,
      "hmda_2022_clean.rds"
    ),
    
    process_and_save_year(
      file_2023,
      "hmda_2023_clean.rds"
    ),
    
    process_and_save_year(
      file_2024,
      "hmda_2024_clean.rds"
    )
  )
)


# -------------------------------------------------------------------
# 6. Validate sample sizes
# -------------------------------------------------------------------

annual_counts

total_observations <- sum(
  annual_counts$observations
)

total_observations
