-- ============================================================
-- DATAVERSE INC. — DEPARTMENTS
-- ============================================================

DROP TABLE IF EXISTS departments CASCADE;

CREATE TABLE departments (
    department_id     SERIAL PRIMARY KEY,
    department_name   VARCHAR(100) NOT NULL,
    location          VARCHAR(100),
    manager_id        INT,
    budget            NUMERIC(15,2),
    cost_center       VARCHAR(20),
    created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO departments (department_name, location, budget, cost_center) VALUES
('Executive Leadership',    'New York',     2500000.00, 'CC-001'),
('Human Resources',         'New York',      850000.00, 'CC-002'),
('Finance',                 'New York',     1200000.00, 'CC-003'),
('Sales',                   'Chicago',      3500000.00, 'CC-004'),
('Marketing',               'San Francisco',1100000.00, 'CC-005'),
('Engineering',             'Austin',       4200000.00, 'CC-006'),
('Data & Analytics',        'Austin',       1800000.00, 'CC-007'),
('Customer Success',        'Chicago',      1050000.00, 'CC-008'),
('Product Management',      'San Francisco', 950000.00, 'CC-009'),
('Legal & Compliance',      'New York',      650000.00, 'CC-010'),
('Operations',              'Dallas',       1400000.00, 'CC-011'),
('Research & Development',  'Austin',       2100000.00, 'CC-012');
