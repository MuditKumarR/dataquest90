-- ============================================================
-- DATAVERSE INC. — PRODUCTS (120 rows)
-- ============================================================

DROP TABLE IF EXISTS products CASCADE;

CREATE TABLE products (
    product_id       SERIAL PRIMARY KEY,
    product_name     VARCHAR(200) NOT NULL,
    product_code     VARCHAR(20)  UNIQUE NOT NULL,
    category         VARCHAR(50)  NOT NULL,
    subcategory      VARCHAR(50),
    unit_price       NUMERIC(10,2) NOT NULL,
    unit_cost        NUMERIC(10,2) NOT NULL,
    stock_quantity   INT DEFAULT 0,
    reorder_level    INT DEFAULT 50,
    supplier_name    VARCHAR(100),
    is_active        BOOLEAN DEFAULT TRUE,
    launch_date      DATE,
    description      TEXT,
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO products (product_name, product_code, category, subcategory, unit_price, unit_cost, stock_quantity, reorder_level, supplier_name, launch_date) VALUES
-- Data Platform Products
('DataVerse Core Platform',        'DV-CORE-001', 'Software',     'Platform',    25000.00, 8000.00,  500, 50, 'Internal',           '2018-01-01'),
('DataVerse Enterprise Suite',     'DV-ENT-001',  'Software',     'Platform',    75000.00,20000.00,  200, 20, 'Internal',           '2019-06-01'),
('DataVerse Analytics Module',     'DV-ANA-001',  'Software',     'Analytics',   15000.00, 4500.00,  800, 80, 'Internal',           '2019-01-01'),
('DataVerse AI Accelerator',       'DV-AI-001',   'Software',     'AI/ML',       45000.00,12000.00,  150, 15, 'Internal',           '2021-03-01'),
('DataVerse Data Catalog',         'DV-CAT-001',  'Software',     'Governance',  18000.00, 5500.00,  350, 35, 'Internal',           '2020-06-01'),
('DataVerse Pipeline Builder',     'DV-PIPE-001', 'Software',     'Engineering', 22000.00, 7000.00,  280, 28, 'Internal',           '2020-09-01'),
('DataVerse Quality Engine',       'DV-QE-001',   'Software',     'Quality',     12000.00, 3800.00,  420, 42, 'Internal',           '2021-01-01'),
('DataVerse Governance Framework', 'DV-GOV-001',  'Software',     'Governance',  35000.00,10000.00,  180, 18, 'Internal',           '2021-06-01'),
-- Cloud Services
('Cloud Storage - Basic',          'CS-STOR-001', 'Cloud Service','Storage',       500.00,   150.00, 9999, 100,'AWS',                '2019-01-01'),
('Cloud Storage - Pro',            'CS-STOR-002', 'Cloud Service','Storage',      2500.00,   700.00, 9999,  50,'AWS',                '2019-01-01'),
('Cloud Compute - Standard',       'CS-COMP-001', 'Cloud Service','Compute',      1200.00,   380.00, 9999, 100,'AWS',                '2019-01-01'),
('Cloud Compute - High Performance','CS-COMP-002','Cloud Service','Compute',      4500.00,  1200.00, 9999,  50,'AWS',                '2019-01-01'),
('Cloud ML Training Jobs',         'CS-ML-001',   'Cloud Service','AI/ML',        8000.00,  2200.00, 9999,  20,'AWS',                '2021-01-01'),
-- Consulting Services
('Data Strategy Consulting',       'CON-STR-001', 'Consulting',   'Strategy',    15000.00, 5000.00, 9999,   0,'Internal',           '2018-06-01'),
('Data Engineering Consulting',    'CON-ENG-001', 'Consulting',   'Engineering', 12000.00, 4000.00, 9999,   0,'Internal',           '2018-06-01'),
('Analytics Consulting',           'CON-ANA-001', 'Consulting',   'Analytics',   10000.00, 3500.00, 9999,   0,'Internal',           '2018-06-01'),
('AI/ML Consulting',               'CON-AI-001',  'Consulting',   'AI/ML',       18000.00, 6000.00, 9999,   0,'Internal',           '2021-01-01'),
('Data Architecture Review',       'CON-ARC-001', 'Consulting',   'Architecture',25000.00, 8000.00, 9999,   0,'Internal',           '2019-01-01'),
-- Training Products
('SQL Foundations Course',         'TRN-SQL-001', 'Training',     'Course',       1200.00,   200.00, 9999,   0,'Internal',           '2020-01-01'),
('Advanced SQL Workshop',          'TRN-SQL-002', 'Training',     'Workshop',     2500.00,   400.00, 9999,   0,'Internal',           '2020-06-01'),
('Data Engineering Bootcamp',      'TRN-DE-001',  'Training',     'Bootcamp',     5000.00,   800.00, 9999,   0,'Internal',           '2021-01-01'),
('Snowflake Certification Prep',   'TRN-SF-001',  'Training',     'Course',       1800.00,   300.00, 9999,   0,'Snowflake',          '2021-06-01'),
('dbt Fundamentals Training',      'TRN-DBT-001', 'Training',     'Course',       1500.00,   250.00, 9999,   0,'dbt Labs',           '2022-01-01'),
('AI for Data Teams',              'TRN-AI-001',  'Training',     'Workshop',     3500.00,   600.00, 9999,   0,'Internal',           '2022-06-01'),
-- Hardware
('High-Perf Workstation',          'HW-WS-001',   'Hardware',     'Workstation', 4500.00,  3000.00,   80,  20,'Dell',               '2020-01-01'),
('Data Server Rack Unit',          'HW-SRV-001',  'Hardware',     'Server',     18000.00, 12000.00,   40,  10,'HP',                 '2020-01-01'),
('NVMe SSD Storage Array',         'HW-SSD-001',  'Hardware',     'Storage',     8500.00,  5500.00,   60,  15,'Samsung',            '2021-01-01'),
('Network Switch 48-Port',         'HW-NET-001',  'Hardware',     'Network',     2800.00,  1800.00,   50,  10,'Cisco',              '2020-01-01'),
-- Add-on Modules
('Advanced Reporting Add-on',      'ADD-REP-001', 'Software',     'Add-on',      5000.00,  1500.00,  600,  60,'Internal',           '2020-01-01'),
('Real-time Streaming Add-on',     'ADD-STR-001', 'Software',     'Add-on',      8000.00,  2400.00,  300,  30,'Internal',           '2021-01-01'),
('Security & Compliance Add-on',   'ADD-SEC-001', 'Software',     'Add-on',      6500.00,  2000.00,  400,  40,'Internal',           '2020-06-01'),
('Multi-tenant Add-on',            'ADD-MT-001',  'Software',     'Add-on',      9000.00,  2700.00,  200,  20,'Internal',           '2021-06-01'),
('SSO Integration Pack',           'ADD-SSO-001', 'Software',     'Integration', 3500.00,  1000.00,  500,  50,'Internal',           '2019-06-01'),
('Salesforce Connector',           'INT-SF-001',  'Software',     'Integration', 4500.00,  1300.00,  350,  35,'Internal',           '2020-01-01'),
('Tableau Connector',              'INT-TAB-001', 'Software',     'Integration', 3800.00,  1100.00,  420,  42,'Internal',           '2020-06-01'),
('Power BI Connector',             'INT-PBI-001', 'Software',     'Integration', 3800.00,  1100.00,  450,  45,'Internal',           '2020-09-01'),
('dbt Core Integration',           'INT-DBT-001', 'Software',     'Integration', 4200.00,  1200.00,  280,  28,'dbt Labs',           '2022-01-01'),
('Airflow Integration Pack',       'INT-AF-001',  'Software',     'Integration', 4800.00,  1400.00,  260,  26,'Apache',             '2022-03-01'),
-- Support Plans
('Basic Support Plan - Annual',    'SUP-BAS-001', 'Support',      'Support',     2000.00,   600.00, 9999,   0,'Internal',           '2018-01-01'),
('Professional Support - Annual',  'SUP-PRO-001', 'Support',      'Support',     6000.00,  1800.00, 9999,   0,'Internal',           '2018-01-01'),
('Enterprise Support - Annual',    'SUP-ENT-001', 'Support',      'Support',    15000.00,  4500.00, 9999,   0,'Internal',           '2018-01-01'),
('Dedicated Support Engineer',     'SUP-DED-001', 'Support',      'Support',    48000.00, 14000.00, 9999,   0,'Internal',           '2020-01-01');
