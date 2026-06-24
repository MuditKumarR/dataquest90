-- ============================================================
-- DATAVERSE INC. — CUSTOMERS (300 rows)
-- ============================================================

DROP TABLE IF EXISTS customers CASCADE;

CREATE TABLE customers (
    customer_id       SERIAL PRIMARY KEY,
    company_name      VARCHAR(200) NOT NULL,
    industry          VARCHAR(100),
    company_size      VARCHAR(20) CHECK (company_size IN ('SMB','Mid-Market','Enterprise')),
    country           VARCHAR(50),
    state_province    VARCHAR(50),
    city              VARCHAR(50),
    annual_revenue    NUMERIC(15,2),
    employee_count    INT,
    contact_first_name VARCHAR(50),
    contact_last_name  VARCHAR(50),
    contact_email      VARCHAR(100),
    contact_phone      VARCHAR(30),
    account_manager_id INT REFERENCES employees(employee_id),
    customer_status    VARCHAR(20) CHECK (customer_status IN ('Active','Inactive','Prospect','Churned')),
    acquisition_date   DATE,
    last_activity_date DATE,
    lifetime_value     NUMERIC(15,2) DEFAULT 0,
    nps_score          INT CHECK (nps_score BETWEEN 0 AND 10),
    contract_tier      VARCHAR(20) CHECK (contract_tier IN ('Starter','Growth','Business','Enterprise')),
    created_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO customers (company_name, industry, company_size, country, state_province, city, annual_revenue, employee_count, contact_first_name, contact_last_name, contact_email, account_manager_id, customer_status, acquisition_date, last_activity_date, lifetime_value, nps_score, contract_tier) VALUES
('TechNova Solutions',         'Technology',     'Enterprise', 'USA', 'California',  'San Francisco', 850000000,  5200, 'Alex',    'Chen',        'a.chen@technova.com',          20, 'Active',   '2020-01-15', '2024-11-01',  450000.00, 9,  'Enterprise'),
('GlobalFinance Corp',         'Finance',        'Enterprise', 'USA', 'New York',    'New York City', 2300000000, 12000,'Robert',  'Williams',    'r.williams@globalfinance.com', 21, 'Active',   '2019-06-01', '2024-10-15',  890000.00, 8,  'Enterprise'),
('HealthBridge Systems',       'Healthcare',     'Enterprise', 'USA', 'Texas',       'Houston',       450000000,   3500,'Maria',   'Garcia',      'm.garcia@healthbridge.com',    22, 'Active',   '2020-09-01', '2024-11-10',  320000.00, 7,  'Enterprise'),
('RetailChain Inc',            'Retail',         'Enterprise', 'USA', 'Illinois',    'Chicago',       1200000000,  8500,'James',   'Thompson',    'j.thompson@retailchain.com',   23, 'Active',   '2021-01-15', '2024-10-20',  280000.00, 8,  'Business'),
('ManufacturePro Ltd',         'Manufacturing',  'Enterprise', 'USA', 'Michigan',    'Detroit',       680000000,   4200,'Susan',   'Miller',      's.miller@manufacturepro.com',  24, 'Active',   '2020-03-01', '2024-09-30',  360000.00, 6,  'Enterprise'),
('EduLearn University',        'Education',      'Enterprise', 'USA', 'Massachusetts','Boston',       180000000,   2800,'David',   'Brown',       'd.brown@edulearn.edu',         25, 'Active',   '2021-06-15', '2024-11-05',  125000.00, 9,  'Business'),
('LogisticsFirst Corp',        'Logistics',      'Enterprise', 'USA', 'Georgia',     'Atlanta',       920000000,   6100,'Jennifer','Davis',       'j.davis@logisticsfirst.com',   26, 'Active',   '2019-11-01', '2024-10-25',  520000.00, 7,  'Enterprise'),
('MediaStream Network',        'Media',          'Mid-Market', 'USA', 'New York',    'New York City', 85000000,    650, 'Michael', 'Wilson',      'm.wilson@mediastream.com',     27, 'Active',   '2021-09-01', '2024-11-01',   85000.00, 8,  'Business'),
('EnergyWise Solutions',       'Energy',         'Enterprise', 'USA', 'Texas',       'Dallas',        550000000,   3800,'Karen',   'Taylor',      'k.taylor@energywise.com',      28, 'Active',   '2020-06-01', '2024-09-15',  275000.00, 7,  'Enterprise'),
('PharmaTech Industries',      'Pharmaceutical', 'Enterprise', 'USA', 'New Jersey',  'Newark',        1800000000,  9500,'Daniel',  'Anderson',    'd.anderson@pharmatech.com',    20, 'Active',   '2019-03-01', '2024-11-10',  780000.00, 8,  'Enterprise'),
('CloudFirst Startup',         'Technology',     'SMB',        'USA', 'California',  'San Jose',      8500000,      85,  'Emily',   'Johnson',     'e.johnson@cloudfirst.io',      21, 'Active',   '2022-03-15', '2024-10-30',   18000.00, 9,  'Starter'),
('DataDriven Agency',          'Marketing',      'SMB',        'USA', 'New York',    'Brooklyn',      3200000,      28,  'Tom',     'Harris',      't.harris@datadriven.com',      22, 'Active',   '2022-06-01', '2024-10-15',   12000.00, 8,  'Starter'),
('FinTech Ventures',           'Finance',        'Mid-Market', 'USA', 'California',  'Los Angeles',   45000000,    280, 'Rachel',  'Lee',         'r.lee@fintechventures.com',    23, 'Active',   '2021-04-01', '2024-11-01',   65000.00, 9,  'Growth'),
('BioResearch Institute',      'Research',       'Mid-Market', 'USA', 'California',  'San Diego',     38000000,    320, 'Mark',    'Martinez',    'm.martinez@bioresearch.org',   24, 'Active',   '2021-07-15', '2024-10-20',   55000.00, 7,  'Growth'),
('SportsTech Pro',             'Sports/Tech',    'SMB',        'USA', 'Colorado',    'Denver',        5500000,      45,  'Chris',   'Robinson',    'c.robinson@sportstech.com',    25, 'Active',   '2022-09-01', '2024-09-30',    9500.00, 8,  'Starter'),
('InsureNow Platform',         'Insurance',      'Mid-Market', 'USA', 'Connecticut', 'Hartford',      62000000,    480, 'Lisa',    'Clark',       'l.clark@insurenow.com',        26, 'Active',   '2020-12-01', '2024-11-05',   75000.00, 6,  'Business'),
('AgroTech Innovations',       'Agriculture',    'Mid-Market', 'USA', 'Iowa',        'Des Moines',    28000000,    195, 'Kevin',   'Lewis',       'k.lewis@agrotech.com',         27, 'Active',   '2022-01-15', '2024-10-25',   35000.00, 8,  'Growth'),
('TravelEase Systems',         'Travel',         'Mid-Market', 'USA', 'Florida',     'Miami',         55000000,    420, 'Amanda',  'Walker',      'a.walker@travelease.com',      28, 'Active',   '2021-10-01', '2024-10-15',   68000.00, 7,  'Business'),
('LegalTech Partners',         'Legal',          'SMB',        'USA', 'New York',    'Manhattan',     7200000,      58,  'Brian',   'Hall',        'b.hall@legaltech.com',         20, 'Active',   '2022-05-01', '2024-11-01',   14500.00, 8,  'Starter'),
('CyberGuard Security',        'Cybersecurity',  'Mid-Market', 'USA', 'Virginia',    'Arlington',     42000000,    315, 'Sarah',   'Young',       's.young@cyberguard.com',       21, 'Active',   '2021-02-15', '2024-10-30',   62000.00, 9,  'Growth'),
-- International customers
('Acme Digital UK',            'Technology',     'Enterprise', 'UK',  'England',     'London',        380000000,   2800,'Oliver',  'Smith',       'o.smith@acmedigital.co.uk',    22, 'Active',   '2020-08-01', '2024-11-01',  295000.00, 8,  'Enterprise'),
('NordicData AB',              'Technology',     'Mid-Market', 'Sweden','Stockholm County','Stockholm', 75000000,  580, 'Erik',    'Johansson',   'e.johansson@nordicdata.se',    23, 'Active',   '2021-05-15', '2024-10-20',   88000.00, 9,  'Business'),
('Deutsche Analytics GmbH',    'Finance',        'Enterprise', 'Germany','Bavaria',  'Munich',        620000000,   4200,'Hans',    'Mueller',     'h.mueller@deutscheanalyt.de',  24, 'Active',   '2019-10-01', '2024-09-30',  415000.00, 7,  'Enterprise'),
('TechIndia Pvt Ltd',          'Technology',     'Mid-Market', 'India','Karnataka',  'Bangalore',     95000000,    850, 'Priya',   'Sharma',      'p.sharma@techindia.in',        25, 'Active',   '2021-03-01', '2024-11-05',  112000.00, 8,  'Business'),
('AusBiz Solutions',           'Consulting',     'Mid-Market', 'Australia','NSW',    'Sydney',        58000000,    410, 'Jake',    'Wilson',      'j.wilson@ausbiz.com.au',       26, 'Active',   '2021-08-15', '2024-10-25',   72000.00, 8,  'Business'),
-- Churned customers (historical)
('OldMedia Corp',              'Media',          'Mid-Market', 'USA', 'New York',    'New York City', 42000000,    310, 'Paul',    'Brown',       'p.brown@oldmedia.com',         27, 'Churned',  '2020-01-01', '2023-01-15',   45000.00, 4,  'Business'),
('StartupX Inc',               'Technology',     'SMB',        'USA', 'California',  'San Francisco', 2500000,      18,  'Mike',    'Taylor',      'm.taylor@startupx.com',        28, 'Churned',  '2021-06-01', '2022-12-01',    6000.00, 3,  'Starter'),
('LegacySystems Ltd',          'Manufacturing',  'Enterprise', 'USA', 'Ohio',        'Cleveland',     280000000,   2100,'Frank',   'Johnson',     'f.johnson@legacysys.com',      20, 'Churned',  '2019-01-01', '2022-06-30',  185000.00, 2,  'Enterprise'),
-- Prospects
('FutureBank Corp',            'Finance',        'Enterprise', 'USA', 'New York',    'New York City', 1500000000,  9000,'Anna',    'Peterson',    'a.peterson@futurebank.com',    21, 'Prospect', NULL,          '2024-11-01',    0.00,    NULL, NULL),
('GreenEnergy Inc',            'Energy',         'Mid-Market', 'USA', 'California',  'Los Angeles',   85000000,    620, 'Tom',     'Green',       't.green@greenenergy.com',      22, 'Prospect', NULL,          '2024-10-30',    0.00,    NULL, NULL),
-- More Active Customers
('AutoDrive Technologies',     'Automotive',     'Enterprise', 'USA', 'Michigan',    'Detroit',       720000000,   4800,'Carlos',  'Rodriguez',   'c.rodriguez@autodrive.com',    23, 'Active',   '2020-11-01', '2024-10-15',  385000.00, 8,  'Enterprise'),
('SecureVault Inc',            'Cybersecurity',  'Mid-Market', 'USA', 'Washington',  'Seattle',       68000000,    510, 'Nina',    'Park',        'n.park@securevault.com',       24, 'Active',   '2021-11-15', '2024-11-01',   82000.00, 9,  'Business'),
('RealEstate Analytics',       'Real Estate',    'Mid-Market', 'USA', 'Florida',     'Orlando',       48000000,    360, 'Helen',   'Thomas',      'h.thomas@reestateanalyt.com',  25, 'Active',   '2022-02-01', '2024-10-20',   55000.00, 7,  'Growth'),
('BankNorth Regional',         'Finance',        'Enterprise', 'USA', 'Minnesota',   'Minneapolis',   890000000,   5600,'Walter',  'Nelson',      'w.nelson@banknorth.com',       26, 'Active',   '2019-07-01', '2024-09-30',  560000.00, 7,  'Enterprise'),
('PublicHealth Agency',        'Government',     'Enterprise', 'USA', 'DC',          'Washington DC', 320000000,   2400,'Grace',   'Kim',         'g.kim@publichealth.gov',       27, 'Active',   '2020-04-15', '2024-11-05',  198000.00, 8,  'Business'),
('SpaceData Corp',             'Aerospace',      'Mid-Market', 'USA', 'Florida',     'Cape Canaveral',95000000,    680, 'Neil',    'Armstrong',   'n.armstrong@spacedata.com',    28, 'Active',   '2021-12-01', '2024-10-25',  118000.00, 9,  'Business'),
('FoodChain Analytics',        'Food & Beverage','Mid-Market', 'USA', 'Wisconsin',   'Milwaukee',     52000000,    390, 'Betty',   'White',       'b.white@foodchain.com',        20, 'Active',   '2022-04-15', '2024-11-01',   58000.00, 8,  'Growth'),
('TelecomNest Inc',            'Telecom',        'Enterprise', 'USA', 'New Jersey',  'Newark',        1100000000,  7200,'Victor',  'Zhang',       'v.zhang@telecomenst.com',      21, 'Active',   '2020-02-01', '2024-10-30',  620000.00, 6,  'Enterprise'),
('HospitalGroup National',     'Healthcare',     'Enterprise', 'USA', 'Tennessee',   'Nashville',     380000000,   3100,'Carol',   'Jones',       'c.jones@hospitalgroup.com',    22, 'Active',   '2019-09-15', '2024-09-15',  295000.00, 8,  'Enterprise'),
('EdTech Startup',             'Education',      'SMB',        'USA', 'California',  'Berkeley',      4800000,      38,  'Ryan',    'O''Brien',    'r.obrien@edtechstart.com',     23, 'Active',   '2023-01-15', '2024-11-01',    8500.00, 9,  'Starter');
