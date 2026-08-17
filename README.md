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
