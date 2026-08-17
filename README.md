# Mortgage Lending Policy Impact Analysis: Racial Disparities & the 2021 Qualified Mortgage Reform
Econometric analysis of 4.2 million California mortgage applications using logistic regression and interaction models to evaluate racial disparities in lending and the impact of the 2021 Qualified Mortgage reform.

## Overview
This project examines racial disparities in mortgage approval outcomes and evaluates whether those disparities changed following the 2021 Qualified Mortgage (QM) reform. Using California mortgage application data from the Home Mortgage Disclosure Act (HMDA) for 2019–2024, I analyzed approval patterns for Black and White applicants before and after the policy change.

The analysis combines descriptive approval-rate comparisons with logistic regression models that control for observable borrower and loan characteristics, including applicant income, loan amount, property value, and debt-to-income ratio. A pooled interaction model was then used to estimate whether the relative approval gap changed during the post-reform period.

## Research Questions
The analysis addresses three primary questions:

1. Do disparities in mortgage approval outcomes between Black and White applicants persist after accounting for observable borrower and loan characteristics?
2. Did the racial approval gap change following the 2021 Qualified Mortgage reform?
3. Did the estimated impact of the reform differ across borrower income levels?

## Dataset
The analysis uses 2019–2024 mortgage application data from the Home Mortgage Disclosure Act (HMDA), restricted to California and focused on Black and White applicants.

The final analytical sample contains approximately **4.2 million mortgage applications** and includes information on mortgage approval outcomes, applicant characteristics, and loan and property characteristics used in the regression analysis.

Key variables include:

- **Mortgage approval outcome**
- **Applicant race**
- **Applicant income**
- **Loan amount**
- **Property value**
- **Debt-to-income ratio**
- **Application year**
- **Pre-/post-QM reform period**

## Analytical Approach
### 1. Descriptive Analysis — Mortgage Approval Rates

I first compared annual mortgage approval rates for Black and White applicants from 2019 through 2024 to examine how the raw racial approval gap evolved before and after the Qualified Mortgage reform.

Across all six years, White applicants had higher approval rates than Black applicants. The unadjusted approval gap ranged from approximately **8 to 11 percentage points**, indicating persistent differences in mortgage approval outcomes throughout the study period.

![Mortgage approval rates for Black and White applicants, 2019–2024](figures/mortgage_approval_rates.png)

*Annual mortgage approval rates for Black and White applicants in the California HMDA analytical sample, 2019–2024.*

| Year | White Approval Rate | Black Approval Rate | Gap |
| ---- | ------------------: | ------------------: | --: |
| 2019 | 81.3% | 70.8% | 10.5 pp |
| 2020 | 86.9% | 78.4% | 8.5 pp |
| 2021 | 87.6% | 79.6% | 8.0 pp |
| 2022 | 79.4% | 69.6% | 9.8 pp |
| 2023 | 75.9% | 64.7% | 11.2 pp |
| 2024 | 77.0% | 65.7% | 11.3 pp |

Because these raw differences do not account for differences in borrower financial characteristics, descriptive approval rates alone cannot determine whether disparities persist among otherwise observationally similar applicants. I therefore used logistic regression to estimate approval disparities while controlling for observable borrower and loan characteristics.
