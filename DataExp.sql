-- Exploratory Data Analysis

SELECT * 
FROM layoffs_staging2;


-- 1. Range of layoff date

SELECT MIN(date), MAX(date)
FROM layoffs_staging2;


-- 2. The highest number and percentage layoff
-- 1 = 100%

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;


-- 3. Largest Single Layoff Event

SELECT company, total_laid_off
FROM layoffs_staging2
ORDER BY total_laid_off DESC
LIMIT 1;

-- 4. Companies with 100% lay offs

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;


-- 5. Total sum of layoff per company

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;


-- 6. Total sum of layoff per industry

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
WHERE industry <> 'Other'
GROUP BY industry
ORDER BY 2 DESC
LIMIT 10;


-- 7. Total layoff per country

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC
LIMIT 10;


-- 8. Total layoff per year

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
WHERE YEAR(`date`) IS NOT NULL
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;


-- 9. Total layoff by stage

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;


-- 10. Total layoff by year/month

SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 2 DESC;


-- 11. Rolling total layoff by year/month
-- Without OVER(), SUM() would only return one total for the entire table
-- ORDER BY = This instructs the window function to look at your data chronologically

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;


-- 12. Top Companies each year

-- 1st CTE Calculates total layoffs for each company in each year
-- 2nd CTE Ranks companies within each year from highest layoffs to lowest
-- And resets the ranking when the year changes.
-- PARTITION BY splits the table based on unique values in the years column
-- Final query returns only companies ranked 1–5 in their respective year

WITH Company_year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_year_rank AS
(SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_year_rank
WHERE Ranking <= 5;


-- 13. Funding vs Layoffs
-- Did heavily funded companies still lay people off

SELECT company,
       funds_raised_millions,
       total_laid_off
FROM layoffs_staging2
WHERE total_laid_off IS NOT NULL
ORDER BY funds_raised_millions DESC;


-- 14. Companies with miultiple layoff events

SELECT company,
       COUNT(*) AS layoff_events
FROM layoffs_staging2
GROUP BY company
HAVING COUNT(*) > 1
ORDER BY layoff_events DESC;


-- 15. First layoff record for every company

WITH ranked_companies AS
(
    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY company
               ORDER BY date
           ) AS rn
    FROM layoffs_staging2
)
SELECT *
FROM ranked_companies
WHERE rn = 1;


-- 16. Exec KPI 
SELECT
    COUNT(DISTINCT company) AS companies_affected,
    SUM(total_laid_off) AS total_layoffs,
    AVG(total_laid_off) AS avg_layoff_size,
    COUNT(DISTINCT country) AS countries_affected
FROM layoffs_staging2;


SELECT funds_raised_millions, total_laid_off
FROM layoffs_staging2
WHERE funds_raised_millions IS NOT NULL
AND total_laid_off IS NOT NULL
ORDER BY funds_raised_millions DESC
















