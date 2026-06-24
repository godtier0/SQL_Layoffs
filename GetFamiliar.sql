SELECT *
FROM employee_demographics;


SELECT *
FROM employee_demographics
LIMIT 5;

SELECT *
FROM employee_demographics
WHERE birth_date > '1994-01-01';


# -- AND OR NOT -- Logical Operators

SELECT *
FROM employee_demographics
WHERE age > 40
AND gender = 'male';


SELECT *
FROM employee_demographics
WHERE age > 40
OR gender = 'male';


-- LIKE Statment --

-- This returns a table with the first name starting with 'Do' --
SELECT *
FROM employee_demographics
WHERE first_name LIKE 'Do%';

-- This returns a table where the first name has the letter 'a' in it --
SELECT *
FROM employee_demographics
WHERE first_name LIKE '%a%';


-- This returns a table where the first name must end i 'dy' --
SELECT *
FROM employee_demographics
WHERE first_name LIKE '%dy';


-- the result must return first name that starts with "A"
-- and because there 2 unsderscores after the "A"alter
-- the rest of the characters must be two letters
SELECT *
FROM employee_demographics
WHERE first_name LIKE 'A__';


-- GROUP BY --
-- This groups the result based on specified column --

SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender;

SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender;


-- ORDER BY --
-- When you use ORDER BY, automatically it orders in an ascending manner

SELECT *
FROM employee_demographics
ORDER BY first_name;

-- 	Be careful to use to right column to order by first
-- If age came before gender, the gender column will not make sense
-- It prioritizes the first column

SELECT *
FROM employee_demographics
ORDER BY gender, age DESC;


-- Differnce between HAVING & WHERE
-- HAVING was created to filter after a GROUP BY
-- WHERE can't filter an aggregated column

SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender
HAVING AVG(age) > 40;


SELECT occupation, AVG(salary)
FROM employee_salary
WHERE occupation LIKE '%manager%'
GROUP BY occupation
HAVING AVG(salary) > 75000;


-- LIMIT & Aliasing

-- This returns the first 3 oldest employees
SELECT *
FROM employee_demographics
ORDER BY age DESC
LIMIT 3;

-- This will return the 3rd oldest employee
-- 2 = start looking from the 2nd row 
-- 1 = return the first employee after the 2nd row

SELECT *
FROM employee_demographics
ORDER BY age DESC
LIMIT 2, 1;

-- Aliasing 

SELECT gender, AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender
HAVING avg_age > 40;


-- JOINS

-- INNER JOIN is the same as JOIN
-- When doing as INNER JOIN, both tables need to have at least one similar column to join on
-- it will bring in the rows that have same values in both columns that we are tying on
SELECT *
FROM employee_demographics AS A
	INNER JOIN employee_salary AS B
		ON A.employee_id = B.employee_id;


-- OUTER JOIN
-- This will return the left table and everything that matches it from the right table

SELECT *
FROM employee_demographics AS A
	LEFT JOIN employee_salary AS B
		ON A.employee_id = B.employee_id;
   
-- This will return the right table and everything that matches it from the left table

SELECT *
FROM employee_demographics AS A
	RIGHT JOIN employee_salary AS B
		ON A.employee_id = B.employee_id;


-- SELF JOIN
-- This is a join where you tie a table to its self
-- This returns employee who will be santa to another employee

SELECT
emp1.employee_id AS santa_id,
emp1.first_name AS santa_first,
emp1.last_name AS santa_last,
emp2.employee_id AS recv_id,
emp2.first_name AS recv_first,
emp2.last_name AS recv_last
FROM employee_salary AS emp1
	JOIN employee_salary AS emp2
		ON emp1.employee_id + 1 = emp2.employee_id;


-- Joining on multiple tables

SELECT *
FROM employee_demographics AS A
	INNER JOIN employee_salary AS B
		ON A.employee_id = B.employee_id
	INNER JOIN parks_departments AS pd
		ON B.dept_id = pd.department_id;
        
        
-- UNION
 
-- This returns distinct values from both tables
SELECT first_name, last_name
FROM employee_demographics
UNION
SELECT first_name, last_name
FROM employee_salary;

-- This returns all values including duplicates
SELECT first_name, last_name
FROM employee_demographics
UNION ALL
SELECT first_name, last_name
FROM employee_salary;


-- USE CASE
-- The company wants to push out all old and highly paid employees

SELECT first_name, last_name, 'Old Man' AS Label
	FROM employee_demographics
		WHERE age > 40 AND gender = 'Male'
UNION
	SELECT first_name, last_name, 'Old Woman' AS Label
		FROM employee_demographics
			WHERE age > 40 AND gender = 'Female'
UNION
	SELECT first_name, last_name, 'Highly paid employee' AS Label
		FROM employee_salary
			WHERE salary > 70000
				ORDER BY first_name, last_name;
                
                
                
-- String Functions
-- LENGTH, in a real life use case it can be used to check if phone numbers have the right amount of digits

SELECT first_name, LENGTH(first_name)
FROM employee_demographics
ORDER BY 2;

-- You can use either UPPER() or LOWER()
SELECT first_name, UPPER(first_name)
FROM employee_demographics;


-- TRIM This trims white spaces
-- LTRIM trims white spaces on the left
-- RTRIM trims white spaces in the right 

SELECT TRIM('    Skyline    ');

-- This will print the first four letters of the first_name

SELECT first_name,
LEFT(first_name, 4)
FROM employee_demographics;


-- This will print the last four letters from the right starting from the last letter

SELECT first_name,
RIGHT(first_name, 4)
FROM employee_demographics;

-- The will return two letters of the first_name starting from the 3rd letter

SELECT first_name,
SUBSTRING(first_name,3,2)
FROM employee_demographics;

SELECT first_name,
	SUBSTRING(birth_date,6,2) AS birth_month
    FROM employee_demographics;
    
-- REPLACE

SELECT first_name, REPLACE(first_name, 'a','z')
FROM employee_demographics;

-- LOCATE

SELECT LOCATE('a','Sunkanmi');

-- CONCAT
-- This joins two columns into one

SELECT first_name, last_name,
CONCAT(first_name, ' ', last_name) AS full_name
FROM employee_demographics;


-- CASE Statement

SELECT first_name, last_name, age,
	CASE 
		WHEN age <= 30 THEN 'Young'
        WHEN age BETWEEN 31 AND 50 THEN 'Old'
			ELSE 'Senior Citizen'
				END AS age_category
FROM employee_demographics;

-- Pay increase
-- < 50000 = 5$
-- > 50000 = 7%
-- Finance = 10% bonus

SELECT *,
	CASE
		WHEN salary < 50000 THEN salary + (salary * 0.05)
		WHEN salary > 50000 THEN salary + (salary * 0.07)
		END AS New_salary,
	CASE
		WHEN dept_id = 6 THEN salary * 0.10
        END AS Bonus
FROM employee_salary;


-- SUBQUERIES
-- A query within a query
-- This query returns employees with dept_id of 1
-- Since we don't have dept_id in the demographis table
-- We had to reference it from the salary table

SELECT *
FROM employee_demographics
WHERE employee_id IN 
					(SELECT employee_id
						FROM employee_salary
							WHERE dept_id = 1);


-- We can alaso use it to check for the average salary of the entire table

SELECT first_name, salary,
	(SELECT AVG(salary)
	FROM employee_salary)
		AS avg_salary
FROM employee_salary;


-- This will return the average of the maximum age of the entire table
SELECT AVG(max_age)
FROM
-- This on its own will return the avg, max, min, count of both gender separately
(SELECT gender,
AVG(age) AS avg_age,
	MAX(age) AS max_age,
		MIN(age) AS min_age,
			COUNT(age) AS count_age
FROM employee_demographics
GROUP BY gender) AS Agg_table;
-- In this case the subquery is named as a table



-- WINDOW Functions

-- I prefer this GROUP BY
SELECT gender, AVG(salary)
FROM employee_demographics AS dem
	JOIN employee_salary AS sal
		ON dem.employee_id = sal.employee_id
GROUP BY gender;

SELECT gender, AVG(salary) OVER(PARTITION BY gender)
FROM employee_demographics AS dem
	JOIN employee_salary AS sal
		ON dem.employee_id = sal.employee_id;
        
 -- Rolling Total       
-- This is done by the gender

SELECT dem.first_name, dem.last_name, gender, salary,
	SUM(salary) OVER(PARTITION BY gender
		ORDER BY dem.employee_id) AS rolling_total
FROM employee_demographics AS dem
	JOIN employee_salary AS sal
		ON dem.employee_id = sal.employee_id;
        
-- ROW_NUMBER & RANK
-- The ROW_NUMBER & RANK number alike, 
-- But we can see that when RANK encountered a duplicate in what it was ordered by, salary
-- It numbered the duplicates with the same number and went on to 7
-- This is because RANK numbers positionally and not numerically
-- DENSE_RANK does the opposite of RANK

SELECT dem.first_name, dem.last_name, gender, salary,
	ROW_NUMBER() OVER(PARTITION BY gender
		ORDER BY salary DESC) AS row_num,
			RANK() OVER(PARTITION BY gender
				ORDER BY salary DESC) AS rank_num,
					DENSE_RANK() OVER(PARTITION BY gender
						ORDER BY salary DESC) AS dense_rank_num
FROM employee_demographics AS dem
	JOIN employee_salary AS sal
		ON dem.employee_id = sal.employee_id;
        
        
-- CTE
-- This is useful when you want to do more complex query OR
-- Can't perform in one single query
-- You can only use a CTE immediately you create it 

WITH CTE_Example AS
(
SELECT gender, 
AVG(salary) AS avg_sal,
MAX(salary) AS max_sal,
MIN(salary) AS min_sal,
COUNT(salary) AS count_sal
FROM employee_demographics AS dem
	JOIN 	employee_salary AS sal
		ON dem.employee_id = sal.employee_id
			GROUP BY gender
)
SELECT AVG(avg_sal)
FROM CTE_Example;

-- You can have multiple CTE together

WITH CTE_Example AS
(
SELECT employee_id, gender, birth_date
FROM employee_demographics
WHERE birth_date > '1985-01-01'
),
CTE_Example2 AS
(
SELECT employee_id, salary
FROM employee_salary
WHERE salary > 50000
)
SELECT *
FROM CTE_Example
JOIN CTE_Example2
	ON CTE_Example.employee_id = CTE_Example2.employee_id;
    
    
-- Temp Tables
-- Temp tables are only valid within the session it was created

CREATE TEMPORARY TABLE temp_table
(first_name varchar(50),
last_name varchar(50),
favorite_movie varchar(100),
duration_hrs int(2)
);

SELECT *
FROM temp_table;

INSERT INTO temp_table
VALUES ('Fatai','Yusuf','2 Guns',2);

-- Creating table based of an existing table

CREATE TEMPORARY TABLE salary_over_50k
SELECT *
FROM employee_salary
WHERE salary >= 50000;

SELECT *
FROM salary_over_50k;


-- STORED PROCEDURE
-- A stored procedure is a prepared collection of SQL statements, 
-- that is saved directly inside the database server so it can be reused multiple times. 
-- If you have multiple database, to specify the db you want to store it in, use below
-- USE name_of_database
-- It comes before the CREATE statement


CREATE PROCEDURE Large_Salaries()
SELECT *
FROM employee_salary
WHERE salary >= 50000;

-- How to use the stored procedure that was stored in the db

CALL Large_Salaries();

-- The query we have above is not something we'd create a stored procedure for because it is too simple
-- Below is a proper use case of a stored procedure
-- ; is a DELIMITER, so we had to specify a new new DELIMITER $$
-- If we don't do that, the STORED PRODURE will store the first query only
-- Because it will assume the query ended immediately after the first ;
-- After that is sorted, we then need to re-introduce our old DELIMITER
-- Which is the last line


DELIMITER $$
CREATE PROCEDURE Large_Salaries2()
BEGIN
	SELECT *
    FROM employee_salary
	WHERE salary >= 50000;
    SELECT *
    FROM employee_salary
	WHERE salary >= 10000;
END $$
DELIMITER ;

CALL Large_Salaries2();

-- Here we are giving the stored an option of finding a specific employee
-- emp_id = parameter name, which is already equated to employee_id in the employee_salary table

DELIMITER $$
CREATE PROCEDURE GetEmployee(IN emp_id INT)
BEGIN
	SELECT *
    FROM employee_salary
    WHERE employee_id = emp_id;
END $$
DELIMITER ;

-- Now i can feed the STORED PROCEDURE any employee ID
-- It will return information about that employee
CALL GetEmployee(3)



-- TRIGGERS
-- In the employee_salary table we have Ron's information in there 
-- But his info isn't present in the employee_demographics table
-- No we want to write a query that whenever the salary table is updated
-- It will also reflect in the demographics table
-- This particular trigger will be stored under triggers in the salary table


DELIMITER $$
CREATE TRIGGER employee_insert -- name of the trigger
	AFTER INSERT ON employee_salary -- anytime there's anew input in the salary table
    FOR EACH ROW -- for every new row inserted
BEGIN
	INSERT INTO employee_demographics (employee_id,first_name,last_name) -- put it into these columns in the demographics table
    VALUES (NEW.employee_id, NEW.first_name, NEW.last_name); -- the new values from the salary table
END $$
DELIMITER ;

-- Lets give it a try

INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES (13, 'Olatomi', 'Yusuf', 'CEO', 1000000, NULL);

SELECT *
FROM employee_salary;

SELECT *
FROM employee_demographics;


-- EVENTS
-- This query below checks our demographics table every month
-- To check employees that are 60 and over in order to retire them

DELIMITER $$
CREATE EVENT delete_retirees
ON SCHEDULE EVERY 1 MONTH
DO
BEGIN
	DELETE
    FROM employee_demographics
    WHERE age >= 60;
END $$
DELIMITER ;

SELECT *
FROM employee_demographics