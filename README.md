# 💼 Global Layoff Trend Analysis using SQL

This project involves cleaning and analyzing global layoff data using SQL. The goal was to prepare raw layoff data for meaningful insights through standard data cleaning techniques followed by exploratory data analysis (EDA).


## 📌 Project Highlights

- ✅ **Data Cleaning**  
  - Removed duplicates using `ROW_NUMBER()` and Common Table Expressions (CTEs)  
  - Standardized textual fields (e.g., country, industry, company) using SQL functions  
  - Converted inconsistent date formats and handled missing/null values  
  - Removed unnecessary columns to optimize the dataset  

- ✅ **Exploratory Data Analysis (EDA)**  
  - Analyzed layoff trends by year, country, company, and industry  
  - Calculated total layoffs, peak periods, and full-company shutdowns  
  - Generated rolling total trends using window functions  
  - Ranked top 5 companies with most layoffs by year using `DENSE_RANK()`  


