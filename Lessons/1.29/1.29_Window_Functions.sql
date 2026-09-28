-- COUNT Rows - Aggregate Functions
SELECT
    COUNT(*)
FROM
    job_postings_fact;


--Count Rows - Window Functions
SELECT 
    job_id,
    COUNT(*) OVER ()
FROM
    job_postings_fact;


--PARTITION BY - Find hourly salary
SELECT 
    job_id,
    job_title_short,
    company_id,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER(PARTITION BY job_title_short, company_id)
FROM
    job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL
ORDER BY 
    RANDOM()
LIMIT 20;


--ORDER BY - Ranking hourly salary
SELECT 
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER(ORDER BY salary_hour_avg DESC) AS rank_hourly_salary
FROM
    job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL
ORDER BY 
    salary_hour_avg DESC
LIMIT 20;


--PARTITION BY & ORDER BY -- Running Average Hourly Salary
SELECT 
    job_posted_date,
    job_title_short,
    salary_hour_avg,
    AVG(salary_hour_avg) OVER(
        PARTITION BY job_title_short
        ORDER BY job_posted_date
    ) AS running_avg_hour_by_title
FROM
    job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL
ORDER BY 
    job_title_short,
    job_posted_date
LIMIT 20;




SELECT 
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER(
        PARTITION BY job_title_short
        ORDER BY salary_hour_avg DESC) AS rank_hourly_salary
FROM
    job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL
ORDER BY 
    salary_hour_avg DESC,
    job_title_short
LIMIT 20;


--AGGREGATE FUNCTIONS
    --SUM
    --AVG
    --MIN
    --MAX
    --COUNT

--RANK ROW FUNCTIONS
    --RANK
    --DENSE_RANK
    --ROW_NUMBER
    --PERCENT_RANK
    --NTILE


SELECT 
    job_id,
    job_title_short,
    salary_hour_avg,
    RANK() OVER(ORDER BY salary_hour_avg DESC) AS rank_hourly_salary
FROM
    job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL
ORDER BY 
    salary_hour_avg DESC
LIMIT 140;


SELECT 
    job_id,
    job_title_short,
    salary_hour_avg,
    DENSE_RANK() OVER(ORDER BY salary_hour_avg DESC) AS rank_hourly_salary
FROM
    job_postings_fact
WHERE 
    salary_hour_avg IS NOT NULL
ORDER BY 
    salary_hour_avg DESC
LIMIT 140;

--ROW_NUMBER()
SELECT 
    *,
    ROW_NUMBER() OVER(ORDER BY job_posted_date) AS job_posting_sk
FROM
    job_postings_fact
ORDER BY 
    job_posted_date
LIMIT 20;

--NAVIGATION FUNCTION
    --LAG
    --LEAD
    --FIRST_VALUE
    --LAST_VALUE
    --NTH_VALUE

SELECT
    job_id,
    company_id,
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    LAG(salary_year_avg) OVER(PARTITION BY company_id ORDER BY job_posted_date) AS previous_year_sal,
    salary_year_avg - LAG(salary_year_avg) OVER(PARTITION BY company_id ORDER BY job_posted_date) AS salary_change
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
ORDER BY company_id, job_posted_date
LIMIT 60;

SELECT
    job_id,
    company_id,
    job_title,
    job_title_short,
    job_posted_date,
    salary_year_avg,
    LEAD(salary_year_avg) OVER(PARTITION BY company_id ORDER BY job_posted_date) AS next_year_sal,
    salary_year_avg - LEAD(salary_year_avg) OVER(PARTITION BY company_id ORDER BY job_posted_date) AS salary_change
FROM
    job_postings_fact
WHERE
    salary_year_avg IS NOT NULL
ORDER BY company_id, job_posted_date
LIMIT 60;