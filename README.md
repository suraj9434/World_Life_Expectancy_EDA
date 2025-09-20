

# World Life Expectancy SQL Project: Data Cleaning & EDA

This project involves a comprehensive data cleaning and exploratory data analysis (EDA) of global life expectancy data using SQL. The goal is to process raw health and economic indicators, identify trends, and extract key insights that explain variations in life expectancy across countries and over time.



## Project Overview

The objective of this project was to tackle a real-world dataset on global life expectancy, which often comes with imperfections like duplicate records and missing values. After a thorough cleaning process, the project dives into exploratory data analysis to uncover correlations between life expectancy and various factors such as GDP, BMI, adult mortality, and a country's development status.

This project demonstrates strong proficiency in:
*   **SQL Data Cleaning:** Identifying and removing duplicate rows, handling missing values, and standardizing categorical data.
*   **SQL Exploratory Data Analysis (EDA):** Crafting advanced SQL queries to aggregate, trend, and compare various health and economic indicators.
*   **Window Functions:** Utilizing `ROW_NUMBER()` for efficient duplicate detection and `SUM() OVER (PARTITION BY...)` for rolling calculations.
*   **Conditional Aggregation:** Employing `CASE` statements within aggregate functions to compare different groups (e.g., high vs. low GDP countries).
*   **Data-Driven Insights:** Translating complex SQL query results into clear, actionable findings about global health and development.


## Dataset

*   **Name:** `world_life_expectancy`
*   **Description:** Contains various health and economic indicators for countries across different years.
*   **Key Fields:**
    *   `Country`, `Year`, `Status` (Developed/Developing)
    *   `Life expectancy`
    *   `GDP`, `BMI`, `Adult Mortality`
    *   And other related health and economic metrics.


## Methodology

The analysis followed a two-phase approach:

### 1. Data Cleaning

Before any meaningful analysis could be performed, the raw dataset required extensive cleaning to ensure data quality and accuracy.

*   **Duplicate Row Removal:**
    *   Identified duplicate entries based on `Country` and `Year` combinations.
    *   Utilized the `ROW_NUMBER()` window function to assign a unique rank to each row within duplicate groups and subsequently `DELETE` all but the first instance.
*   **`Status` Column Standardization:**
    *   Handled blank `Status` values (e.g., 'Developed', 'Developing') by imputing them from known `Status` values of the same country in other years using an `UPDATE JOIN` statement.
*   **Missing `Life expectancy` Imputation:**
    *   Addressed missing `Life expectancy` values by replacing them with the average of the previous and next year's life expectancy for that specific country. This approach provides a reasonable estimate for missing data points, again using `UPDATE JOIN`.

### 2. Exploratory Data Analysis (EDA)

With a clean dataset, the following exploratory queries were executed to uncover patterns and relationships:

*   **Life Expectancy Trends:**
    *   Calculated the minimum, maximum, and total increase in life expectancy over time for each country.
    *   Determined the global average life expectancy per year to observe overall progress.
*   **GDP & Economic Correlations:**
    *   Analyzed the relationship between average `GDP` and average `Life expectancy` for each country.
    *   Compared the average life expectancy between countries with `GDP >= 1500` (high GDP) and `GDP < 1500` (low GDP).
*   **Developed vs. Developing Status:**
    *   Computed the average life expectancy for 'Developed' versus 'Developing' countries.
    *   Counted the number of unique countries in each status category and their respective average life expectancies.
*   **Health Indicators:**
    *   Examined the correlation between `BMI` and `Life expectancy` per country.
    *   Calculated a rolling total of `Adult Mortality` for specific countries (e.g., 'United States', 'United Kingdom') to observe cumulative mortality trends over years.


## Key Findings

The comprehensive cleaning and EDA revealed several critical insights:

*   **Global Progress:** There has been a **steady and consistent increase** in global average life expectancy over the years, indicating overall improvements in health and living conditions worldwide.
*   **Wealth & Health Correlation:** Nations with **higher average GDP** consistently demonstrate **longer life spans**, highlighting the strong link between economic prosperity and health outcomes.
*   **Development Status Gap:** **Developed countries** generally exhibit higher average life expectancies compared to **developing countries**. (Note: The raw data initially showed some skewness for developing countries, which was addressed during cleaning).
*   **Key Health Factors:** `BMI` and `Adult Mortality` show a **strong inverse correlation** with life expectancy; countries with higher average BMI or lower adult mortality rates tend to have higher life expectancies.



## How to Reproduce

To run this analysis:

1.  **Database Environment:** Ensure you have an SQL database environment (e.g., MySQL, PostgreSQL, SQL Server) set up. The provided SQL script is written with general SQL syntax but was likely executed in a MySQL environment.
2.  **Load Data:** Import your `world_life_expectancy` dataset into your chosen SQL database. Make sure the table name and column names match those used in the script.
3.  **Execute Script:** Run the SQL queries in the provided script sequentially.
    *   First, execute the data cleaning sections.
    *   Then, proceed with the EDA queries to retrieve insights.


