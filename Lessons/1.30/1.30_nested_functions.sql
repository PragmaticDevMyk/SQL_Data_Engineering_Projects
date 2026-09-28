--Array Intro

SELECT [1,2,3];

SELECT ['SQL', 'Python', 'AWS'] AS job_skills;

WITH skills AS (
    SELECT 'Pyhton' AS skill
    UNION ALL
    SELECT 'SQL'
    UNION ALL
    SELECT 'R'
), skills_array AS
    (
    SELECT ARRAY_AGG(skill ORDER BY skill) AS skills
    FROM skills
    )
SELECT skills[1]
FROM skills_array;

--STRUCT
SELECT {skill : 'Python', type: 'Programming'} AS skill_struct;

WITH skill_struct AS (
    SELECT 
    STRUCT_PACK(
        skill := 'Python',
        type := 'Programming'
    ) AS s
)
SELECT 
    s.skill,
    s.type
FROM skill_struct;


WITH skill_table AS (
    SELECT 'Pyhton' AS skills, 'Programming' AS types
        UNION ALL
        SELECT 'SQL', 'Query Language'
        UNION ALL
        SELECT 'R', 'Programming'
)
SELECT
    STRUCT_PACK(
        skill := skills,
        type := types
    )
FROM skill_table;


--Array of Structs

SELECT [
    {skill: 'Python', type : 'Programming'},
    {skill: 'SQL', type: 'Query Language'}
] AS skills_array_of_Struct;

WITH skill_table AS (
    SELECT 'Pyhton' AS skills, 'Programming' AS types
        UNION ALL
        SELECT 'SQL', 'Query Language'
        UNION ALL
        SELECT 'R', 'Programming'
), skills_array_struct AS (
    SELECT
        ARRAY_AGG(
            STRUCT_PACK(
                skill := skills,
                type := types
            )
        ) array_struct
    FROM skill_table
    )
SELECT 
    array_struct[1].skill
FROM skills_array_struct;


--MAP
WITH skill_map AS (
    SELECT MAP {'Skill' : 'Python',
            'Type' : 'Programming'} AS skill_type
)
SELECT
    skill_type['Skill'],
    skill_type['Type']
FROM skill_map;



--JSON
WITH raw_skill_json AS (
    SELECT 
        '{"skill" : "python", "type" : "programming"}'::JSON AS skill_json
)
SELECT
    STRUCT_PACK(
        skill := JSON_EXTRACT_STRING(skill_json, '$.skill'),
        type := JSON_EXTRACT_STRING(skill_json, '$.type')
    )
FROM
    raw_skill_json;

--Arrays - Final Example
--Build a flat table for co-workers to access job_titles, salary info, and skills in one table
CREATE OR REPLACE TEMP TABLE job_skills_array AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(sd.skills) AS skills
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sd.skill_id = sjd.skill_id
GROUP BY jpf.job_id, jpf.job_title_short, jpf.salary_year_avg;


--From a Perspective of a Data Analyst, Analyze the median salary per skill

WITH flat_skills AS (
    SELECT job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skills) AS skill
    FROM
        job_skills_array
)
SELECT skill,
    MEDIAN(salary_year_avg) AS median_salary
FROM flat_skills
GROUP BY skill
ORDER BY median_salary DESC
LIMIT 20;


--Array of Stucts - Final Example
-- Build a flat skill & type for co-workers to access job titles, salary info, skills, and type in one table

CREATE OR REPLACE TEMP TABLE job_skills_array_struct AS
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(
        STRUCT_PACK(
            skill_type := sd.type,
            skill_name := sd.skills
        )
    ) AS skills_type
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sd.skill_id = sjd.skill_id
GROUP BY jpf.job_id, jpf.job_title_short, jpf.salary_year_avg;

--From a perspective of a Data Analyst, analyze the median salary per type of skill
WITH flat_skills AS (
    SELECT
        job_id,
        job_title_short,
        salary_year_avg,
        UNNEST(skills_type).skill_type AS skill_type,
        UNNEST(skills_type).skill_name
    FROM
        job_skills_array_struct
)
SELECT skill_type,
    MEDIAN(salary_year_avg) AS median_salary
FROM
    flat_skills
GROUP BY
    skill_type;


