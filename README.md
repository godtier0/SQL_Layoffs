# SQL Layoffs Data Analysis


## Project Overview

This project analyzes a global layoffs dataset using SQL. The objective was to clean and transform the data, perform exploratory data analysis (EDA), identify key trends, and generate business insights regarding workforce reductions across companies, industries, and countries.

The analysis focuses on understanding how layoffs evolved over time, which industries and companies were most affected, and what broader economic events may have contributed to these workforce reductions.

---

## Dataset

The dataset contains information on layoffs from companies around the world, including:

* Company
* Industry
* Country
* Location
* Date
* Total Employees Laid Off
* Percentage Laid Off
* Company Stage
* Funds Raised

---

## Project Objectives

The project aimed to answer the following questions:

* Which companies experienced the largest layoffs?
* Which industries were most affected?
* Which countries recorded the highest layoffs?
* How did layoffs change over time?
* Which companies had the highest layoffs each year?
* What trends can be observed before, during, and after the COVID-19 pandemic?

---

## Data Cleaning Process

Several data quality issues were addressed before analysis:

* Removed duplicate records using ROW_NUMBER()
* Standardized company names
* Standardized industry values
* Removed unnecessary whitespace
* Converted date columns into proper SQL date format
* Handled null and blank values
* Improved overall data consistency

---

## SQL Skills Demonstrated

* Data Cleaning
* Aggregate Functions
* GROUP BY
* ORDER BY
* Window Functions
* Rolling Totals
* Common Table Expressions (CTEs)
* DENSE_RANK()
* ROW_NUMBER()
* Subqueries

---

## Exploratory Data Analysis

The analysis included:

### Company Analysis

* Companies with the highest total layoffs
* Companies with the largest single layoff events
* Top companies by layoffs each year

### Industry Analysis

* Industries most affected by layoffs
* Industry-level layoff comparisons

### Geographic Analysis

* Countries with the highest layoffs
* Regional layoff distribution

### Time-Series Analysis

* Monthly layoff trends
* Yearly layoff trends
* Rolling total layoffs over time

---

## Key Findings

### 1. January 2023 Recorded the Highest Monthly Layoffs

The highest monthly layoff total occurred in January 2023, with approximately 84,714 employees affected. This represents the most severe month in the dataset.

### 2. Early COVID-19 Triggered a Significant Layoff Wave

Large-scale layoffs were recorded during April 2020 (26,710) and May 2020 (25,804), coinciding with the early stages of the COVID-19 pandemic and widespread economic disruption.

### 3. Layoffs Increased Again During 2022–2023

After the initial pandemic shock, layoffs surged once more throughout 2022 and reached their peak in early 2023, indicating a second major workforce reduction cycle.

### 4. Technology and High-Growth Companies Were Heavily Impacted

Many of the largest layoffs occurred among technology and high-growth companies that expanded rapidly during the pandemic period.

### 5. Layoffs Were a Global Phenomenon

The data shows that workforce reductions occurred across multiple countries and industries, demonstrating the widespread nature of the economic challenges faced by businesses.

---

## Interpretation of Layoff Trends

The data suggests the existence of two major layoff waves.

### First Wave: COVID-19 Economic Shock (2020)

The first major wave occurred during the onset of the COVID-19 pandemic. Lockdowns, reduced consumer spending, supply chain disruptions, and economic uncertainty forced many organizations to reduce headcount quickly.

This is reflected in the significant layoff spikes observed in April and May 2020.

### Second Wave: Post-Pandemic Correction (2022–2023)

As businesses adapted to remote work and increased digital demand during the pandemic, many companies expanded their workforce aggressively between 2020 and 2021.

When economic conditions normalized, organizations began reassessing staffing levels. Combined with rising interest rates, inflation, reduced venture capital funding, and slower revenue growth, many companies found themselves overstaffed relative to demand.

As a result, businesses implemented large-scale workforce reductions throughout 2022 and early 2023.

The data had only the first 3 months of 2023 with a total layoff of 125,677 and 2022 with 160,661. There is a possibility that 2023 layoff will overtake that of 2022 at the end of the year.

---

## Business Insights

* Rapid workforce expansion during periods of exceptional growth can create long-term staffing challenges when market conditions change.
* Companies that scale aggressively without sustainable revenue growth may be more vulnerable to future layoffs.
* Economic shocks can create multiple waves of workforce restructuring, with effects lasting several years beyond the initial event.
* Workforce planning should account for both growth opportunities and potential economic downturns.

---

## Recommendations

Based on the findings:

1. Align hiring strategies with sustainable long-term business growth rather than short-term market conditions.

2. Develop workforce planning models that account for economic uncertainty and changing demand patterns.

3. Monitor key economic indicators such as inflation, interest rates, and consumer demand when making expansion decisions.

4. Implement scenario-based forecasting to avoid excessive hiring during periods of rapid growth.

5. Improve organizational flexibility through strategic workforce planning and resource allocation.

---

## Project Files

| File             | Description                              |
| ---------------- | ---------------------------------------- |
| DataCleaning.sql | Data cleaning and transformation queries |
| DataExp.sql      | Exploratory data analysis queries        |
| README.md        | Project documentation and findings       |

---

## Tools Used

* MySQL
* MySQL Workbench
* Git
* GitHub

---

## Conclusion

The analysis reveals that layoffs were influenced by both the immediate economic shock of COVID-19 and the subsequent post-pandemic market correction. The findings highlight the importance of sustainable workforce planning, economic awareness, and data-driven decision-making when managing organizational growth.
