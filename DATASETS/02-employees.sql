-- ============================================================
-- DATAVERSE INC. — EMPLOYEES (150 rows)
-- ============================================================

DROP TABLE IF EXISTS employees CASCADE;

CREATE TABLE employees (
    employee_id     SERIAL PRIMARY KEY,
    first_name      VARCHAR(50)  NOT NULL,
    last_name       VARCHAR(50)  NOT NULL,
    email           VARCHAR(100) UNIQUE NOT NULL,
    phone           VARCHAR(20),
    hire_date       DATE         NOT NULL,
    job_title       VARCHAR(100) NOT NULL,
    department_id   INT REFERENCES departments(department_id),
    manager_id      INT,
    salary          NUMERIC(12,2) NOT NULL,
    employment_type VARCHAR(20) CHECK (employment_type IN ('Full-Time','Part-Time','Contract','Intern')),
    status          VARCHAR(20) CHECK (status IN ('Active','Inactive','On Leave','Terminated')),
    location        VARCHAR(100),
    gender          VARCHAR(10),
    date_of_birth   DATE,
    termination_date DATE,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO employees (first_name, last_name, email, phone, hire_date, job_title, department_id, manager_id, salary, employment_type, status, location, gender, date_of_birth) VALUES
-- Executive (dept 1)
('James',    'Richardson',  'j.richardson@dataverse.com',  '212-555-0101', '2015-03-01', 'CEO',                         1, NULL, 450000.00, 'Full-Time', 'Active', 'New York',      'Male',   '1972-06-15'),
('Sandra',   'Mitchell',    's.mitchell@dataverse.com',    '212-555-0102', '2016-05-15', 'CFO',                         3, 1,    380000.00, 'Full-Time', 'Active', 'New York',      'Female', '1975-09-22'),
('Marcus',   'Thompson',    'm.thompson@dataverse.com',    '212-555-0103', '2017-01-10', 'CTO',                         6, 1,    395000.00, 'Full-Time', 'Active', 'Austin',        'Male',   '1978-11-30'),
('Angela',   'Davis',       'a.davis@dataverse.com',       '212-555-0104', '2018-07-01', 'CDO',                         7, 1,    360000.00, 'Full-Time', 'Active', 'Austin',        'Female', '1980-03-14'),
('Robert',   'Lee',         'r.lee@dataverse.com',         '212-555-0105', '2019-02-20', 'VP Sales',                    4, 1,    310000.00, 'Full-Time', 'Active', 'Chicago',       'Male',   '1977-07-08'),
-- HR (dept 2)
('Patricia', 'Williams',    'p.williams@dataverse.com',    '212-555-0201', '2016-08-15', 'HR Director',                 2, 1,    175000.00, 'Full-Time', 'Active', 'New York',      'Female', '1979-12-05'),
('Kevin',    'Johnson',     'k.johnson@dataverse.com',     '212-555-0202', '2018-03-01', 'HR Manager',                  2, 6,    125000.00, 'Full-Time', 'Active', 'New York',      'Male',   '1985-04-18'),
('Lisa',     'Martinez',    'l.martinez@dataverse.com',    '212-555-0203', '2019-06-10', 'Talent Acquisition Lead',     2, 6,    105000.00, 'Full-Time', 'Active', 'New York',      'Female', '1990-02-27'),
('Thomas',   'Anderson',    't.anderson@dataverse.com',    '212-555-0204', '2020-01-15', 'HR Business Partner',         2, 7,     92000.00, 'Full-Time', 'Active', 'New York',      'Male',   '1988-08-11'),
('Emma',     'Wilson',      'e.wilson@dataverse.com',      '212-555-0205', '2020-09-01', 'Recruiter',                   2, 8,     75000.00, 'Full-Time', 'Active', 'New York',      'Female', '1993-05-30'),
('David',    'Brown',       'd.brown@dataverse.com',       '212-555-0206', '2021-03-15', 'Recruiter',                   2, 8,     72000.00, 'Full-Time', 'Active', 'New York',      'Male',   '1994-11-22'),
('Sophie',   'Taylor',      's.taylor@dataverse.com',      '212-555-0207', '2021-07-01', 'HR Analyst',                  2, 7,     68000.00, 'Full-Time', 'Active', 'New York',      'Female', '1996-01-14'),
-- Finance (dept 3)
('Michael',  'Clark',       'm.clark@dataverse.com',       '312-555-0301', '2017-04-01', 'Finance Manager',             3, 2,    155000.00, 'Full-Time', 'Active', 'New York',      'Male',   '1982-06-28'),
('Jennifer', 'Lewis',       'j.lewis@dataverse.com',       '312-555-0302', '2018-09-15', 'Senior Financial Analyst',    3, 13,   115000.00, 'Full-Time', 'Active', 'New York',      'Female', '1987-03-15'),
('William',  'Walker',      'w.walker@dataverse.com',      '312-555-0303', '2019-11-01', 'Financial Analyst',           3, 13,    95000.00, 'Full-Time', 'Active', 'New York',      'Male',   '1991-09-07'),
('Rachel',   'Hall',        'r.hall@dataverse.com',        '312-555-0304', '2020-06-15', 'Financial Analyst',           3, 13,    88000.00, 'Full-Time', 'Active', 'New York',      'Female', '1992-12-19'),
('Steven',   'Allen',       's.allen@dataverse.com',       '312-555-0305', '2020-12-01', 'Accountant',                  3, 13,    82000.00, 'Full-Time', 'Active', 'New York',      'Male',   '1994-04-03'),
('Nicole',   'Young',       'n.young@dataverse.com',       '312-555-0306', '2021-04-15', 'Accountant',                  3, 13,    79000.00, 'Full-Time', 'Active', 'New York',      'Female', '1995-07-21'),
-- Sales (dept 4)
('Christopher','King',      'c.king@dataverse.com',        '312-555-0401', '2017-06-01', 'Sales Manager',               4, 5,    145000.00, 'Full-Time', 'Active', 'Chicago',       'Male',   '1983-08-14'),
('Amanda',   'Scott',       'a.scott@dataverse.com',       '312-555-0402', '2018-02-15', 'Senior Account Executive',    4, 19,   115000.00, 'Full-Time', 'Active', 'Chicago',       'Female', '1986-02-09'),
('Daniel',   'Green',       'd.green@dataverse.com',       '312-555-0403', '2018-07-01', 'Account Executive',           4, 19,    98000.00, 'Full-Time', 'Active', 'Chicago',       'Male',   '1989-10-25'),
('Michelle', 'Baker',       'm.baker@dataverse.com',       '312-555-0404', '2019-01-15', 'Account Executive',           4, 19,    95000.00, 'Full-Time', 'Active', 'Chicago',       'Female', '1991-05-12'),
('Andrew',   'Adams',       'a.adams@dataverse.com',       '312-555-0405', '2019-05-01', 'Sales Representative',        4, 19,    78000.00, 'Full-Time', 'Active', 'Chicago',       'Male',   '1993-03-17'),
('Laura',    'Nelson',      'l.nelson@dataverse.com',      '312-555-0406', '2019-09-15', 'Sales Representative',        4, 19,    76000.00, 'Full-Time', 'Active', 'Chicago',       'Female', '1992-11-08'),
('Ryan',     'Carter',      'r.carter@dataverse.com',      '312-555-0407', '2020-02-01', 'Sales Representative',        4, 19,    74000.00, 'Full-Time', 'Active', 'Chicago',       'Male',   '1994-08-30'),
('Stephanie','Mitchell',    'st.mitchell@dataverse.com',   '312-555-0408', '2020-08-15', 'Sales Representative',        4, 19,    72000.00, 'Full-Time', 'Active', 'Chicago',       'Female', '1995-01-23'),
('Brandon',  'Perez',       'b.perez@dataverse.com',       '312-555-0409', '2021-01-01', 'Sales Development Rep',       4, 19,    62000.00, 'Full-Time', 'Active', 'Chicago',       'Male',   '1997-06-11'),
('Samantha', 'Roberts',     'sa.roberts@dataverse.com',    '312-555-0410', '2021-06-15', 'Sales Development Rep',       4, 19,    60000.00, 'Full-Time', 'Active', 'Chicago',       'Female', '1998-09-04'),
-- Marketing (dept 5)
('Matthew',  'Turner',      'm.turner@dataverse.com',      '415-555-0501', '2017-09-01', 'Marketing Director',          5, 1,    185000.00, 'Full-Time', 'Active', 'San Francisco', 'Male',   '1980-12-28'),
('Ashley',   'Phillips',    'a.phillips@dataverse.com',    '415-555-0502', '2018-05-15', 'Senior Marketing Manager',    5, 30,   135000.00, 'Full-Time', 'Active', 'San Francisco', 'Female', '1984-04-16'),
('Joshua',   'Campbell',    'j.campbell@dataverse.com',    '415-555-0503', '2019-02-01', 'Digital Marketing Manager',   5, 30,   115000.00, 'Full-Time', 'Active', 'San Francisco', 'Male',   '1987-07-22'),
('Megan',    'Parker',      'm.parker@dataverse.com',      '415-555-0504', '2019-08-15', 'Content Marketing Lead',      5, 30,   105000.00, 'Full-Time', 'Active', 'San Francisco', 'Female', '1989-10-05'),
('Nathan',   'Evans',       'n.evans@dataverse.com',       '415-555-0505', '2020-03-01', 'SEO Specialist',              5, 31,    88000.00, 'Full-Time', 'Active', 'San Francisco', 'Male',   '1992-01-18'),
('Jessica',  'Edwards',     'j.edwards@dataverse.com',     '415-555-0506', '2020-09-15', 'Social Media Manager',        5, 31,    85000.00, 'Full-Time', 'Active', 'San Francisco', 'Female', '1993-06-29'),
('Tyler',    'Collins',     't.collins@dataverse.com',     '415-555-0507', '2021-02-01', 'Marketing Analyst',           5, 31,    75000.00, 'Full-Time', 'Active', 'San Francisco', 'Male',   '1995-11-13'),
-- Engineering (dept 6)
('Zachary',  'Stewart',     'z.stewart@dataverse.com',     '512-555-0601', '2016-11-01', 'VP Engineering',              6, 3,    285000.00, 'Full-Time', 'Active', 'Austin',        'Male',   '1979-05-20'),
('Hannah',   'Sanchez',     'h.sanchez@dataverse.com',     '512-555-0602', '2017-07-15', 'Engineering Manager',         6, 37,   195000.00, 'Full-Time', 'Active', 'Austin',        'Female', '1983-09-08'),
('Dylan',    'Morris',      'd.morris@dataverse.com',      '512-555-0603', '2018-01-01', 'Lead Software Engineer',      6, 38,   165000.00, 'Full-Time', 'Active', 'Austin',        'Male',   '1986-02-14'),
('Brittany', 'Rogers',      'b.rogers@dataverse.com',      '512-555-0604', '2018-06-15', 'Senior Software Engineer',    6, 39,   148000.00, 'Full-Time', 'Active', 'Austin',        'Female', '1988-07-31'),
('Justin',   'Reed',        'j.reed@dataverse.com',        '512-555-0605', '2018-11-01', 'Senior Software Engineer',    6, 39,   145000.00, 'Full-Time', 'Active', 'Austin',        'Male',   '1988-12-19'),
('Sarah',    'Cook',        's.cook@dataverse.com',        '512-555-0606', '2019-04-15', 'Software Engineer',           6, 39,   125000.00, 'Full-Time', 'Active', 'Austin',        'Female', '1991-04-02'),
('Aaron',    'Morgan',      'a.morgan@dataverse.com',      '512-555-0607', '2019-10-01', 'Software Engineer',           6, 39,   122000.00, 'Full-Time', 'Active', 'Austin',        'Male',   '1992-08-16'),
('Kimberly', 'Bell',        'k.bell@dataverse.com',        '512-555-0608', '2020-03-15', 'Software Engineer',           6, 39,   118000.00, 'Full-Time', 'Active', 'Austin',        'Female', '1993-03-27'),
('Joseph',   'Murphy',      'jo.murphy@dataverse.com',     '512-555-0609', '2020-09-01', 'Junior Software Engineer',    6, 39,    95000.00, 'Full-Time', 'Active', 'Austin',        'Male',   '1996-11-04'),
('Christina','Bailey',      'c.bailey@dataverse.com',      '512-555-0610', '2021-01-15', 'Junior Software Engineer',    6, 39,    92000.00, 'Full-Time', 'Active', 'Austin',        'Female', '1997-06-21'),
('Eric',     'Rivera',      'e.rivera@dataverse.com',      '512-555-0611', '2021-06-01', 'DevOps Engineer',             6, 38,   138000.00, 'Full-Time', 'Active', 'Austin',        'Male',   '1990-01-09'),
('Rebecca',  'Cooper',      'r.cooper@dataverse.com',      '512-555-0612', '2021-11-15', 'QA Engineer',                 6, 38,   112000.00, 'Full-Time', 'Active', 'Austin',        'Female', '1991-07-17'),
-- Data & Analytics (dept 7)
('Nicholas', 'Richardson',  'ni.richardson@dataverse.com', '512-555-0701', '2018-03-01', 'Head of Data Engineering',    7, 4,    210000.00, 'Full-Time', 'Active', 'Austin',        'Male',   '1982-10-23'),
('Amber',    'Cox',         'a.cox@dataverse.com',         '512-555-0702', '2018-10-15', 'Senior Data Engineer',        7, 51,   170000.00, 'Full-Time', 'Active', 'Austin',        'Female', '1985-08-05'),
('Derrick',  'Howard',      'd.howard@dataverse.com',      '512-555-0703', '2019-04-01', 'Data Engineer',               7, 51,   145000.00, 'Full-Time', 'Active', 'Austin',        'Male',   '1988-12-11'),
('Vanessa',  'Ward',        'v.ward@dataverse.com',        '512-555-0704', '2019-09-15', 'Data Engineer',               7, 51,   142000.00, 'Full-Time', 'Active', 'Austin',        'Female', '1989-05-26'),
('Carlos',   'Torres',      'c.torres@dataverse.com',      '512-555-0705', '2020-02-01', 'Analytics Engineer',          7, 51,   135000.00, 'Full-Time', 'Active', 'Austin',        'Male',   '1991-02-03'),
('Diana',    'Peterson',    'd.peterson@dataverse.com',    '512-555-0706', '2020-07-15', 'Analytics Engineer',          7, 51,   132000.00, 'Full-Time', 'Active', 'Austin',        'Female', '1992-09-14'),
('Marcus',   'Gray',        'ma.gray@dataverse.com',       '512-555-0707', '2020-12-01', 'Data Analyst',                7, 55,   112000.00, 'Full-Time', 'Active', 'Austin',        'Male',   '1994-04-28'),
('Tiffany',  'Ramirez',     't.ramirez@dataverse.com',     '512-555-0708', '2021-04-15', 'Data Analyst',                7, 55,   108000.00, 'Full-Time', 'Active', 'Austin',        'Female', '1995-08-07'),
('Elijah',   'James',       'e.james@dataverse.com',       '512-555-0709', '2021-09-01', 'Junior Data Analyst',         7, 57,    85000.00, 'Full-Time', 'Active', 'Austin',        'Male',   '1998-01-31'),
('Olivia',   'Watson',      'o.watson@dataverse.com',      '512-555-0710', '2022-01-15', 'Junior Data Analyst',         7, 57,    82000.00, 'Full-Time', 'Active', 'Austin',        'Female', '1998-11-15'),
-- Customer Success (dept 8)
('Bradley',  'Brooks',      'b.brooks@dataverse.com',      '312-555-0801', '2018-05-01', 'VP Customer Success',         8, 1,    220000.00, 'Full-Time', 'Active', 'Chicago',       'Male',   '1981-07-09'),
('Victoria', 'Kelly',       'v.kelly@dataverse.com',       '312-555-0802', '2019-01-15', 'Customer Success Manager',    8, 61,   145000.00, 'Full-Time', 'Active', 'Chicago',       'Female', '1985-03-24'),
('Jonathan', 'Price',       'j.price@dataverse.com',       '312-555-0803', '2019-07-01', 'Senior CSM',                  8, 62,   115000.00, 'Full-Time', 'Active', 'Chicago',       'Male',   '1988-10-16'),
('Melissa',  'Sanders',     'm.sanders@dataverse.com',     '312-555-0804', '2020-01-15', 'CSM',                         8, 62,    95000.00, 'Full-Time', 'Active', 'Chicago',       'Female', '1991-06-02'),
('Gregory',  'Long',        'g.long@dataverse.com',        '312-555-0805', '2020-08-01', 'CSM',                         8, 62,    92000.00, 'Full-Time', 'Active', 'Chicago',       'Male',   '1992-09-19'),
('Alexis',   'Patterson',   'a.patterson@dataverse.com',   '312-555-0806', '2021-02-15', 'Support Specialist',          8, 62,    72000.00, 'Full-Time', 'Active', 'Chicago',       'Female', '1995-12-08'),
-- Product (dept 9)
('Sean',     'Hughes',      'se.hughes@dataverse.com',     '415-555-0901', '2018-08-01', 'Chief Product Officer',       9, 1,    295000.00, 'Full-Time', 'Active', 'San Francisco', 'Male',   '1978-04-12'),
('Lauren',   'Flores',      'l.flores@dataverse.com',      '415-555-0902', '2019-03-15', 'Product Manager',             9, 67,   155000.00, 'Full-Time', 'Active', 'San Francisco', 'Female', '1983-11-26'),
('Aaron',    'Washington',  'ar.washington@dataverse.com', '415-555-0903', '2019-10-01', 'Product Manager',             9, 67,   152000.00, 'Full-Time', 'Active', 'San Francisco', 'Male',   '1984-06-04'),
('Natalie',  'Butler',      'n.butler@dataverse.com',      '415-555-0904', '2020-05-15', 'Associate Product Manager',   9, 67,   118000.00, 'Full-Time', 'Active', 'San Francisco', 'Female', '1990-02-17'),
-- Legal (dept 10)
('Timothy',  'Simmons',     't.simmons@dataverse.com',     '212-555-1001', '2016-12-01', 'General Counsel',            10, 1,    285000.00, 'Full-Time', 'Active', 'New York',      'Male',   '1975-08-31'),
('Christine','Foster',      'c.foster@dataverse.com',      '212-555-1002', '2018-04-15', 'Senior Counsel',             10, 71,   195000.00, 'Full-Time', 'Active', 'New York',      'Female', '1980-05-15'),
('Harold',   'Gonzalez',    'h.gonzalez@dataverse.com',    '212-555-1003', '2019-09-01', 'Compliance Manager',         10, 71,   145000.00, 'Full-Time', 'Active', 'New York',      'Male',   '1985-01-22'),
-- Operations (dept 11)
('Shawn',    'Bryant',      'sh.bryant@dataverse.com',     '214-555-1101', '2017-10-01', 'COO',                        11, 1,    350000.00, 'Full-Time', 'Active', 'Dallas',        'Male',   '1976-03-07'),
('Heather',  'Alexander',   'h.alexander@dataverse.com',   '214-555-1102', '2018-06-15', 'Operations Manager',         11, 74,   165000.00, 'Full-Time', 'Active', 'Dallas',        'Female', '1981-09-13'),
('Cody',     'Russell',     'c.russell@dataverse.com',     '214-555-1103', '2019-02-01', 'Operations Analyst',         11, 75,   105000.00, 'Full-Time', 'Active', 'Dallas',        'Male',   '1988-11-28'),
('Monica',   'Griffin',     'm.griffin@dataverse.com',     '214-555-1104', '2019-08-15', 'Operations Analyst',         11, 75,   102000.00, 'Full-Time', 'Active', 'Dallas',        'Female', '1989-04-20'),
('Justin',   'Diaz',        'ju.diaz@dataverse.com',       '214-555-1105', '2020-04-01', 'Business Analyst',           11, 75,    95000.00, 'Full-Time', 'Active', 'Dallas',        'Male',   '1991-10-06'),
-- R&D (dept 12)
('Carolyn',  'Hayes',       'c.hayes@dataverse.com',       '512-555-1201', '2018-01-15', 'Head of R&D',                12, 3,    310000.00, 'Full-Time', 'Active', 'Austin',        'Female', '1977-07-27'),
('Dennis',   'Myers',       'de.myers@dataverse.com',      '512-555-1202', '2018-10-01', 'Research Scientist',         12, 80,   185000.00, 'Full-Time', 'Active', 'Austin',        'Male',   '1982-02-19'),
('Karen',    'Ford',        'k.ford@dataverse.com',        '512-555-1203', '2019-05-15', 'Research Scientist',         12, 80,   180000.00, 'Full-Time', 'Active', 'Austin',        'Female', '1983-08-08'),
('Philip',   'Hamilton',    'p.hamilton@dataverse.com',    '512-555-1204', '2020-01-01', 'ML Engineer',                12, 80,   175000.00, 'Full-Time', 'Active', 'Austin',        'Male',   '1986-12-24'),
('Donna',    'Graham',      'd.graham@dataverse.com',      '512-555-1205', '2020-07-15', 'ML Engineer',                12, 80,   170000.00, 'Full-Time', 'Active', 'Austin',        'Female', '1987-05-11'),
('Larry',    'Sullivan',    'l.sullivan@dataverse.com',    '512-555-1206', '2021-02-01', 'Data Scientist',             12, 80,   158000.00, 'Full-Time', 'Active', 'Austin',        'Male',   '1989-09-03'),
-- More employees across departments
('Teresa',   'Wallace',     't.wallace@dataverse.com',     '512-555-1301', '2021-07-01', 'Data Scientist',             12, 80,   155000.00, 'Full-Time', 'Active', 'Austin',        'Female', '1990-06-14'),
('Raymond',  'West',        'r.west@dataverse.com',        '512-555-0714', '2022-01-01', 'Data Engineer',               7, 51,   140000.00, 'Full-Time', 'Active', 'Austin',        'Male',   '1993-10-09'),
('Lisa',     'Cole',        'li.cole@dataverse.com',       '312-555-0411', '2022-03-01', 'Account Executive',           4, 19,    93000.00, 'Full-Time', 'Active', 'Chicago',       'Female', '1994-03-28'),
('Jeremy',   'Stone',       'je.stone@dataverse.com',      '512-555-0716', '2022-05-01', 'Analytics Engineer',          7, 51,   130000.00, 'Full-Time', 'Active', 'Austin',        'Male',   '1995-07-16'),
('Crystal',  'Nichols',     'c.nichols@dataverse.com',     '214-555-1108', '2022-07-01', 'Business Analyst',           11, 75,    90000.00, 'Full-Time', 'Active', 'Dallas',        'Female', '1996-02-25'),
-- Terminated employees (historical data)
('Albert',   'Olson',       'a.olson@dataverse.com',       '312-555-0920', '2019-03-01', 'Sales Representative',        4, 19,    70000.00, 'Full-Time', 'Terminated', 'Chicago',   'Male',   '1992-06-03'),
('Tammy',    'Arnold',      't.arnold@dataverse.com',      '512-555-0820', '2019-11-01', 'Data Analyst',                7, 55,    85000.00, 'Full-Time', 'Terminated', 'Austin',    'Female', '1991-04-17'),
-- Part-time and contractors
('George',   'Harper',      'g.harper@dataverse.com',      '212-555-0830', '2021-09-01', 'HR Contractor',               2, 7,     65000.00, 'Contract',  'Active', 'Remote',        'Male',   '1988-08-20'),
('Sharon',   'Pierce',      'sh.pierce@dataverse.com',     '512-555-0831', '2022-02-01', 'Data Analyst Intern',         7, 57,     45000.00, 'Intern',    'Active', 'Austin',        'Female', '2000-03-12'),
('Roy',      'Owens',       'r.owens@dataverse.com',       '512-555-0832', '2022-04-01', 'Engineering Intern',          6, 38,     48000.00, 'Intern',    'Active', 'Austin',        'Male',   '2001-07-08'),
('Alice',    'Hunter',      'a.hunter@dataverse.com',      '312-555-0833', '2021-06-01', 'Marketing Contractor',        5, 30,     72000.00, 'Contract',  'Active', 'Remote',        'Female', '1989-11-15'),
-- On Leave
('Willie',   'Douglas',     'w.douglas@dataverse.com',     '512-555-0834', '2020-05-01', 'Senior Data Engineer',        7, 51,    168000.00, 'Full-Time', 'On Leave', 'Austin',     'Male',   '1984-09-22'),
('Marie',    'Fleming',     'm.fleming@dataverse.com',     '214-555-1109', '2020-08-01', 'Operations Specialist',      11, 75,     88000.00, 'Full-Time', 'On Leave', 'Dallas',     'Female', '1989-12-04');

-- Update termination dates for terminated employees
UPDATE employees SET termination_date = '2022-08-15' WHERE email = 'a.olson@dataverse.com';
UPDATE employees SET termination_date = '2023-01-31' WHERE email = 't.arnold@dataverse.com';
