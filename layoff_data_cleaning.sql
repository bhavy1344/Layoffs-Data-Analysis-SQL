SELECT *
FROM layoffs;

-- 1. remove duplicates
-- 2. standarize the data
-- 3. handle null values and blank rows
-- 4. remove unnecessary columns

-- Create a same table like layoffs 
CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT INTO layoffs_staging
SELECT * FROM layoffs;

SELECT * FROM layoffs_staging;

SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,industry,total_laid_off,percentage_laid_off,`date`) as row_num
FROM layoffs_staging;

WITH duplicate_cte as
( 
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
FROM layoffs_staging
)

SELECT * 
FROM duplicate_cte 
where row_num>1;

SELECT * 
from layoffs_staging 
where company='casper';

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
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

Insert into layoffs_staging2 
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
FROM layoffs_staging;

select * 
from layoffs_staging2;

Delete 
from layoffs_staging2 
where row_num >1;

select * 
from layoffs_staging2 
where row_num>1;

-- 2. standarizing the data

select company, trim(company) 
from layoffs_staging2;

update layoffs_staging2 
set company=trim(company);

select company 
from layoffs_staging2;

select distinct industry 
from layoffs_staging2 
order by industry;

update layoffs_staging2 
set industry = 'Crypto' 
where industry like 'Crypto%';

select distinct industry 
from layoffs_staging2 
order by industry;

select distinct country from layoffs_staging2 order by 1;

update layoffs_staging2 
set country = 'United States' 
where country like 'United States%';

select distinct country from layoffs_staging2 order by 1;

select `date`, 
STR_TO_DATE(`date`, '%m/%d/%Y') as `date`
from layoffs_staging2;

update layoffs_staging2 
set `date` =  STR_TO_DATE(`date`, '%m/%d/%Y');

alter table layoffs_staging2 
modify column `date` date;

select * from layoffs_staging2;


-- 3. handling the null values

select * from layoffs_staging2 
where industry is null or industry = '';
-- convert blank values to null as updating blank values will not affect the rows
update layoffs_staging2 
set industry = null where industry = '';

select * from layoffs_staging2 t1 
join layoffs_staging2 t2 
on t1.company = t2.company and t1.location = t2.location 
where t1.industry is null or t1.industry = '' and t2.industry is not null;

update layoffs_staging2 t1 
join layoffs_staging2 t2 
on t1.company = t2.company 
set t1.industry = t2.industry
where t1.industry is null and t2.industry is not null; 

select * from layoffs_staging2 
where total_laid_off is null and percentage_laid_off is null;

delete from layoffs_staging2 where total_laid_off is null and percentage_laid_off is null;
 
--  4. dropping the row number

alter table layoffs_staging2 drop column row_num;
select * from layoffs_staging2;
