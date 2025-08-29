CREATE DATABASE DataP;

USE DataP;

-- importing dataset

SELECT * FROM layoffs;

-- create another table similar to our raw data so that we always have original data incase something goes wrong

CREATE TABLE `layoffs1` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM layoffs1;

-- insert our raw data into the newly created table

INSERT INTO layoffs1 SELECT * FROM layoffs;

SELECT * FROM layoffs1;

-- 1. REMOVE DUPLICATES

SELECT *, 
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) 
AS Row_num FROM layoffs1;

CREATE TABLE layoffs2 LIKE layoffs;

SELECT * FROM layoffs2;

ALTER TABLE layoffs2 ADD COLUMN row_num INT;

INSERT INTO layoffs2 
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) 
AS Row_num FROM layoffs1;

SELECT * FROM layoffs2;

-- Now lets find the duplicates

SELECT * FROM layoffs2 WHERE Row_num > 1;

-- There are 5 duplicate values

DELETE FROM layoffs2
WHERE row_num>1;

SELECT * FROM layoffs2 WHERE Row_num > 1;

-- we are now done with dealing with duplicate values

-- 2. Standartizing Data

SELECT * FROM layoffs2;
SELECT distinct company FROM layoffs2 ORDER BY 1;

-- we can see multiple rows with spaces at front we will fix that
UPDATE layoffs2 SET company = TRIM(company);

SELECT distinct Location FROM layoffs2 ORDER BY 1;
SELECT distinct industry FROM layoffs2 ORDER BY 1;

-- we can see multiple distinct names of crypto in industry lets try to fix that
SELECT * from layoffs2 WHERE industry LIKE "Crypto%";
-- only 3 rows are with the name Crypto Currency out of 102 rows which might a same as Crypto so we change the rest to Crypto as well
UPDATE layoffs2 SET industry = 'Crypto' Where industry LIKE "Crypto%";
-- now lets check again
SELECT distinct industry FROM layoffs2 ORDER BY 1;
-- now this looks good

SELECT DISTINCT country FROM layoffs2 ORDER BY 1;

-- Notice there are 2 United States one with . at the end lets fix that now
SELECT * from layoffs2 WHERE country LIKE "United States.%";
-- we can see fours rows with United States.
UPDATE layoffs2 SET country = 'United States' WHERE country LIKE "United States%";
SELECT DISTINCT country FROM layoffs2 ORDER BY 1;
-- Now we are done with country coulmn

SELECT * FROM layoffs2;

-- Lets Fix the data column Its is in STR Format

SELECT `date`
, STR_TO_DATE(`date`, '%m/%d/%Y') AS `Date` FROM layoffs2;
-- This looks good lets Update the table
UPDATE layoffs2 SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
SELECT `date` FROM layoffs2;
-- Now lets change the datetype
ALTER TABLE layoffs2 MODIFY COLUMN `date` DATE;


-- 3. WORKING WITH NULL AND BLANK VALUES

SELECT * FROM layoffs2;
SELECT * FROM layoffs2 WHERE total_laid_off IS NULL;
SELECT * FROM layoffs2 WHERE percentage_laid_off IS NULL;
SELECT * FROM layoffs2 WHERE percentage_laid_off IS NULL AND total_laid_off IS NULL;

-- SINCE BOTH percentage laid off and total laid off is null we will drop these rows since we cannout use then and cannot be filled
-- since we dont have any data that can be used to fill these 2 rows

DELETE FROM layoffs2
WHERE percentage_laid_off IS NULL AND total_laid_off IS NULL;

SELECT * FROM layoffs2 WHERE percentage_laid_off IS NULL AND total_laid_off IS NULL;

SELECT * FROM layoffs2 WHERE company IS NULL OR company = ''; -- NO NULLS OR BLANKS
SELECT * FROM layoffs2 WHERE industry IS NULL OR industry =''; -- NULL & BLANK VALUES FOUND
SELECT * FROM layoffs2 WHERE country IS NULL OR country =''; -- NO NULLS

-- LETS TRY TO FILL THE NULL & BLANKS IN INDUSTRY FIRST
SELECT * FROM layoffs2 WHERE industry IS NULL OR industry ='';
-- WE WILL TRY TO FIND ANY OTHER ROWS WITH SAME COMPANY AND LOCATION NAMES AS THE ONES WE FOUND AND TRY TO FILL THEM WITH SIMILAR DATA
SELECT * FROM layoffs2 WHERE company = 'Airbnb' AND location = 'SF Bay Area'; -- FOUND SIMILAR ROW
-- INSTEAD OF THE ABOVE APPROCH WE WILL USE SELF JOINS
SELECT * FROM layoffs2 t1
JOIN layoffs2 t2 ON
t1.company = t2.company AND t1.location = t2.location
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;
-- THERE WAS NO OUTPUT SINCE WE ALSO HAD BLANKS LETS CONVERT THE BLANKS INTO NULLS FOR EASIER PROGRESS
UPDATE layoffs2 SET industry = NULL WHERE industry = '';
-- NOW LETS TRY AGAIN
SELECT * 
FROM layoffs2 t1
JOIN layoffs2 t2 
	ON t1.company = t2.company AND t1.location = t2.location
	WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;
-- NOW THIS RUNS WE GOT 3 RESULTS
-- LETS FILL THE NULLS
SELECT t1.industry, t2.industry 
FROM layoffs2 t1
JOIN layoffs2 t2 
	ON t1.company = t2.company AND t1.location = t2.location
	WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;

UPDATE layoffs2 t1
JOIN layoffs2 t2 
	ON t1.company = t2.company AND t1.location = t2.location
    SET t1.industry = t2.industry
	WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;

-- LETS RECHECK
SELECT t1.industry, t2.industry 
FROM layoffs2 t1
JOIN layoffs2 t2 
	ON t1.company = t2.company AND t1.location = t2.location
	WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;

-- NO NULLS 
-- NOW WE ARE DONE WITH WORKING WITH NULLS

-- NOW LETS REMOVE ANY EXTRA COLUMNS OR ROWS WE DONT NEED

SELECT * FROM layoffs2;

ALTER table layoffs2 DROP COLUMN row_num;

SELECT * FROM layoffs2;

-- THIS IS OUR CLEANED DATA


-- FROM HERE WE WILL CONTINUE WITH EDA(EXPLORATORY DATA ANALYSIS)







