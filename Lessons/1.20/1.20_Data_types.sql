SELECT table_name,
    column_name,
    data_type
 FROM
    information_schema.columns
WHERE
    table_name = 'job_postings_fact';

DESCRIBE job_postings_fact;

DESCRIBE
SELECT
    job_title_short,
    job_location
FROM
    job_postings_fact;

SELECT CAST(123 AS VARCHAR);


SELECT CAST('123DEF' AS INTEGER);

SELECT 
    CAST(job_id AS VARCHAR) || '-' || --"more" unique identifier
    CAST(company_id AS VARCHAR) AS job_company_id,
    CAST(job_work_from_home AS INT) job_work_from_home, --from boolean to numeric value
    CAST(job_posted_date AS DATE) job_posted_date, -- from timestamp to date only
    CAST(salary_year_avg AS DECIMAL(10, 0)) salary_year_avg -- from double to no decimal place
FROM 
    job_postings_fact
WHERE 
    salary_year_avg IS NOT NULL
LIMIT 10;