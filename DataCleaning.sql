-- DATA CLEANING 

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null values or Blank values
-- 4. Remove unnecessary columns

-- Don't work on the raw file
-- Best practice is to create a staging table that you will work on
-- This is done incase you make a mistake, you will still have your raw data intact

CREATE TABLE layoffs_staging
LIKE layoffs;

-- The table you just created is empty, you only brought in the columns

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

-- REMOVE DUPLICATES


-- Removing duplicates from the table
-- The row_number assigns a unique number to each row within a group
-- The over() tells SQL how to group rows before numbering them
-- You have to partition by all the rows, because for a duplicate to happen >1 row must have the same values
-- If row_num = 1, that is the first occurence
-- If row_num > 1, that means there are duplicates


SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- Now we want to return just the duplicates using a CTE

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- Checking to see if it worked

SELECT *
FROM layoffs_staging
WHERE company = 'Oracle';

-- Now we need to delete the duplicates
-- Because we can't delete off of a CTE, we need to create a new table with the row_num in it

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;


-- STANDARDIZING DATA


-- The company column has white spaces, so we need to do a TRIM

UPDATE layoffs_staging2
SET company = TRIM(company);

-- In the industry column, we have multiple crypto spellings 
-- So we need to group it into one spelling 

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT industry
FROM layoffs_staging2;

-- In the country column there's a mispell with united states

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Now we will be updating the date format

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT `date`
FROM layoffs_staging2;

-- The date will be converted from string to date

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- Back to the industry column
-- There is a blank and null spaces

SELECT DISTINCT industry
FROM layoffs_staging2;

-- This is showing the companies that have NULL or blank industry
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

-- Because of the above query, we are checking to see how many times the companies occured in out table
-- Since each of the distinct companies that showed up have the same distinct location as well
-- The next step is to populate the blank and NULL industries with values of their counterpart
-- The only exception is Bally's interactive because it only occurred once

SELECT *
FROM layoffs_staging2
WHERE company IN ("Airbnb","Bally's Interactive","Carvana","Juul");

-- In order to populate the missing values in the industry column
-- We will turn every blank column in industry to NULL

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

 -- POPULATE
UPDATE layoffs_staging2 AS t1
JOIN layoffs_staging2 AS t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

-- Check if it worked
SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb';


-- We are going to be deleting total_laid_off and percentage_laid_off 
-- Where both are NULL

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Check if it worked
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- We don't need row_num column anymore as well

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- Check if it worked

SELECT *
FROM layoffs_staging2


