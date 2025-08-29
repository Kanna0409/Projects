-- CREATE DATABASE DataP

-- USE DataP

-- importing dataset

-- SELECT * FROM layoffs

-- create another table similar to our raw data so that we always have original data incase something goes wrong

-- CREATE TABLE `layoffs1` (
--   `company` text,
--   `location` text,
--   `industry` text,
--   `total_laid_off` int DEFAULT NULL,
--   `percentage_laid_off` text,
--   `date` text,
--   `stage` text,
--   `country` text,
--   `funds_raised_millions` int DEFAULT NULL
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- SELECT * FROM layoffs1

-- insert our raw data into the newly created table

-- INSERT INTO layoffs1 SELECT * FROM layoffs

-- select * from layoffs1

-- 1. REMOVE DUPLICATES

-- SELECT *, 
-- ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) 
-- AS Row_num FROM layoffs1;

-- CREATE TABLE layoffs2 LIKE layoffs;

-- SELECT * FROM layoffs2;

-- ALTER TABLE layoffs2 ADD COLUMN row_num INT;

-- INSERT INTO layoffs2 
-- SELECT *, 
-- ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) 
-- AS Row_num FROM layoffs1;

-- SELECT * FROM layoffs2;

-- Now lets find the duplicates

-- SELECT * FROM layoffs2 WHERE Row_num > 1;

-- There are 5 duplicate values

-- DELETE FROM layoffs2
-- WHERE row_num>1;

-- SELECT * FROM layoffs2 WHERE Row_num > 1;

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






