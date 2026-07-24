-- =====================================================
-- HR EMPLOYEE ATTRITION ANALYSIS
-- SQL PORTFOLIO PROJECT
-- Author: Nkirote Makandi
-- Tool: MySQL Workbench
-- =====================================================

-- =====================================================
-- 1. DATA EXPLORATION
-- =====================================================
SELECT *
FROM `hr employee attrition`
LIMIT 10;
USE hr_analytics;
SELECT COUNT(*) AS total_employees
FROM `hr employee attrition`;
SELECT DISTINCT Department
FROM `hr employee attrition`;
SELECT
    Department,
    COUNT(*) AS total_employees
FROM `hr employee attrition`
GROUP BY Department
ORDER BY total_employees DESC;
SELECT
    Attrition,
    COUNT(*) AS total_employees
FROM `hr employee attrition`
GROUP BY Attrition;
SELECT
    Department,
    Attrition,
    COUNT(*) AS total_employees
FROM `hr employee attrition`
GROUP BY Department, Attrition
ORDER BY Department, Attrition;
SELECT
    Department,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS attrition_rate_percentage
FROM `hr employee attrition`
GROUP BY Department
ORDER BY attrition_rate_percentage DESC;
SELECT
    OverTime,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS attrition_rate_percentage
FROM `hr employee attrition`
GROUP BY OverTime
ORDER BY attrition_rate_percentage DESC;
SELECT
    Department,
    OverTime,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS attrition_rate_percentage
FROM `hr employee attrition`
GROUP BY Department, OverTime
ORDER BY Department, attrition_rate_percentage DESC;
SELECT
    JobRole,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS attrition_rate_percentage
FROM `hr employee attrition`
GROUP BY JobRole
ORDER BY attrition_rate_percentage DESC;
SELECT
    EmployeeNumber,
    JobRole,
    Department,
    MonthlyIncome
FROM `hr employee attrition`
WHERE MonthlyIncome >
(
    SELECT AVG(MonthlyIncome)
    FROM `hr employee attrition`
)
ORDER BY MonthlyIncome DESC;
SELECT
    JobRole,
    COUNT(*) AS total_employees
FROM `hr employee attrition`
GROUP BY JobRole
HAVING COUNT(*) > 100
ORDER BY total_employees DESC;
SELECT
    Attrition,
    ROUND(AVG(MonthlyIncome), 2) AS average_monthly_income
FROM `hr employee attrition`
GROUP BY Attrition;
SELECT
    CASE
        WHEN MonthlyIncome < 5000 THEN 'Low Income'
        WHEN MonthlyIncome BETWEEN 5000 AND 10000 THEN 'Medium Income'
        ELSE 'High Income'
    END AS income_group,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS attrition_rate_percentage
FROM `hr employee attrition`
GROUP BY income_group
ORDER BY attrition_rate_percentage DESC;

-- =====================================================
-- 2. DATA CLEANING
-- =====================================================
DESCRIBE `hr employee attrition`;
ALTER TABLE `hr employee attrition`
CHANGE COLUMN `ï»¿Age` Age INT;
DESCRIBE `hr employee attrition`;
SELECT
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS missing_age,
    SUM(CASE WHEN Department IS NULL THEN 1 ELSE 0 END) AS missing_department,
    SUM(CASE WHEN JobRole IS NULL THEN 1 ELSE 0 END) AS missing_job_role,
    SUM(CASE WHEN MonthlyIncome IS NULL THEN 1 ELSE 0 END) AS missing_monthly_income,
    SUM(CASE WHEN Attrition IS NULL THEN 1 ELSE 0 END) AS missing_attrition;
   

SELECT
    EmployeeNumber,
    COUNT(*) AS duplicate_count
FROM `hr employee attrition`
GROUP BY EmployeeNumber
HAVING COUNT(*) > 1;

-- =====================================================
-- 3. STRING FUNCTIONS
-- =====================================================
SELECT
    Department,
    UPPER(Department) AS department_uppercase
FROM `hr employee attrition`;
SELECT
    Department,
    LOWER(Department) AS department_lowercase
FROM `hr employee attrition`;
SELECT
    JobRole,
    LENGTH(JobRole) AS character_count
FROM `hr employee attrition`
ORDER BY character_count DESC;
SELECT
    Department,
    LEFT(Department, 3) AS abbreviation
FROM `hr employee attrition`;
SELECT
    Department,
    RIGHT(Department, 3) AS last_three_characters
FROM `hr employee attrition`;
SELECT
    TRIM('   Sales   ') AS cleaned_text;
    SELECT
    EmployeeNumber,
    CONCAT(JobRole, ' - ', Department) AS employee_position
FROM `hr employee attrition`;
SELECT
    JobRole,
    SUBSTRING(JobRole, 1, 5) AS first_five_letters
FROM `hr employee attrition`;
SELECT
    Department,
    REPLACE(Department, 'Research', 'R&D') AS shortened_department
FROM `hr employee attrition`;
SELECT
    JobRole,
    LOCATE('Manager', JobRole) AS position_of_manager
FROM `hr employee attrition`;

-- =====================================================
-- 3. VIEWS
-- =====================================================
CREATE VIEW department_attrition_summary AS
SELECT
    Department,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS attrition_rate_percentage
FROM `hr employee attrition`
GROUP BY Department;
SELECT *
FROM department_attrition_summary;

-- =====================================================
-- 4. COMMON TABLE EXPRESSIONS (CTEs)
-- =====================================================
WITH department_rates AS (
    SELECT
        Department,
        COUNT(*) AS total_employees,
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
        ROUND(
            SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
            2
        ) AS attrition_rate_percentage
    FROM `hr employee attrition`
    GROUP BY Department
)

SELECT *
FROM department_rates
WHERE attrition_rate_percentage >
(
    SELECT AVG(attrition_rate_percentage)
    FROM department_rates
);

-- =====================================================
-- 5. WINDOW FUNCTIONS
-- =====================================================
SELECT
    EmployeeNumber,
    JobRole,
    Department,
    MonthlyIncome,
    ROW_NUMBER() OVER(
        ORDER BY MonthlyIncome DESC
    ) AS salary_rank
FROM `hr employee attrition`;
SELECT
    EmployeeNumber,
    Department,
    JobRole,
    MonthlyIncome,
    ROW_NUMBER() OVER(
        PARTITION BY Department
        ORDER BY MonthlyIncome DESC
    ) AS department_salary_rank
FROM `hr employee attrition`;
SELECT
    EmployeeNumber,
    Department,
    JobRole,
    MonthlyIncome,
    RANK() OVER(
        PARTITION BY Department
        ORDER BY MonthlyIncome DESC
    ) AS income_rank
FROM `hr employee attrition`;
SELECT
    EmployeeNumber,
    Department,
    JobRole,
    MonthlyIncome,
    DENSE_RANK() OVER(
        PARTITION BY Department
        ORDER BY MonthlyIncome DESC
    ) AS dense_income_rank
FROM `hr employee attrition`;
SELECT
    EmployeeNumber,
    Department,
    JobRole,
    MonthlyIncome,
    LAG(MonthlyIncome) OVER(
        ORDER BY MonthlyIncome DESC
    ) AS previous_income
FROM `hr employee attrition`;
SELECT
    EmployeeNumber,
    Department,
    JobRole,
    MonthlyIncome,
    LEAD(MonthlyIncome) OVER(
        ORDER BY MonthlyIncome DESC
    ) AS next_income
FROM `hr employee attrition`;
SELECT
    EmployeeNumber,
    Department,
    JobRole,
    MonthlyIncome,
    LAG(MonthlyIncome) OVER(
        ORDER BY MonthlyIncome DESC
    ) AS previous_income,
    LAG(MonthlyIncome) OVER(
        ORDER BY MonthlyIncome DESC
    ) - MonthlyIncome AS income_difference
FROM `hr employee attrition`;