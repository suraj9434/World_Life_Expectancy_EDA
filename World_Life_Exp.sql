/* ============================================================================================
   WORLD LIFE EXPECTANCY SQL PROJECT
   Author: Suraj Shrestha
   Purpose: Data Cleaning & Exploratory Data Analysis (EDA)

   Dataset: world_life_expectancy
   Fields: Country, Year, Status, Life expectancy, GDP, BMI, Adult Mortality, etc.
   ============================================================================================
*/

/* ============================================================================================
   1. PROJECT OVERVIEW
   - Clean raw data (remove duplicates, handle missing values, standardize categories).
   - Perform exploratory queries to analyze global health indicators.
   - Extract key insights about GDP, BMI, mortality, and life expectancy trends.
   ============================================================================================
*/

/* ============================================================================================
   2. DATA CLEANING
   ============================================================================================
*/

-- Preview table
SELECT * 
FROM world_life_expectancy;


/* 
   2.1 Remove Duplicate Rows
*/

-- Identify duplicates by Country + Year
SELECT Country, Year,
       COUNT(*) AS Duplicate_Count
FROM world_life_expectancy
GROUP BY Country, Year
HAVING COUNT(*) > 1;

-- Delete duplicate rows using ROW_NUMBER()
DELETE FROM world_life_expectancy
WHERE Row_ID IN (
    SELECT Row_ID
    FROM (
        SELECT Row_ID,
               ROW_NUMBER() OVER (PARTITION BY Country, Year ORDER BY Country, Year) AS Row_Num
        FROM world_life_expectancy
    ) AS row_table
    WHERE Row_Num > 1
);


/* 
   2.2 Fix Status Column
*/

-- Find blank Status values
SELECT * 
FROM world_life_expectancy
WHERE Status = '';

-- Update blanks by referencing same country’s valid status (Developed/Developing)
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
  ON t1.Country = t2.Country
SET t1.Status = t2.Status
WHERE t1.Status = ''
  AND t2.Status <> '';

-- Confirm blanks fixed
SELECT * 
FROM world_life_expectancy
WHERE Status = '';


/* 
   2.3 Handle Missing Life Expectancy
*/

-- Find rows with missing Life Expectancy
SELECT *
FROM world_life_expectancy
WHERE `Life expectancy` = '';

-- Replace blanks with average of previous and next year
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
  ON t1.Country = t2.Country AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
  ON t1.Country = t3.Country AND t1.Year = t3.Year + 1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2, 1)
WHERE t1.`Life expectancy` = '';

-- Confirm blanks fixed
SELECT *
FROM world_life_expectancy
WHERE `Life expectancy` = '';


/* ============================================================================================
   3. EXPLORATORY DATA ANALYSIS (EDA)
   ============================================================================================
*/

-- Check cleaned data
SELECT * 
FROM world_life_expectancy;


/*
   3.1 Life Expectancy Trends
*/
-- Min, Max, and Increase over time for each country
SELECT Country,
       MIN(`Life expectancy`) AS Min_Life_Expectancy,
       MAX(`Life expectancy`) AS Max_Life_Expectancy,
       ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`), 1) AS Increase
FROM world_life_expectancy
GROUP BY Country
HAVING Min_Life_Expectancy <> 0 AND Max_Life_Expectancy <> 0
ORDER BY Increase DESC;

-- Global yearly average life expectancy
SELECT Year, ROUND(AVG(`Life expectancy`), 2) AS Avg_Life_Exp
FROM world_life_expectancy
WHERE `Life expectancy` > 0
GROUP BY Year
ORDER BY Year;


/* 
   3.2 GDP & Economic Correlations
*/

-- GDP vs Life Expectancy per country
SELECT Country,
       ROUND(AVG(`Life expectancy`), 1) AS Life_Exp,
       ROUND(AVG(GDP), 1) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0 AND GDP > 0
ORDER BY GDP DESC;

-- Compare High vs Low GDP groups
SELECT 
  ROUND(AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` END), 2) AS High_GDP_Life_Exp,
  ROUND(AVG(CASE WHEN GDP < 1500 THEN `Life expectancy` END), 2) AS Low_GDP_Life_Exp
FROM world_life_expectancy;


/* 
   3.3 Developed vs Developing
*/

-- Average life expectancy by Status
SELECT Status, ROUND(AVG(`Life expectancy`), 1) AS Avg_Exp
FROM world_life_expectancy
GROUP BY Status;

-- Count countries in each Status
SELECT Status, COUNT(DISTINCT Country) AS Country_Count,
       ROUND(AVG(`Life expectancy`), 1) AS Avg_Exp
FROM world_life_expectancy
GROUP BY Status;


/* 
   3.4 Health Indicators
*/

-- BMI vs Life Expectancy
SELECT Country,
       ROUND(AVG(`Life expectancy`), 1) AS Life_Exp,
       ROUND(AVG(BMI), 1) AS Avg_BMI
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0 AND Avg_BMI > 0
ORDER BY Avg_BMI DESC;

-- Rolling total of Adult Mortality for selected countries
SELECT Country, Year, `Adult Mortality`,
       SUM(`Adult Mortality`) OVER (PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM world_life_expectancy
WHERE Country LIKE '%United%';


/* ============================================================================================
   4. KEY INSIGHTS
   ============================================================================================
   - Global Progress: Life expectancy has steadily increased worldwide over the years.
   - Wealth & Health: Higher GDP nations consistently achieve longer life spans.
   - Status Gap: Developed countries show higher averages than developing ones. 
		(Note: the data was skewed for developing countries)
   - Health Factors: BMI and Adult Mortality strongly correlate with life expectancy.
   ============================================================================================
*/
