-- ============================================================
-- DATAVERSE INC. — HR ANALYTICS SUMMARY (denormalized for analytics)
-- A pre-built analytics table mirroring employees for fast querying
-- ============================================================

DROP TABLE IF EXISTS hr_analytics_summary CASCADE;

CREATE TABLE hr_analytics_summary (
    summary_id          SERIAL PRIMARY KEY,
    employee_id         INT REFERENCES employees(employee_id),
    full_name           VARCHAR(100),
    department_name     VARCHAR(100),
    job_title           VARCHAR(100),
    location            VARCHAR(100),
    tenure_years        NUMERIC(4,1),
    salary              NUMERIC(12,2),
    salary_band         VARCHAR(20),
    age                 INT,
    age_group           VARCHAR(20),
    gender              VARCHAR(10),
    status              VARCHAR(20),
    is_manager          BOOLEAN,
    last_review_rating  NUMERIC(3,1),
    flight_risk_score   INT,   -- 1-100, higher = more risk
    engagement_score    INT,   -- 1-100
    snapshot_date       DATE DEFAULT CURRENT_DATE
);

-- Populate from employees with derived analytics columns
INSERT INTO hr_analytics_summary (employee_id, full_name, department_name, job_title, location, tenure_years, salary, salary_band, age, age_group, gender, status, is_manager, last_review_rating, flight_risk_score, engagement_score)
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS full_name,
    d.department_name,
    e.job_title,
    e.location,
    ROUND(EXTRACT(YEAR FROM AGE(CURRENT_DATE, e.hire_date)) + EXTRACT(MONTH FROM AGE(CURRENT_DATE, e.hire_date))/12.0, 1) AS tenure_years,
    e.salary,
    CASE 
        WHEN e.salary < 80000 THEN 'Band 1 (<80K)'
        WHEN e.salary < 120000 THEN 'Band 2 (80-120K)'
        WHEN e.salary < 180000 THEN 'Band 3 (120-180K)'
        WHEN e.salary < 280000 THEN 'Band 4 (180-280K)'
        ELSE 'Band 5 (280K+)'
    END AS salary_band,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, e.date_of_birth))::INT AS age,
    CASE 
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, e.date_of_birth)) < 30 THEN '20s'
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, e.date_of_birth)) < 40 THEN '30s'
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, e.date_of_birth)) < 50 THEN '40s'
        ELSE '50+'
    END AS age_group,
    e.gender,
    e.status,
    EXISTS (SELECT 1 FROM employees sub WHERE sub.manager_id = e.employee_id) AS is_manager,
    -- Simulated review rating based on salary percentile
    ROUND((3.5 + (e.salary / 450000.0) * 1.5)::NUMERIC, 1) AS last_review_rating,
    -- Simulated flight risk: higher for lower tenure + lower salary
    LEAST(100, GREATEST(10, 
        (50 - (e.salary / 10000)::INT + 
         CASE WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, e.hire_date)) < 2 THEN 30 ELSE 0 END)
    ))::INT AS flight_risk_score,
    -- Simulated engagement score
    LEAST(100, GREATEST(40, (60 + (e.salary / 20000)::INT)))::INT AS engagement_score
FROM employees e
JOIN departments d ON e.department_id = d.department_id;
