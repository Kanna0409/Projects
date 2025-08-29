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



