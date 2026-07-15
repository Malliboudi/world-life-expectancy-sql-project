# World Life Expectancy SQL Project

## Project Overview

This project focuses on cleaning and analyzing a world life expectancy dataset using SQL.

The goal of this project was to improve data quality by removing duplicates, handling missing values, standardizing data, and then performing exploratory data analysis to identify trends and relationships affecting life expectancy across countries.

---

## Tools Used

- MySQL
- MySQL Workbench
- Excel / CSV Dataset

---

# Data Cleaning

The dataset was cleaned using SQL techniques including:

- Identifying and removing duplicate records using window functions
- Standardizing inconsistent values in categorical columns
- Filling missing status values using self joins
- Handling missing life expectancy values using neighboring year averages
- Validating the results after cleaning

---

# Exploratory Data Analysis

After cleaning the dataset, I explored several questions:

### 1. Which countries experienced the largest improvement in life expectancy?

Analyzed the difference between minimum and maximum life expectancy values for each country.

### 2. How has global life expectancy changed over time?

Examined yearly average life expectancy trends.

### 3. Is there a relationship between GDP and life expectancy?

Compared average GDP and life expectancy across countries.

### 4. Do developed countries have higher life expectancy than developing countries?

Compared average life expectancy between country development statuses.

### 5. Is BMI associated with life expectancy?

Explored relationships between BMI and average life expectancy.

### 6. Which countries have shown the greatest improvements?

Identified countries with the largest increases in life expectancy over the dataset period.

---

# Key SQL Skills Demonstrated

- Data Cleaning
- Data Validation
- SQL Joins
- Window Functions
- Aggregate Functions
- CASE Statements
- Subqueries
- Exploratory Data Analysis

---

# Key Findings

- Global life expectancy increased over the period analyzed.
- Developed countries generally had higher average life expectancy compared to developing countries.
- Countries with higher GDP tended to have higher life expectancy.
- Several countries experienced significant improvements in life expectancy over time.

---

# Files Included

```
world_life_expectancy_project.sql
WorldLifeExpectancy.xlsx
README.md
```

---

## Conclusion

This project demonstrates the process of taking a raw dataset, cleaning it using SQL, and performing exploratory analysis to uncover meaningful insights.
