# HR Dashboard Analysis with MySQL and PowerBI

![HR Dashboard Visualization](https://user-images.githubusercontent.com/56026296/229609893-b7b1f261-5941-45af-8322-1ccb2535d36b.png)

## Overview

This project analyzes HR data spanning 20 years (2000–2020) to uncover insights into workforce demographics, employment trends, and turnover rates. The cleaned and analyzed data is visualized using PowerBI to answer key business questions and provide actionable insights.

---

## Data

- **Source**: HR Data (22,000+ rows)
- **Timeframe**: 2000–2020
- **Tools Used**:
  - **Data Cleaning & Analysis**: MySQL Workbench
  - **Data Visualization**: PowerBI

---

## Key Questions Answered

1. What is the gender breakdown of employees in the company?
2. What is the race/ethnicity breakdown of employees in the company?
3. What is the age distribution of employees in the company?
4. How many employees work at headquarters versus remote locations?
5. What is the average length of employment for employees who have been terminated?
6. How does the gender distribution vary across departments and job titles?
7. What is the distribution of job titles across the company?
8. Which department has the highest turnover rate?
9. What is the distribution of employees across locations by state?
10. How has the company's employee count changed over time based on hire and term dates?
11. What is the tenure distribution for each department?

---

## Summary of Findings

- **Gender Breakdown**: Predominantly male employees.
- **Race/Ethnicity**: The majority are White, with Native Hawaiian and American Indian being the least represented groups.
- **Age Distribution**:
  - Youngest: 20 years old
  - Oldest: 57 years old
  - Majority Age Groups: 25–34 and 35–44
- **Employment Location**: More employees are at headquarters than remote locations.
- **Length of Employment**: Average tenure of terminated employees is ~7 years.
- **Departmental Insights**:
  - Gender distribution is balanced across departments but slightly male-dominant.
  - Marketing has the highest turnover rate, followed by Training. Research, Support, and Legal have the lowest turnover rates.
- **Geographic Insights**: Ohio has the largest number of employees.
- **Trends Over Time**: Net employee count has increased over the years.
- **Tenure by Department**:
  - Average tenure is ~8 years.
  - Highest Tenure: Legal and Auditing
  - Lowest Tenure: Services, Sales, and Marketing

---

## Limitations

1. **Data Quality**: 
   - Negative ages (967 records) were excluded.
   - Only ages 18+ were included.
2. **Future Termination Dates**:
   - Term dates in the future (1599 records) were excluded.
   - Only term dates ≤ current date were analyzed.

---

