# Mortgage Lending Policy Impact Analysis
# 03 - Qualified Mortgage Policy Analysis
# Author: Anne Han
#
# Objective:
# Evaluate whether racial disparities in California mortgage approval
# outcomes changed following the 2021 Qualified Mortgage reform.
#
# Run 01_data_preparation.R first to generate the cleaned annual datasets.

library(tidyverse)


# -------------------------------------------------------------------
# 1. Load cleaned annual datasets
# -------------------------------------------------------------------

processed_data_dir <- "data/processed"

years <- 2019:2024

annual_files <- file.path(
  processed_data_dir,
  paste0("hmda_", years, "_clean.rds")
)

hmda_pooled <- annual_files |>
  lapply(readRDS) |>
  bind_rows()


# -------------------------------------------------------------------
# 2. Validate pooled sample
# -------------------------------------------------------------------

dim(hmda_pooled)

table(hmda_pooled$activity_year)


# -------------------------------------------------------------------
# 3. Create policy and race indicators
# -------------------------------------------------------------------

hmda_pooled <- hmda_pooled |>
  mutate(
    # Pre-reform: 2019-2021
    # Post-reform: 2022-2024
    post_qm = if_else(
      activity_year >= 2022,
      1,
      0
    ),
    
    black = if_else(
      derived_race == "Black or African American",
      1,
      0
    )
  )


# -------------------------------------------------------------------
# 4. Estimate pooled QM interaction model
# -------------------------------------------------------------------

# With the large pooled sample, glm() may report that some fitted
# probabilities are numerically 0 or 1. The model was checked
# after estimation and successfully converged.

interaction_model <- glm(
  approved ~
    black +
    post_qm +
    black:post_qm +
    income +
    loan_amount +
    property_value +
    debt_to_income_ratio,
  data = hmda_pooled,
  family = binomial()
)

# Verify model convergence.
interaction_model$converged

# -------------------------------------------------------------------
# 5. Extract pooled model results
# -------------------------------------------------------------------

pooled_terms <- c(
  "black",
  "post_qm",
  "black:post_qm"
)

pooled_summary <- coef(
  summary(interaction_model)
)

pooled_results <- tibble(
  variable = c(
    "Black",
    "Post-QM",
    "Black x Post-QM"
  ),
  
  estimate = pooled_summary[
    pooled_terms,
    "Estimate"
  ],
  
  standard_error = pooled_summary[
    pooled_terms,
    "Std. Error"
  ],
  
  p_value = pooled_summary[
    pooled_terms,
    "Pr(>|z|)"
  ]
) |>
  mutate(
    odds_ratio = exp(estimate)
  ) |>
  select(
    variable,
    odds_ratio,
    standard_error,
    p_value
  )

pooled_results


# Calculate the relative post-reform change for Black applicants.
interaction_odds_ratio <- pooled_results |>
  filter(variable == "Black x Post-QM") |>
  pull(odds_ratio)

relative_post_qm_change_pct <-
  (interaction_odds_ratio - 1) * 100

relative_post_qm_change_pct


# -------------------------------------------------------------------
# 6. Create income quartiles
# -------------------------------------------------------------------

income_breaks <- quantile(
  hmda_pooled$income,
  probs = c(
    0,
    0.25,
    0.50,
    0.75,
    1
  ),
  na.rm = TRUE
)

income_breaks


hmda_pooled <- hmda_pooled |>
  mutate(
    income_quartile = cut(
      income,
      breaks = income_breaks,
      include.lowest = TRUE,
      labels = c(
        "Q1",
        "Q2",
        "Q3",
        "Q4"
      )
    )
  )

table(hmda_pooled$income_quartile)


# -------------------------------------------------------------------
# 7. Define quartile interaction analysis function
# -------------------------------------------------------------------

analyze_income_quartile <- function(
    data,
    quartile
) {
  
  quartile_data <- data |>
    filter(
      income_quartile == quartile
    )
  
  quartile_model <- glm(
    approved ~
      black +
      post_qm +
      black:post_qm +
      income +
      loan_amount +
      property_value +
      debt_to_income_ratio,
    data = quartile_data,
    family = binomial()
  )
  
  interaction_result <- coef(
    summary(quartile_model)
  )["black:post_qm", ]
  
  estimate <- interaction_result["Estimate"]
  standard_error <- interaction_result["Std. Error"]
  p_value <- interaction_result["Pr(>|z|)"]
  
  result <- tibble(
    quartile = quartile,
    estimate = as.numeric(estimate),
    standard_error = as.numeric(standard_error),
    odds_ratio = exp(as.numeric(estimate)),
    lower_ci = exp(
      as.numeric(estimate) -
        1.96 * as.numeric(standard_error)
    ),
    upper_ci = exp(
      as.numeric(estimate) +
        1.96 * as.numeric(standard_error)
    ),
    p_value = as.numeric(p_value)
  )
  
  rm(
    quartile_data,
    quartile_model
  )
  
  gc()
  
  return(result)
}


# -------------------------------------------------------------------
# 8. Estimate interaction model by income quartile
# -------------------------------------------------------------------

quartile_results <- map_dfr(
  c(
    "Q1",
    "Q2",
    "Q3",
    "Q4"
  ),
  ~ analyze_income_quartile(
    hmda_pooled,
    .x
  )
)

quartile_results


# -------------------------------------------------------------------
# 9. Add income-range labels
# -------------------------------------------------------------------

quartile_results <- quartile_results |>
  mutate(
    income_range = case_when(
      quartile == "Q1" ~ "$10,000-$80,000",
      quartile == "Q2" ~ "$80,000-$120,000",
      quartile == "Q3" ~ "$120,000-$186,000",
      quartile == "Q4" ~ "Above $186,000"
    )
  ) |>
  select(
    quartile,
    income_range,
    odds_ratio,
    lower_ci,
    upper_ci,
    p_value
  )

quartile_results


# -------------------------------------------------------------------
# 10. Reproduce Figure 2
# -------------------------------------------------------------------

income_effect_plot <- ggplot(
  quartile_results,
  aes(
    x = quartile,
    y = odds_ratio
  )
) +
  geom_hline(
    yintercept = 1,
    linetype = "dashed",
    linewidth = 0.7,
    color = "grey50"
  ) +
  geom_point(
    size = 3
  ) +
  geom_errorbar(
    aes(
      ymin = lower_ci,
      ymax = upper_ci
    ),
    width = 0.12,
    linewidth = 0.7
  ) +
  labs(
    title = "QM Reform Effects by Income Quartile",
    x = "Income Quartile",
    y = "Interaction Odds Ratio"
  ) +
  theme_minimal(
    base_size = 12
  )

income_effect_plot

ggsave(
  filename = "figures/qm_effects_by_income_quartile.png",
  plot = income_effect_plot,
  width = 8,
  height = 5,
  dpi = 300
)


# -------------------------------------------------------------------
# 11. Final validation tables
# -------------------------------------------------------------------

pooled_results |>
  mutate(
    odds_ratio = sprintf(
      "%.3f",
      odds_ratio
    ),
    standard_error = sprintf(
      "%.3f",
      standard_error
    )
  )

quartile_results |>
  mutate(
    odds_ratio = sprintf("%.3f", odds_ratio),
    lower_ci = sprintf("%.3f", lower_ci),
    upper_ci = sprintf("%.3f", upper_ci),
    p_value = sprintf("%.4f", p_value)
  )
