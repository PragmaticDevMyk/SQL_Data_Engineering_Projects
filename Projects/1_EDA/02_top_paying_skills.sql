/*
Question - what are the highest paying skills for data engineers
-Calculate the median salary  for each skill  required in data engineer positions
-Focus on remote positions with specified salaries
-Include skill frequency both salary and demand
-Why? Helps identify which skills command the highest compensation while also showing
    how common those skills are, providing a more complete picture for skill development priorities

*/

SELECT sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.*) AS demand_count

FROM  job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
    ON sjd.skill_id = sd.skill_id
WHERE jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = True
GROUP BY sd.skills
HAVING demand_count > 100
ORDER BY median_salary DESC
LIMIT 25;




/*
-Rust has the highest median salary at $210,000.
-Golang and Terraform both have a median salary of $184,000.
-Terraform stands out because it combines a high salary with strong demand (3,248 jobs).
-Golang has 912 jobs, giving it moderate demand compared with Terraform.
-Spring has a median salary of $175,500 and demand of 364 jobs.
-Neo4j offers $170,000 median salary but has relatively low demand (277 jobs).
-Zoom has a median salary of $168,438, but demand is only 127 jobs.
-GDPR has a median salary of $169,616 with 582 jobs.
-GraphQL offers $167,500 with 445 jobs.
-Mongo has a median salary of $162,250 and demand of 265 jobs.
-FastAPI has the lowest salary among the top 10 at $157,500, with 204 jobs.
-Overall, high salary does not necessarily mean high demand.
-Terraform provides an interesting balance of high compensation and strong market demand.
-Rust appears more specialized, with the highest salary but much lower demand.
-For career planning, it is useful to consider salary and demand together, rather than salary alone.





┌────────────┬───────────────┬──────────────┐
│   skills   │ median_salary │ demand_count │
│  varchar   │    double     │    int64     │
├────────────┼───────────────┼──────────────┤
│ rust       │      210000.0 │          232 │
│ golang     │      184000.0 │          912 │
│ terraform  │      184000.0 │         3248 │
│ spring     │      175500.0 │          364 │
│ neo4j      │      170000.0 │          277 │
│ gdpr       │      169616.0 │          582 │
│ zoom       │      168438.0 │          127 │
│ graphql    │      167500.0 │          445 │
│ mongo      │      162250.0 │          265 │
│ fastapi    │      157500.0 │          204 │
│ bitbucket  │      155000.0 │          478 │
│ django     │      155000.0 │          265 │
│ crystal    │      154224.0 │          129 │
│ atlassian  │      151500.0 │          249 │
│ c          │      151500.0 │          444 │
│ typescript │      151000.0 │          388 │
│ kubernetes │      150500.0 │         4202 │
│ ruby       │      150000.0 │          736 │
│ node       │      150000.0 │          179 │
│ airflow    │      150000.0 │         9996 │
│ css        │      150000.0 │          262 │
│ redis      │      149000.0 │          605 │
│ vmware     │      148798.0 │          136 │
│ ansible    │      148798.0 │          475 │
│ jupyter    │      147500.0 │          400 │
*/