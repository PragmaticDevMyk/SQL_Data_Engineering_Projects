SELECT LENGTH('SQL');

SELECT CHAR_LENGTH('SQL');

SELECT LOWER('SQL');

SELECT UPPER('sql');

SELECT LEFT('SQL', 2);

SELECT RIGHT('SQL', 2);

SELECT SUBSTRING('SQL', 2, 2);

SELECT SUBSTRING('SQL', 2, 1);


-- CONCATENATION
SELECT CONCAT('SQL', '-', 'Functions');

SELECT 'SQL' || '-' || 'Functions';


--TRIMMING
SELECT TRIM(' SQL ');
SELECT RTRIM(' SQL ');
SELECT LTRIM(' SQL ');


--REPLACEMENT
SELECT REPLACE('SQL', 'Q', '-');

SELECT REGEXP_REPLACE('SQL', '[A-Z]+', 'sql');

--Cleaup this using Text Functions
SELECT
    job_title,
    CASE
        WHEN job_title LIKE '%Data%' AND job_title LIKE '%Analyst%' THEN 'Data Analyst'
        WHEN job_title LIKE '%Data%' AND job_title LIKE '%Engineer%' THEN 'Data Engineer'
        WHEN job_title LIKE '%Data%' AND job_title LIKE '%Scientist%' THEN 'Data Scientist'
        ELSE 'Other'
    END AS job_title_category,
    job_title_short
FROM job_postings_fact
ORDER BY RANDOM()
LIMIT 20;

-- Formatted
WITH title_lower AS (
    SELECT job_title,
        LOWER(TRIM(job_title)) AS job_title_clean,
        job_title_short
    FROM
        job_postings_fact
)
SELECT
    job_title,
    CASE
        WHEN job_title_clean LIKE '%data%' AND job_title_clean LIKE '%analyst%' THEN 'Data Analyst'
        WHEN job_title_clean LIKE '%data%' AND job_title_clean LIKE '%analyst%' THEN 'Data Analyst'
        WHEN job_title_clean LIKE '%data%' AND job_title_clean LIKE '%engineer%' THEN 'Data Engineer'
        WHEN job_title_clean LIKE '%data%' AND job_title_clean LIKE '%scientist%' THEN 'Data Scientist'
        ELSE 'Other'
    END AS job_title_category,
    job_title_short
FROM title_lower
ORDER BY RANDOM()
LIMIT 30;


--NULLIF

SELECT NULLIF(10, 20);
SELECT NULLIF(5 + 5, 20);


SELECT COALESCE(0, 1, 2);

SELECT COALESCE(NULL, NULL, 2);


SELECT
    salary_year_avg,
    salary_hour_avg,
    COALESCE(salary_year_avg, salary_hour_avg * 2000) AS yearly_salary,
    COALESCE(salary_hour_avg, salary_year_avg / 2000) AS monthly_salary
FROM
    job_postings_fact
WHERE salary_year_avg IS NOT NULL OR salary_hour_avg IS NOT NULL
LIMIT 20;


-- Final Example - Simplify with Coalesce
WITH salaries AS (
    SELECT
        job_title_short,
        salary_year_avg,
        salary_hour_avg,
        CASE
            WHEN salary_year_avg IS NOT NULL THEN salary_year_avg
            WHEN salary_hour_avg IS NOT NULL THEN salary_hour_avg * 2000
            ELSE NULL
        END AS standardized_salary
    FROM
        job_postings_fact
)
SELECT
    job_title_short,
    salary_year_avg,
    salary_hour_avg,
    standardized_salary,
    CASE
        WHEN standardized_salary IS NULL THEN 'Missing'
        WHEN standardized_salary < 75000 THEN 'Low'
        WHEN standardized_salary < 150000 THEN 'Mid'
        ELSE 'High'
    END AS salary_bucket
FROM salaries
ORDER BY standardized_salary DESC;


--ANSWER

SELECT
    job_title_short,
    salary_year_avg,
    salary_hour_avg,
    COALESCE(salary_year_avg, salary_hour_avg * 2000) AS standardized_salary,
    CASE
        WHEN COALESCE(salary_year_avg, salary_hour_avg * 2000) IS NULL THEN 'Missing'
        WHEN COALESCE(salary_year_avg, salary_hour_avg * 2000) < 75000 THEN 'Low'
        WHEN COALESCE(salary_year_avg, salary_hour_avg * 2000) < 150000 THEN 'Mid'
        ELSE 'High'
    END AS salary_bucket
FROM job_postings_fact
ORDER BY standardized_salary DESC;





