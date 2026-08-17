# Mortgage Lending Policy Impact Analysis
# 02 - Annual Approval Rates & Logistic Regression
# Author: Anne Han
#
# Objective:
# Estimate annual mortgage approval disparities between Black and White
# applicants in California from 2019-2024 using descriptive approval
# rates and controlled logistic regression models.
#
# Run 01_data_preparation.R first to generate the cleaned annual datasets.

library(tidyverse)


# -------------------------------------------------------------------
# 1. File paths
# -------------------------------------------------------------------

processed_data_dir <- "data/processed"


# -------------------------------------------------------------------
# 2. Define annual analysis function
# -------------------------------------------------------------------

analyze_hmda_year <- function(year) {
  
  file_path <- file.path(
    processed_data_dir,
    paste0("hmda_", year, "_clean.rds")
  )
  
  hmda_year <- readRDS(file_path)
  
  
  # -----------------------------------------------------------------
  # Approval rates by race
  # -----------------------------------------------------------------
  
  approval_rates <- hmda_year |>
    group_by(derived_race) |>
    summarise(
      observations = n(),
      approval_rate = mean(approved),
      .groups = "drop"
    ) |>
    mutate(
      year = year
    )
  
  
  # -----------------------------------------------------------------
  # Controlled logistic regression
  # -----------------------------------------------------------------
  
  model <- glm(
    approved ~
      derived_race +
      income +
      loan_amount +
      property_value +
      debt_to_income_ratio,
    data = hmda_year,
    family = binomial()
  )
  
  
  # Extract the Black-applicant coefficient and convert from
  # log-odds to an odds ratio.
  black_coefficient <-
    "derived_raceBlack or African American"
  
  black_odds_ratio <-
    exp(coef(model)[black_coefficient])
  
  
  regression_result <- tibble(
    year = year,
    black_odds_ratio = as.numeric(black_odds_ratio)
  )
  
  
  # Remove the large annual dataset and fitted model before
  # proceeding to the next year.
  rm(hmda_year, model)
  gc()
  
  
  return(
    list(
      approval_rates = approval_rates,
      regression_result = regression_result
    )
  )
}


# -------------------------------------------------------------------
# 3. Run annual analyses
# -------------------------------------------------------------------

years <- 2019:2024

annual_approval_rates <- tibble()

annual_regression_results <- tibble()


for (year in years) {
  
  results <- analyze_hmda_year(year)
  
  annual_approval_rates <- bind_rows(
    annual_approval_rates,
    results$approval_rates
  )
  
  annual_regression_results <- bind_rows(
    annual_regression_results,
    results$regression_result
  )
  
  rm(results)
  gc()
}


# -------------------------------------------------------------------
# 4. Review annual approval rates
# -------------------------------------------------------------------

annual_approval_rates


# Create a recruiter-friendly summary table.
approval_rate_table <- annual_approval_rates |>
  mutate(
    race = case_when(
      derived_race == "White" ~ "White",
      derived_race == "Black or African American" ~ "Black"
    )
  ) |>
  select(
    year,
    race,
    approval_rate
  ) |>
  pivot_wider(
    names_from = race,
    values_from = approval_rate
  ) |>
  mutate(
    White = White * 100,
    Black = Black * 100,
    gap_pp = White - Black
  )

approval_rate_table


# -------------------------------------------------------------------
# 5. Review annual logistic regression results
# -------------------------------------------------------------------

annual_regression_results


# Express the odds ratios as approximate percentage differences
# relative to White applicants.
annual_regression_results <- annual_regression_results |>
  mutate(
    lower_approval_odds_pct =
      (1 - black_odds_ratio) * 100
  )

annual_regression_results


# -------------------------------------------------------------------
# 6. Reproduce Figure 1
# -------------------------------------------------------------------

approval_plot_data <- approval_rate_table |>
  select(
    year,
    White,
    Black
  ) |>
  pivot_longer(
    cols = c(White, Black),
    names_to = "race",
    values_to = "approval_rate"
  )

approval_rate_plot <- ggplot(
  approval_plot_data,
  aes(
    x = year,
    y = approval_rate,
    color = race
  )
) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 2) +
  labs(
    title = "Mortgage Approval Rates for Black and White Applicants, 2019–2024",
    x = "Year",
    y = "Approval Rate (%)",
    color = "Applicant Race"
  ) +
  theme_minimal()

approval_rate_plot

ggsave(
  filename = "figures/mortgage_approval_rates.png",
  plot = approval_rate_plot,
  width = 8,
  height = 5,
  dpi = 300
)


# -------------------------------------------------------------------
# 7. Final validation tables
# -------------------------------------------------------------------

approval_rate_table |>
  mutate(
    across(
      c(White, Black, gap_pp),
      ~ round(.x, 1)
    )
  )

annual_regression_results |>
  mutate(
    black_odds_ratio =
      round(black_odds_ratio, 3),
    
    lower_approval_odds_pct =
      round(lower_approval_odds_pct, 1)
  )
