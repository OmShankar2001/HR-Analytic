-- Create the database and switch to it
CREATE DATABASE projects;
USE projects;

-- View all data in the 'hr' table
SELECT * FROM hr;

-- Update column name from special characters to 'emp_id'
ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

-- Describe the structure of the 'hr' table
DESCRIBE hr;

-- Select only birthdate column to inspect data
SELECT birthdate FROM hr;

-- Allow unsafe updates for the session
SET sql_safe_updates = 0;

-- Clean and standardize birthdate format to YYYY-MM-DD
UPDATE hr
SET birthdate = CASE
    WHEN birthdate LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

-- Change the datatype of 'birthdate' to DATE
ALTER TABLE hr 
MODIFY COLUMN birthdate DATE;

-- Clean and standardize hire_date format to YYYY-MM-DD
UPDATE hr
SET hire_date = CASE
    WHEN hire_date LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

-- Change the datatype of 'hire_date' to DATE
ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

-- Clean and standardize termdate format, handle invalid and blank values
UPDATE hr
SET termdate = IF(termdate IS NOT NULL AND termdate != '', DATE(STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
WHERE TRUE;

-- Allow invalid dates temporarily for 'termdate'
SET sql_mode = 'ALLOW_INVALID_DATES';

-- Change the datatype of 'termdate' to DATE
ALTER TABLE hr
MODIFY COLUMN termdate DATE;

-- Add an 'age' column to the 'hr' table
ALTER TABLE hr ADD COLUMN age INT;

-- Calculate and populate 'age' column using birthdate and current date
UPDATE hr
SET age = TIMESTAMPDIFF(YEAR, birthdate, CURDATE());

-- Determine the youngest and oldest employees
SELECT 
    MIN(age) AS youngest, 
    MAX(age) AS oldest
FROM hr;

-- Count employees below 18 years of age
SELECT COUNT(*) 
FROM hr
WHERE age < 18;

-- ========================
-- ANALYSIS QUESTIONS
-- ========================

-- 1. Gender breakdown of employees in the company
SELECT gender, COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00' -- Only consider active employees aged 18 or older
GROUP BY gender;

-- 2. Race/ethnicity breakdown of employees in the company
SELECT race, COUNT(race) AS count_of_race
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY race
ORDER BY count_of_race DESC;

-- 3. Age distribution of employees
SELECT 
    MIN(age) AS youngest,
    MAX(age) AS oldest
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00';

-- Age group distribution
SELECT 
    CASE
        WHEN age BETWEEN 18 AND 24 THEN '18-24'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        WHEN age BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+'
    END AS age_group,
    COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY age_group
ORDER BY age_group;

-- Age group distribution by gender
SELECT 
    CASE
        WHEN age BETWEEN 18 AND 24 THEN '18-24'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        WHEN age BETWEEN 55 AND 64 THEN '55-64'
        ELSE '65+'
    END AS age_group, 
    gender,
    COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- 4. Employee count by location (headquarters vs remote)
SELECT location, COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY location;

-- 5. Average length of employment for terminated employees
SELECT 
    ROUND(AVG(DATEDIFF(termdate, hire_date)) / 365, 0) AS average_length_of_employment
FROM hr
WHERE termdate <= CURDATE() AND termdate <> '0000-00-00' AND age >= 18;

-- 6. Gender distribution across departments and job titles
SELECT department, gender, COUNT(*) AS count 
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY department, gender
ORDER BY department;

-- 7. Distribution of job titles across the company
SELECT jobtitle, COUNT(*) AS count
FROM hr
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- 8. Department with the highest turnover rate
SELECT 
    department,
    total_count,
    terminated_count,
    terminated_count / total_count AS termination_rate 
FROM (
    SELECT 
        department,
        COUNT(*) AS total_count, 
        SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminated_count
    FROM hr 
    WHERE age >= 18 
    GROUP BY department
) AS subquery
ORDER BY termination_rate DESC;

-- 9. Employee distribution by location (city and state)
SELECT location_state, COUNT(emp_id) AS count
FROM hr
WHERE termdate <= CURDATE() AND termdate <> '0000-00-00' AND age >= 18
GROUP BY location_state
ORDER BY count DESC;

-- 10. Employee count change over time (based on hire and term dates)
SELECT 
    year,
    hires,
    terminations,
    hires - terminations AS net_change,
    ROUND((hires - terminations) / hires * 100, 2) AS net_change_percent
FROM (
    SELECT 
        YEAR(hire_date) AS year,
        COUNT(*) AS hires,
        SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminations
    FROM hr 
    WHERE age >= 18
    GROUP BY YEAR(hire_date)
) AS subquery
ORDER BY year ASC;

-- 11. Tenure distribution by department
SELECT department, ROUND(AVG(DATEDIFF(termdate, hire_date) / 365), 0) AS avg_tenure
FROM hr
WHERE termdate <= CURDATE() AND termdate <> '0000-00-00' AND age >= 18
GROUP BY department;
