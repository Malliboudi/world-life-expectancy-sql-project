-- =====================================================
-- WORLD LIFE EXPECTANCY DATA CLEANING
-- =====================================================
-- Objective:
-- Clean the dataset by removing duplicate records,
-- standardizing categorical values, and handling
-- missing data.
-- =====================================================


-- =====================================================
-- Inspect the Dataset
-- =====================================================

SELECT *
FROM world_life_expectancy;


-- =====================================================
-- Check for Duplicate Records
-- =====================================================

SELECT country, year, CONCAT(country, year), COUNT(CONCAT(country, year))
FROM world_life_expectancy
GROUP BY country, year
HAVING COUNT(CONCAT(country, year)) > 1;


-- =====================================================
-- Identify Duplicate Rows
-- =====================================================

SELECT *
FROM (
    SELECT row_id,
           CONCAT(country, year),
           ROW_NUMBER() OVER(
               PARTITION BY CONCAT(country, year)
               ORDER BY CONCAT(country, year)
           ) AS row_num
    FROM world_life_expectancy
) AS row_table
WHERE row_num > 1;


-- =====================================================
-- Remove Duplicate Rows
-- =====================================================

DELETE FROM world_life_expectancy
WHERE row_ID IN (
    SELECT row_id
    FROM (
        SELECT row_id,
               CONCAT(country, year),
               ROW_NUMBER() OVER(
                   PARTITION BY CONCAT(country, year)
                   ORDER BY CONCAT(country, year)
               ) AS row_num
        FROM world_life_expectancy
    ) AS row_table
    WHERE row_num > 1
);


-- =====================================================
-- Validate Duplicate Removal
-- =====================================================

SELECT country, year, CONCAT(country, year), COUNT(CONCAT(country, year))
FROM world_life_expectancy
GROUP BY country, year
HAVING COUNT(CONCAT(country, year)) > 1;


-- =====================================================
-- Identify Missing Status Values
-- =====================================================

SELECT *
FROM world_life_expectancy
WHERE status = '';


-- =====================================================
-- Review Existing Status Values
-- =====================================================

SELECT DISTINCT(status)
FROM world_life_expectancy
WHERE status <> '';


SELECT DISTINCT(country)
FROM world_life_expectancy
WHERE status = 'Developing';


-- =====================================================
-- Standardize Status Values
-- =====================================================

UPDATE world_life_expectancy
SET status = 'DEVELOPING'
WHERE country IN (
    SELECT DISTINCT(country)
    FROM world_life_expectancy
    WHERE status = 'Developing'
);


-- =====================================================
-- Populate Missing Status Values
-- =====================================================

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
    ON t1.country = t2.country
SET t1.status = 'Developing'
WHERE t1.status = ''
AND t2.status <> ''
AND t2.status = 'Developing';


SELECT country, status
FROM world_life_expectancy
WHERE status = '';


SELECT country, status
FROM world_life_expectancy
WHERE country = 'United States of America';


UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
    ON t1.country = t2.country
SET t1.status = 'Developed'
WHERE t1.status = ''
AND t2.status <> ''
AND t2.status = 'Developed';


-- =====================================================
-- Validate Status Cleaning
-- =====================================================

SELECT *
FROM world_life_expectancy
WHERE status = '';


-- =====================================================
-- Identify Missing Life Expectancy Values
-- =====================================================

SELECT *
FROM world_life_expectancy
WHERE `Life expectancy` = '';


-- =====================================================
-- Preview Estimated Life Expectancy Values
-- Missing values are replaced using the average of
-- the previous and following year's value.
-- =====================================================

SELECT
    t1.Country,
    t1.Year,
    t1.`Life expectancy`,
    t2.Country,
    t2.Year,
    t2.`Life expectancy`,
    t3.Country,
    t3.Year,
    t3.`Life expectancy`,
    ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2, 1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
    ON t1.country = t2.country
    AND t1.year = t2.year - 1
JOIN world_life_expectancy t3
    ON t1.country = t3.country
    AND t1.year = t3.year + 1
WHERE t1.`Life expectancy` = '';


-- =====================================================
-- Update Missing Life Expectancy Values
-- =====================================================

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
    ON t1.country = t2.country
    AND t1.year = t2.year - 1
JOIN world_life_expectancy t3
    ON t1.country = t3.country
    AND t1.year = t3.year + 1
SET t1.`Life expectancy` =
ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2, 1)
WHERE t1.`Life expectancy` = '';


-- =====================================================
-- Validate Missing Life Expectancy Values
-- =====================================================

SELECT *
FROM world_life_expectancy
WHERE `Life expectancy` = '';



-- =====================================================
-- WORLD LIFE EXPECTANCY EXPLORATORY DATA ANALYSIS
-- =====================================================
-- Objective:
-- Explore trends, relationships, and patterns in
-- life expectancy across countries.
-- =====================================================


-- =====================================================
-- Question 1:
-- Which countries experienced the greatest increase
-- in life expectancy over the dataset period?
-- =====================================================

SELECT
    country,
    MIN(`Life expectancy`),
    MAX(`Life expectancy`),
    ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`), 1)
        AS life_increase_in_15_years
FROM world_life_expectancy
GROUP BY country
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
ORDER BY life_increase_in_15_years DESC;


-- =====================================================
-- Question 2:
-- How has global average life expectancy changed
-- over time?
-- =====================================================

SELECT
    Year,
    ROUND(AVG(`Life expectancy`), 2)
FROM world_life_expectancy
WHERE `Life expectancy` <> 0
GROUP BY Year
ORDER BY Year;


-- =====================================================
-- Question 3:
-- What is the relationship between GDP and
-- life expectancy?
-- =====================================================

SELECT
    country,
    ROUND(AVG(`Life expectancy`), 1) AS life_exp,
    ROUND(AVG(GDP), 1) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING life_exp > 0
AND GDP > 0
ORDER BY GDP ASC;


-- =====================================================
-- Question 4:
-- Compare average life expectancy between
-- high GDP and low GDP countries.
-- =====================================================

SELECT
    SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) AS High_GDP_count,
    ROUND(AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END),1)
        AS High_GDP_Life_expectancy,
    SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) AS Low_GDP_count,
    ROUND(AVG(CASE WHEN GDP <= 1500 THEN `Life expectancy` ELSE NULL END),1)
        AS Low_GDP_Life_expectancy
FROM world_life_expectancy;


-- =====================================================
-- Question 5:
-- How does life expectancy differ between
-- Developed and Developing countries?
-- =====================================================

SELECT
    status,
    ROUND(AVG(`Life expectancy`),1)
FROM world_life_expectancy
GROUP BY status;


SELECT
    status,
    COUNT(DISTINCT country),
    ROUND(AVG(`Life expectancy`),1)
FROM world_life_expectancy
GROUP BY status;


-- =====================================================
-- Question 6:
-- Is there a relationship between BMI and
-- life expectancy?
-- =====================================================

SELECT
    country,
    ROUND(AVG(`Life expectancy`),1) AS life_exp,
    ROUND(AVG(BMI),1) AS BMI
FROM world_life_expectancy
GROUP BY Country
HAVING life_exp > 0
AND BMI > 0
ORDER BY BMI DESC;


-- =====================================================
-- Question 7:
-- Adult Mortality Trends by Country
-- =====================================================

SELECT
    country,
    year,
    `Life expectancy`,
    `Adult mortality`,
    SUM(`Adult mortality`)
    OVER(
        PARTITION BY country
        ORDER BY Year
    ) AS rolling_total
FROM world_life_expectancy;

-- =====================================================
-- Question 8:
-- Life Expactancy Improvement
-- =====================================================

SELECT
    Country,
    MIN(`Life expectancy`) AS Start,
    MAX(`Life expectancy`) AS End,
    ROUND(MAX(`Life expectancy`)-
          MIN(`Life expectancy`),1) AS Improvement
FROM world_life_expectancy
GROUP BY Country
HAVING Improvement > 0
ORDER BY Improvement DESC
LIMIT 10;
