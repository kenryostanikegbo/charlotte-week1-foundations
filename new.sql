
CREATE DATABASE IF NOT EXISTS Hr;
CREATE DATABASE IF NOT EXISTS Assets;
CREATE DATABASE IF NOT EXISTS Production;

-- Drop child tables before parent tables so foreign keys do not block the reset.
DROP TABLE IF EXISTS Production.daily_production;
DROP TABLE IF EXISTS Hr.employees;
DROP TABLE IF EXISTS Assets.rigs;
DROP TABLE IF EXISTS Hr.Departments;

CREATE TABLE Hr.Departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);

CREATE TABLE Hr.employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(120) UNIQUE,
    hire_date DATE,
    job_title VARCHAR(100),
    salary DECIMAL(12,2),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Hr.Departments(dept_id)
);

CREATE TABLE Assets.rigs (
    rig_id INT PRIMARY KEY AUTO_INCREMENT,
    rig_name VARCHAR(100) NOT NULL,
    region VARCHAR(100),
    rig_type VARCHAR(50),
    water_depth_m DECIMAL(10,2),
    commission_date DATE,
    status VARCHAR(30)
);

CREATE TABLE Production.daily_production (
    prod_id INT PRIMARY KEY AUTO_INCREMENT,
    rig_id INT NOT NULL,
    prod_date DATE NOT NULL,
    barrels_oil DECIMAL(12,2),
    gas_mcf DECIMAL(12,2),
    uptime_hours DECIMAL(5,2),
    FOREIGN KEY (rig_id) REFERENCES Assets.rigs(rig_id)
);

-- Insert departments
INSERT INTO Hr.Departments (dept_name, location) VALUES
('Human Resources', 'Lagos'),
('Data and Analytics', 'Lagos'),
('Engineering', 'Port Harcourt'),
('Administration', 'Lagos'),
('Operations', 'Warri'),
('Finance', 'Lagos');

-- Insert employees. Department IDs correspond to the department insertion order above.
INSERT INTO Hr.employees
(first_name, last_name, email, hire_date, job_title, salary, dept_id) VALUES
('Amina', 'Yusuf', 'amina.yusuf8@example.com', '2022-03-14', 'HR Officer', 280000, 1),
('Daniel', 'Okafor', 'daniel.okafor10@example.com', '2021-08-09', 'Data Analyst', 42000, 2),
('Fatima', 'Bello', 'fatima.bello11@example.com', '2023-01-16', 'Data Instructor', 350000, 2),
('Ibrahim', 'Musa', 'ibrahim.musa5@example.com', '2020-06-22', 'Embedded Systems Engineer', 50000, 3),
('Chinedu', 'Eze', 'chinedu.eze6@example.com', '2019-11-04', 'Operations Engineer', 550000, 5),
('Grace', 'John', 'grace.john19@example.com', '2024-02-12', 'Finance Officer', 330000, 6);

-- Insert rigs. After the clean reset above, these rig IDs will be 1 through 5.
INSERT INTO Assets.rigs
(rig_name, region, rig_type, water_depth_m, commission_date, status) VALUES
('niger star 01', 'offshore niger delta', 'jack-up', 85.00, '2018-05-20', 'active'),
('niger star 02', 'offshore niger delta', 'semi-submersible', 420.00, '2020-06-15', 'active'),
('delta explorer', 'niger delta', 'jack-up', 70.00, '2016-03-10', 'maintenance'),
('atlantic pioneer', 'offshore niger delta', 'drillship', 1500.00, '2022-03-12', 'active'),
('bonny deep 01', 'bonny', 'semi-submersible', 650.00, '2019-11-18', 'inactive');


INSERT INTO Production.daily_production
(rig_id, prod_date, barrels_oil, gas_mcf, uptime_hours) VALUES
(1, '2026-10-01', 12500, 18400, 23.2),
(1, '2026-10-02', 12850, 18950, 23.7),
(1, '2026-10-03', 12100, 17600, 22.5),
(2, '2026-10-01', 18500, 26500, 24.0),
(2, '2026-10-02', 19000, 27100, 23.8),
(2, '2026-10-03', 18750, 26900, 23.9),
(3, '2026-10-01', 0, 0, 8.0),
(4, '2026-10-02', 25000, 36000, 24.0),
(4, '2026-10-03', 25500, 36500, 24.0),
(4, '2026-10-04', 24800, 35800, 24.5);

-- BASIC SELECT QUERIES
SELECT rig_id FROM Assets.rigs;
SELECT rig_id FROM Assets.rigs ORDER BY rig_id;
SELECT * FROM Assets.rigs;
SELECT rig_name, region, status FROM Assets.rigs;
SELECT * FROM Assets.rigs WHERE status = 'active';
SELECT * FROM Assets.rigs WHERE region = 'offshore niger delta';
SELECT first_name, last_name, salary FROM Hr.employees ORDER BY salary DESC;
SELECT * FROM Assets.rigs LIMIT 3;
SELECT * FROM Production.daily_production WHERE barrels_oil > 10000;

-- AGGREGATE QUERIES
SELECT
    COUNT(employee_id) AS total_employees,
    SUM(salary) AS total_salary,
    AVG(salary) AS average_salary,
    MIN(salary) AS lowest_salary,
    MAX(salary) AS highest_salary
FROM Hr.employees;

SELECT COUNT(*) AS total_employees FROM Hr.employees;
SELECT SUM(barrels_oil) AS total_oil FROM Production.daily_production;
SELECT AVG(salary) AS average_salary FROM Hr.employees;
SELECT MIN(water_depth_m) AS shallowest_rig FROM Assets.rigs;
SELECT MAX(water_depth_m) AS deepest_rig FROM Assets.rigs;

-- GROUP BY: total oil produced by each rig
SELECT rig_id, SUM(barrels_oil) AS total_oil
FROM Production.daily_production
GROUP BY rig_id
ORDER BY rig_id;

-- JOIN: production rows with rig details
SELECT
    r.rig_name,
    r.region,
    p.prod_date,
    p.barrels_oil
FROM Assets.rigs AS r
JOIN Production.daily_production AS p
    ON r.rig_id = p.rig_id
ORDER BY r.rig_id, p.prod_date;

-- Assignement 1.
-- use WHERE to display the rigs whose Staus is active.
SELECT rig_id, rig_name, region, status
FROM Assets.rigs
WHERE status = 'active';

-- Use ORDER bt arrangement of employees from the highest salary to the lowest.
SELECT first_name, last_name, salary
FROM Hr.employees
ORDER BY salary DESC;

-- Use the aggregate function COUNT() to calculate the total number of employees.
SELECT COUNT(*) AS total_employees
FROM Hr.employees;

-- Use JOIN to combine the rigs table with the daily production table.
SELECT
    r.rig_name,
    p.prod_date,
    p.barrels_oil
FROM Assets.rigs AS r
JOIN Production.daily_production AS p
    ON r.rig_id = p.rig_id
ORDER BY p.prod_date, r.rig_name;

-- Use SUM() and GROUP BY to calculate total oil production for each rig.
SELECT
    rig_id,
    SUM(barrels_oil) AS total_oil
FROM Production.daily_production
GROUP BY rig_id
ORDER BY rig_id;

-- Assignment 02.
-- BQ1: Offshore rigs active in 2023, counted by region.
SELECT
    region,
    COUNT(*) AS active_rig_count
FROM Assets.rigs
WHERE status = 'active'
  AND LOWER(region) LIKE '%offshore%'
GROUP BY region
ORDER BY region;

-- BQ2: Total oil and gas per region in 2023.
SELECT
    r.region,
    SUM(p.barrels_oil) AS total_oil_barrels,
    SUM(p.gas_mcf) AS total_gas_mcf
FROM Assets.rigs AS r
JOIN Production.daily_production AS p
    ON r.rig_id = p.rig_id
WHERE p.prod_date >= '2023-01-01'
  AND p.prod_date < '2024-01-01'
GROUP BY r.region
ORDER BY r.region;
-- Expected output: No rows, because the supplied production data contains no records from 2023.

-- BQ3: Top five rigs by average daily barrels in 2023.
SELECT
    r.rig_id,
    r.rig_name,
    AVG(p.barrels_oil) AS average_daily_barrels
FROM Assets.rigs AS r
JOIN Production.daily_production AS p
    ON r.rig_id = p.rig_id
WHERE p.prod_date >= '2023-01-01'
  AND p.prod_date < '2024-01-01'
GROUP BY r.rig_id, r.rig_name
ORDER BY average_daily_barrels DESC
LIMIT 5;
-- Expected output: No rows with the supplied data, because no production records are dated in 2023.

-- BQ4: Rigs under 90% uptime in any month (HAVING)
SELECT
    r.rig_id,
    r.rig_name,
    YEAR(p.prod_date) AS prod_year,
    MONTH(p.prod_date) AS prod_month,
    100.0 * SUM(p.uptime_hours)
        / SUM(p.available_hours) AS uptime_pct
FROM Assets.rigs AS r
JOIN Production.daily_production AS p
    ON r.rig_id = p.rig_id
GROUP BY
    r.rig_id,
    r.rig_name,
    YEAR(p.prod_date),
    MONTH(p.prod_date)
HAVING uptime_pct < 90;
-- Expected output: This query cannot run against your current schema because available_hours does not exist. You need to add that column or provide another agreed method for calculating uptime.

-- BQ5: Hires per year.
SELECT
    YEAR(hire_date) AS hire_year,
    COUNT(*) AS hires
FROM Hr.employees
WHERE hire_date IS NOT NULL
GROUP BY YEAR(hire_date)
ORDER BY hire_year;

-- BQ6: Best production day ever.
SELECT
    prod_date,
    SUM(barrels_oil) AS total_oil_barrels
FROM Production.daily_production
GROUP BY prod_date
ORDER BY total_oil_barrels DESC
LIMIT 1;

-- BQ7: Number of rigs per status.
SELECT
    status,
    COUNT(*) AS rig_count
FROM Assets.rigs
GROUP BY status
ORDER BY status;

-- BQ8: Salary per job title.
SELECT
    job_title,
    COUNT(*) AS employee_count,
    AVG(salary) AS average_salary
FROM Hr.employees
GROUP BY job_title
ORDER BY job_title;

-- BQ9: Find missing gas data.
SELECT
    prod_id,
    rig_id,
    prod_date,
    gas_mcf
FROM Production.daily_production
WHERE gas_mcf IS NULL;

-- BQ10: Top 10 company production days.
SELECT
    prod_date,
    SUM(barrels_oil) AS total_oil_barrels
FROM Production.daily_production
GROUP BY prod_date
ORDER BY total_oil_barrels DESC
LIMIT 10;

-- Assignment 03.
-- i, Display every employee.
SELECT *
FROM Hr.employees;

-- ii, Display employee first name, last name, and job title.
SELECT
    first_name,
    last_name,
    job_title
FROM Hr.employees;

-- iii,Find employees earning more than 400,000.
SELECT
    first_name,
    last_name,
    job_title,
    salary
FROM Hr.employees
WHERE salary > 400000;

-- iv, Display employees from the Data & Analytics department using JOIN.
SELECT
    e.first_name,
    e.last_name,
    e.job_title,
    d.dept_name
FROM Hr.employees AS e
JOIN Hr.Departments AS d
    ON e.dept_id = d.dept_id
WHERE d.dept_name = 'Data and Analytics';

-- v, Display all active rigs.
SELECT *
FROM Assets.rigs
WHERE status = 'active';

-- vi, Find rigs with water depth greater than 100 metres.
SELECT
    rig_id,
    rig_name,
    water_depth_m
FROM Assets.rigs
WHERE water_depth_m > 100
ORDER BY water_depth_m DESC;

-- vii, Display production records for rig ID 1.
SELECT
    prod_id,
    rig_id,
    prod_date,
    barrels_oil,
    gas_mcf,
    uptime_hours
FROM Production.daily_production
WHERE rig_id = 1
ORDER BY prod_date;
 
 -- viii,Find total barrels of oil produced by each rig.
 SELECT
    r.rig_id,
    r.rig_name,
    SUM(p.barrels_oil) AS total_oil_barrels
FROM Assets.rigs AS r
JOIN Production.daily_production AS p
    ON r.rig_id = p.rig_id
GROUP BY r.rig_id, r.rig_name
ORDER BY r.rig_id;

-- xi, Find average daily oil production for each rig.
SELECT
    r.rig_id,
    r.rig_name,
    AVG(p.barrels_oil) AS average_daily_barrels
FROM Assets.rigs AS r
JOIN Production.daily_production AS p
    ON r.rig_id = p.rig_id
GROUP BY r.rig_id, r.rig_name
ORDER BY r.rig_id;

-- x,Find the rig with the deepest water depth.
SELECT
    rig_id,
    rig_name,
    water_depth_m
FROM Assets.rigs
ORDER BY water_depth_m DESC
LIMIT 1;

-- xi, Display rig name, production date, and barrels of oil using JOIN.
SELECT
    r.rig_name,
    p.prod_date,
    p.barrels_oil
FROM Assets.rigs AS r
JOIN Production.daily_production AS p
    ON r.rig_id = p.rig_id
ORDER BY p.prod_date, r.rig_id;

-- xii, Sort daily production from highest to lowest oil production.
SELECT
    prod_id,
    rig_id,
    prod_date,
    barrels_oil
FROM Production.daily_production
ORDER BY barrels_oil DESC;

-- inner Employee with thier department
select e.first_name, e.last_name, d.dept_name
from Hr.employees e
Inner join Hr.departments d on e.dept_id = d.dept_id;

-- left + Coalesce: every rig with 2023 production, 0 if none
select r.rig_name, coalesce(sum(p.barrels_oil),1) as bbl_2023
from Assets.rigs r
LEft join production.daily_production p
on p.rig_id = r.rig_id
and p.prod_date between '2023-01-01' and '2023-12-31' -- filter inside on!
group by r.rig_name order by bbl_2023 desc;

-- where on the right table would silently turn left into inner
-- full outer: find orphan rows on either side
SELECT r.*
FROM Assets.rigs AS r
LEFT JOIN Production.daily_production AS p
    ON p.rig_id = r.rig_id
WHERE p.rig_id IS NULL;
-- Expected result: Rig ID 5 (bonny deep 01) appears because it has no production records.
 