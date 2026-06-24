-- ============================================================
-- DATAVERSE INC. — LEARNING & DEVELOPMENT (200 rows)
-- ============================================================

DROP TABLE IF EXISTS learning_enrollments CASCADE;
DROP TABLE IF EXISTS courses CASCADE;

CREATE TABLE courses (
    course_id       SERIAL PRIMARY KEY,
    course_name     VARCHAR(150) NOT NULL,
    category        VARCHAR(50),
    provider        VARCHAR(100),
    duration_hours  INT,
    difficulty      VARCHAR(20) CHECK (difficulty IN ('Beginner','Intermediate','Advanced','Expert')),
    cost            NUMERIC(10,2),
    is_mandatory    BOOLEAN DEFAULT FALSE
);

CREATE TABLE learning_enrollments (
    enrollment_id     SERIAL PRIMARY KEY,
    employee_id       INT REFERENCES employees(employee_id),
    course_id         INT REFERENCES courses(course_id),
    enrollment_date   DATE NOT NULL,
    completion_date   DATE,
    status            VARCHAR(20) CHECK (status IN ('Enrolled','In Progress','Completed','Dropped','Failed')),
    progress_pct      NUMERIC(5,2) DEFAULT 0,
    final_score       INT,
    certificate_earned BOOLEAN DEFAULT FALSE,
    hours_spent       NUMERIC(5,1),
    created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO courses (course_name, category, provider, duration_hours, difficulty, cost, is_mandatory) VALUES
('SQL Fundamentals',                'Data',        'Internal Academy',  20, 'Beginner',     0.00,  TRUE),
('Advanced SQL & Query Tuning',     'Data',        'Internal Academy',  30, 'Advanced',     0.00,  FALSE),
('Python for Data Engineering',     'Engineering', 'Coursera',          40, 'Intermediate', 49.00, FALSE),
('Snowflake Architecture',          'Data',        'Snowflake',         25, 'Advanced',    299.00, FALSE),
('dbt Fundamentals',                'Data',        'dbt Labs',          15, 'Intermediate', 0.00,  FALSE),
('Apache Airflow Mastery',          'Engineering', 'Udemy',             35, 'Advanced',     89.00, FALSE),
('Data Warehouse Design',           'Architecture','Internal Academy',  30, 'Advanced',     0.00,  FALSE),
('Leadership Essentials',           'Soft Skills', 'LinkedIn Learning', 12, 'Beginner',     0.00,  TRUE),
('Machine Learning Basics',         'AI/ML',       'Coursera',          50, 'Intermediate', 49.00, FALSE),
('Generative AI & LLMs',            'AI/ML',       'DeepLearning.AI',   30, 'Advanced',    199.00, FALSE),
('Data Security & Compliance',      'Security',    'Internal Academy',  10, 'Beginner',     0.00,  TRUE),
('Effective Communication',         'Soft Skills', 'LinkedIn Learning',  8, 'Beginner',     0.00,  TRUE),
('Cloud Computing AWS',             'Cloud',       'AWS',               45, 'Intermediate',149.00, FALSE),
('Tableau Data Visualization',      'Analytics',   'Tableau',           20, 'Intermediate', 99.00, FALSE),
('Statistics for Data Science',     'Data',        'Coursera',          35, 'Intermediate', 49.00, FALSE);

INSERT INTO learning_enrollments (employee_id, course_id, enrollment_date, completion_date, status, progress_pct, final_score, certificate_earned, hours_spent) VALUES
(57, 1,  '2024-01-10', '2024-01-25', 'Completed',   100.00, 92, TRUE,  22.5),
(57, 2,  '2024-02-01', '2024-03-01', 'Completed',   100.00, 88, TRUE,  32.0),
(57, 5,  '2024-03-15', NULL,         'In Progress',  65.00, NULL,FALSE, 10.0),
(58, 1,  '2024-01-10', '2024-01-28', 'Completed',   100.00, 85, TRUE,  21.0),
(58, 14, '2024-02-15', '2024-03-10', 'Completed',   100.00, 90, TRUE,  19.5),
(58, 2,  '2024-04-01', NULL,         'In Progress',  40.00, NULL,FALSE,  12.0),
(55, 1,  '2023-06-01', '2023-06-15', 'Completed',   100.00, 95, TRUE,  20.0),
(55, 2,  '2023-07-01', '2023-08-01', 'Completed',   100.00, 93, TRUE,  30.0),
(55, 4,  '2023-09-01', '2023-10-01', 'Completed',   100.00, 89, TRUE,  25.0),
(55, 7,  '2023-11-01', '2023-12-15', 'Completed',   100.00, 91, TRUE,  29.0),
(56, 1,  '2023-06-01', '2023-06-20', 'Completed',   100.00, 87, TRUE,  21.0),
(56, 2,  '2023-08-01', '2023-09-01', 'Completed',   100.00, 84, TRUE,  31.0),
(56, 5,  '2023-10-01', '2023-10-20', 'Completed',   100.00, 86, TRUE,  15.0),
(53, 1,  '2022-06-01', '2022-06-15', 'Completed',   100.00, 90, TRUE,  20.0),
(53, 2,  '2022-08-01', '2022-09-01', 'Completed',   100.00, 92, TRUE,  30.0),
(53, 4,  '2023-01-01', '2023-02-01', 'Completed',   100.00, 88, TRUE,  26.0),
(53, 6,  '2023-04-01', '2023-05-15', 'Completed',   100.00, 85, TRUE,  35.0),
(53, 10, '2024-01-01', NULL,         'In Progress',  55.00, NULL,FALSE,  16.0),
(51, 7,  '2022-03-01', '2022-04-01', 'Completed',   100.00, 96, TRUE,  30.0),
(51, 8,  '2022-05-01', '2022-05-15', 'Completed',   100.00, 94, TRUE,  12.0),
(51, 10, '2023-06-01', '2023-07-01', 'Completed',   100.00, 92, TRUE,  29.0),
(83, 9,  '2024-02-01', NULL,         'In Progress',  70.00, NULL,FALSE,  35.0),
(83, 10, '2024-03-01', NULL,         'In Progress',  45.00, NULL,FALSE,  14.0),
(84, 9,  '2024-01-15', '2024-03-01', 'Completed',   100.00, 91, TRUE,  48.0),
(84, 10, '2024-03-15', NULL,         'In Progress',  60.00, NULL,FALSE,  18.0),
-- Mandatory course completions across many employees
(6,  8,  '2024-01-05', '2024-01-12', 'Completed',   100.00, 88, TRUE,  12.0),
(6,  11, '2024-01-15', '2024-01-20', 'Completed',   100.00, 95, TRUE,  10.0),
(7,  8,  '2024-01-05', '2024-01-15', 'Completed',   100.00, 85, TRUE,  12.0),
(13, 8,  '2024-01-05', '2024-01-18', 'Completed',   100.00, 90, TRUE,  12.0),
(19, 8,  '2024-01-05', '2024-01-14', 'Completed',   100.00, 92, TRUE,  12.0),
(20, 8,  '2024-01-05', '2024-01-13', 'Completed',   100.00, 94, TRUE,  12.0),
(20, 12, '2024-02-01', '2024-02-08', 'Completed',   100.00, 91, TRUE,   8.0),
(30, 8,  '2024-01-05', NULL,         'Dropped',      30.00, NULL,FALSE,   4.0),
(37, 8,  '2024-01-05', '2024-01-20', 'Completed',   100.00, 89, TRUE,  12.0),
(59, 1,  '2024-02-01', '2024-02-20', 'Completed',   100.00, 80, TRUE,  20.0),
(60, 1,  '2024-02-01', NULL,         'In Progress',  50.00, NULL,FALSE,  10.0),
(60, 11, '2024-01-05', '2024-01-25', 'Completed',   100.00, 82, TRUE,  10.0);
