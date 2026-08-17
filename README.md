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

### 2. Logistic Regression — Adjusted Racial Approval Disparities
To examine whether racial disparities persisted after accounting for observable differences in borrower and loan characteristics, I estimated separate logistic regression models for each year from 2019 through 2024.

The dependent variable indicates whether a mortgage application was approved, while the primary explanatory variable identifies Black applicants, with White applicants serving as the reference group. Each model controls for:

- **Applicant income**
- **Loan amount**
- **Property value**
- **Debt-to-income ratio**

Regression coefficients were converted to odds ratios for interpretation. An odds ratio below 1 indicates lower approval odds for Black applicants relative to otherwise observationally similar White applicants.

| Year | Black Applicant Odds Ratio |
| ---- | -------------------------: |
| 2019 | 0.621 |
| 2020 | 0.618 |
| 2021 | 0.626 |
| 2022 | 0.665 |
| 2023 | 0.635 |
| 2024 | 0.647 |

Across all six years, Black applicants had significantly lower estimated odds of mortgage approval than White applicants after controlling for observable borrower and underwriting characteristics. The estimated odds ratios ranged from **0.618 to 0.665**, corresponding to approximately **33% to 38% lower approval odds**.

Although the annual estimates suggest that the disparity may have narrowed somewhat after 2021, comparing separate yearly models does not provide a formal test of whether the Qualified Mortgage reform changed the racial approval gap. I therefore estimated a pooled interaction model to directly evaluate the policy change.

### 3. Qualified Mortgage Reform — Pooled Interaction Model
To formally evaluate whether the racial approval gap changed following the 2021 Qualified Mortgage reform, I estimated a pooled logistic regression model using mortgage applications from 2019–2024.

The model includes an interaction between **Black applicant status** and the **post-reform period (2022–2024)**:

**Black × Post-QM**

This interaction tests whether the approval odds of Black applicants changed relative to White applicants after the reform, while controlling for applicant income, loan amount, property value, and debt-to-income ratio.

| Variable | Odds Ratio |
| -------- | ---------: |
| Black | 0.615 |
| Post-QM | 0.824 |
| **Black × Post-QM** | **1.083** |

The interaction term is positive and statistically significant (**p < 0.001**). The estimated odds ratio of **1.083** indicates that Black applicants experienced approximately **8.3% higher relative approval odds in the post-reform period compared with the pre-reform period**.

Importantly, this does not mean that Black applicants had higher approval odds than White applicants after the reform. Rather, the results indicate that the existing racial approval disparity became modestly smaller.

Overall, the analysis provides evidence of a **modest narrowing of the adjusted racial approval gap** following the 2021 Qualified Mortgage reform, while substantial disparities remained.
