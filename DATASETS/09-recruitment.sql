-- ============================================================
-- DATAVERSE INC. — RECRUITMENT (80 rows)
-- ============================================================

DROP TABLE IF EXISTS recruitment CASCADE;

CREATE TABLE recruitment (
    application_id    SERIAL PRIMARY KEY,
    candidate_name    VARCHAR(100) NOT NULL,
    candidate_email   VARCHAR(100),
    position_applied  VARCHAR(100) NOT NULL,
    department_id     INT REFERENCES departments(department_id),
    application_date  DATE NOT NULL,
    source            VARCHAR(50),  -- LinkedIn, Referral, Job Board, etc.
    recruiter_id      INT REFERENCES employees(employee_id),
    stage             VARCHAR(30) CHECK (stage IN ('Applied','Screening','Phone Interview','Technical Interview','Onsite','Offer','Hired','Rejected','Withdrawn')),
    years_experience  INT,
    expected_salary   NUMERIC(12,2),
    offered_salary    NUMERIC(12,2),
    rating            NUMERIC(3,1),
    interview_score   INT,
    decision_date     DATE,
    notes             TEXT,
    created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO recruitment (candidate_name, candidate_email, position_applied, department_id, application_date, source, recruiter_id, stage, years_experience, expected_salary, offered_salary, rating, interview_score, decision_date) VALUES
('Aiden Carter',    'aiden.c@email.com',   'Data Engineer',            7, '2024-01-05', 'LinkedIn',  10, 'Hired',               5, 145000.00, 142000.00, 4.5, 88, '2024-02-15'),
('Bella Nguyen',    'bella.n@email.com',   'Data Analyst',             7, '2024-01-08', 'Referral',  10, 'Hired',               3, 110000.00, 108000.00, 4.2, 85, '2024-02-20'),
('Caleb Foster',    'caleb.f@email.com',   'Software Engineer',        6, '2024-01-10', 'Job Board', 11, 'Rejected',            4, 130000.00, NULL,      3.0, 65, '2024-01-25'),
('Diana Reed',      'diana.r@email.com',   'Analytics Engineer',       7, '2024-01-12', 'LinkedIn',  10, 'Offer',               6, 138000.00, 135000.00, 4.6, 90, '2024-03-01'),
('Ethan Brooks',    'ethan.b@email.com',   'Sales Representative',     4, '2024-01-15', 'LinkedIn',  11, 'Hired',               2, 75000.00,  74000.00,  4.0, 82, '2024-02-10'),
('Fiona Clarke',    'fiona.c@email.com',   'Marketing Analyst',        5, '2024-01-18', 'Job Board', 10, 'Rejected',            3, 80000.00,  NULL,      2.8, 60, '2024-02-01'),
('George Hall',     'george.h@email.com',  'Data Scientist',          12, '2024-01-20', 'Referral',  11, 'Onsite',              7, 160000.00, NULL,      4.4, 87, NULL),
('Hannah Price',    'hannah.p@email.com',  'Financial Analyst',        3, '2024-01-22', 'LinkedIn',  10, 'Hired',               4, 95000.00,  92000.00,  4.3, 86, '2024-02-25'),
('Ian Murphy',      'ian.m@email.com',     'DevOps Engineer',          6, '2024-01-25', 'Job Board', 11, 'Technical Interview', 5, 140000.00, NULL,      4.1, 80, NULL),
('Julia Stewart',   'julia.s@email.com',   'Junior Data Analyst',      7, '2024-01-28', 'University',10, 'Hired',               1, 82000.00,  80000.00,  4.0, 78, '2024-03-05'),
('Kyle Adams',      'kyle.a@email.com',    'Account Executive',        4, '2024-02-01', 'Referral',  11, 'Offer',               5, 100000.00, 98000.00,  4.5, 89, '2024-03-10'),
('Laura Bennett',   'laura.b@email.com',   'Product Manager',          9, '2024-02-03', 'LinkedIn',  10, 'Onsite',              6, 155000.00, NULL,      4.3, 85, NULL),
('Mason Cole',      'mason.c@email.com',   'Software Engineer',        6, '2024-02-05', 'Job Board', 11, 'Hired',               4, 125000.00, 122000.00, 4.4, 87, '2024-03-15'),
('Nina Foster',     'nina.f@email.com',    'HR Business Partner',      2, '2024-02-08', 'LinkedIn',  10, 'Phone Interview',     5, 92000.00,  NULL,      3.8, 75, NULL),
('Oscar Diaz',      'oscar.d@email.com',   'Data Engineer',            7, '2024-02-10', 'Referral',  11, 'Rejected',            3, 135000.00, NULL,      3.2, 68, '2024-02-28'),
('Paula Rivera',    'paula.r@email.com',   'Sales Development Rep',     4, '2024-02-12', 'Job Board', 10, 'Hired',               1, 62000.00,  60000.00,  3.9, 76, '2024-03-20'),
('Quentin Lee',     'quentin.l@email.com', 'ML Engineer',             12, '2024-02-15', 'LinkedIn',  11, 'Offer',               6, 178000.00, 175000.00, 4.7, 92, '2024-03-25'),
('Rachel Gray',     'rachel.g@email.com',  'Marketing Manager',        5, '2024-02-18', 'Referral',  10, 'Technical Interview', 7, 130000.00, NULL,      4.2, 83, NULL),
('Sam Walker',      'sam.w@email.com',     'Junior Software Engineer', 6, '2024-02-20', 'University',11, 'Hired',               0, 95000.00,  92000.00,  3.8, 74, '2024-03-30'),
('Tina Brooks',     'tina.b@email.com',    'Data Analyst',             7, '2024-02-22', 'LinkedIn',  10, 'Screening',           3, 105000.00, NULL,      NULL,NULL, NULL),
('Umar Khan',       'umar.k@email.com',    'Senior Data Engineer',     7, '2024-02-25', 'Referral',  11, 'Onsite',              8, 175000.00, NULL,      4.5, 88, NULL),
('Vera Lopez',      'vera.l@email.com',    'Financial Analyst',        3, '2024-02-28', 'Job Board', 10, 'Rejected',            2, 88000.00,  NULL,      2.9, 62, '2024-03-15'),
('Will Turner',     'will.t@email.com',    'Account Executive',        4, '2024-03-01', 'LinkedIn',  11, 'Offer',               4, 98000.00,  95000.00,  4.3, 84, '2024-04-01'),
('Xena Morris',     'xena.m@email.com',    'Analytics Engineer',       7, '2024-03-05', 'Referral',  10, 'Hired',               5, 132000.00, 130000.00, 4.6, 90, '2024-04-10'),
('Yusuf Ali',       'yusuf.a@email.com',   'Data Scientist',          12, '2024-03-08', 'LinkedIn',  11, 'Applied',             6, 158000.00, NULL,      NULL,NULL, NULL),
('Zoe Campbell',    'zoe.c@email.com',     'Junior Data Analyst',      7, '2024-03-10', 'University',10, 'Phone Interview',     1, 80000.00,  NULL,      3.7, 72, NULL),
('Adam Foster',     'adam.f@email.com',    'Sales Representative',     4, '2024-03-12', 'Job Board', 11, 'Withdrawn',           3, 76000.00,  NULL,      3.5, 70, '2024-03-20'),
('Bridget Kelly',   'bridget.k@email.com', 'Product Manager',          9, '2024-03-15', 'LinkedIn',  10, 'Screening',           7, 152000.00, NULL,      NULL,NULL, NULL),
('Carl Hughes',     'carl.h@email.com',    'DevOps Engineer',          6, '2024-03-18', 'Referral',  11, 'Technical Interview', 6, 142000.00, NULL,      4.2, 82, NULL),
('Dana Price',      'dana.p@email.com',    'HR Analyst',               2, '2024-03-20', 'Job Board', 10, 'Hired',               2, 68000.00,  66000.00,  3.9, 77, '2024-04-15');
