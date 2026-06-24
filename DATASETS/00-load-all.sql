-- ============================================================
-- DATAVERSE INC. — MASTER DATA LOADER
-- Run this file to load all datasets in correct order
-- Usage: psql -U postgres -d dataverse -f 00-load-all.sql
-- ============================================================

\echo '=============================================='
\echo ' DataVerse Inc. — Loading Business Datasets'
\echo '=============================================='

\i 01-departments.sql
\echo '✓ Departments loaded'

\i 02-employees.sql
\echo '✓ Employees loaded'

\i 03-products.sql
\echo '✓ Products loaded'

\i 04-customers.sql
\echo '✓ Customers loaded'

\i 05-orders.sql
\echo '✓ Orders loaded'

\i 06-sales-transactions.sql
\echo '✓ Sales Transactions loaded'

\i 07-attendance.sql
\echo '✓ Attendance loaded'

\i 08-performance-reviews.sql
\echo '✓ Performance Reviews loaded'

\i 09-recruitment.sql
\echo '✓ Recruitment loaded'

\i 10-learning.sql
\echo '✓ Learning Enrollments loaded'

\i 11-finance-budget.sql
\echo '✓ Finance Budget loaded'

\i 12-hr-analytics.sql
\echo '✓ HR Analytics loaded'

\echo ''
\echo '=============================================='
\echo ' DataVerse Inc. database ready!'
\echo ' Run: SELECT tablename FROM pg_tables WHERE schemaname = '"'"'public'"'"';'
\echo '=============================================='
