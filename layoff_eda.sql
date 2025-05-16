-- Explanatory Data Analysis

select * from layoffs_staging2;

select max(total_laid_off),max(percentage_laid_off)
from layoffs_staging2;

-- entire company layoff as layoff percent=1
select * from layoffs_staging2
where percentage_laid_off = 1 
order by total_laid_off desc;

-- total layoffs by a company 
select company,sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

-- most layoffs according to industry
select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

-- total companies across countries
select country, count(company)
from layoffs_staging2
group by country
order by 2 desc limit 30 ;

select * from layoffs_staging2 where country = 'Poland';

-- total layoff according to countries
select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

-- layoff by year
select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc;


select year(`date`), sum(percentage_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc;

-- total layoff accoring to month and year
select substring(`date`,1,7) as `month`, sum(total_laid_off) as lay_off from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month` 
order by `month`;

-- rolling total acc to month and year
with layoff as 
(
select substring(`date`,1,7) as `month`, sum(total_laid_off) as lay_off from layoffs_staging2
where substring(`date`,1,7) is not null
group by `month` 
order by `month`
)
select `month`,lay_off,	sum(lay_off) over(order by `month`) as rolling_total from layoff;



select company,year(`date`),sum(total_laid_off) from layoffs_staging2 group by company,year(`date`) order by 3 desc;


-- total layoff acc to company in which year
with company_layoff (company,`year`,layoff)as 
(
select company,year(`date`),sum(total_laid_off) 
from layoffs_staging2 
group by company,year(`date`) 
order by 3 desc
),
company_year_rank as(
select *,dense_rank() over(partition by `year` order by layoff desc) as ranking 
from company_layoff
where `year` is not null
)
select * from company_year_rank
where ranking <= 5;
