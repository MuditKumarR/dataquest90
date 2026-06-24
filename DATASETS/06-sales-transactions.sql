-- ============================================================
-- DATAVERSE INC. — SALES TRANSACTIONS (aggregated, 500+ rows)
-- ============================================================

DROP TABLE IF EXISTS sales_transactions CASCADE;

CREATE TABLE sales_transactions (
    transaction_id  SERIAL PRIMARY KEY,
    order_id        INT REFERENCES orders(order_id),
    transaction_date DATE NOT NULL,
    sales_rep_id    INT REFERENCES employees(employee_id),
    customer_id     INT REFERENCES customers(customer_id),
    product_id      INT REFERENCES products(product_id),
    region          VARCHAR(50),
    channel         VARCHAR(30),
    quantity        INT NOT NULL DEFAULT 1,
    unit_price      NUMERIC(10,2) NOT NULL,
    discount_amt    NUMERIC(10,2) DEFAULT 0,
    revenue         NUMERIC(12,2) NOT NULL,
    cost            NUMERIC(12,2) NOT NULL,
    gross_profit    NUMERIC(12,2) GENERATED ALWAYS AS (revenue - cost) STORED,
    fiscal_year     INT,
    fiscal_quarter  INT,
    fiscal_month    INT
);

-- Populate from order_items (simplified for direct querying)
INSERT INTO sales_transactions (order_id, transaction_date, sales_rep_id, customer_id, product_id, region, channel, quantity, unit_price, discount_amt, revenue, cost, fiscal_year, fiscal_quarter, fiscal_month)
SELECT 
    o.order_id,
    o.order_date,
    o.sales_rep_id,
    o.customer_id,
    oi.product_id,
    CASE 
        WHEN e.location IN ('New York','Chicago') THEN 'East'
        WHEN e.location IN ('Austin','Dallas') THEN 'Central'
        WHEN e.location IN ('San Francisco') THEN 'West'
        ELSE 'East'
    END AS region,
    'Direct Sales' AS channel,
    oi.quantity,
    oi.unit_price,
    ROUND(oi.quantity * oi.unit_price * (oi.discount_pct / 100), 2) AS discount_amt,
    oi.line_total AS revenue,
    ROUND(oi.line_total * (p.unit_cost / p.unit_price), 2) AS cost,
    EXTRACT(YEAR FROM o.order_date)::INT AS fiscal_year,
    EXTRACT(QUARTER FROM o.order_date)::INT AS fiscal_quarter,
    EXTRACT(MONTH FROM o.order_date)::INT AS fiscal_month
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN employees e ON o.sales_rep_id = e.employee_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status IN ('Delivered', 'Shipped', 'Processing');

-- Add channel-attributed transactions (Marketing/Partner)
INSERT INTO sales_transactions (order_id, transaction_date, sales_rep_id, customer_id, product_id, region, channel, quantity, unit_price, discount_amt, revenue, cost, fiscal_year, fiscal_quarter, fiscal_month) VALUES
(7,  '2022-04-01', 20, 7,  3, 'East',    'Partner',         1, 15000.00,  750.00, 14250.00,  4500.00, 2022, 2, 4),
(15, '2022-08-01', 25, 15, 19,'West',    'Digital',         2,  1200.00,    0.00,  2400.00,   400.00, 2022, 3, 8),
(25, '2023-01-10', 20, 1,  4, 'East',    'Partner',         1, 45000.00, 2250.00, 42750.00, 12000.00, 2023, 1, 1),
(35, '2023-07-15', 25, 33, 3, 'Central', 'Partner',         2, 15000.00,  750.00, 29250.00,  9000.00, 2023, 3, 7),
(49, '2024-01-10', 20, 1,  4, 'East',    'Partner',         1, 45000.00, 2250.00, 42750.00, 12000.00, 2024, 1, 1),
(50, '2024-02-01', 21, 2,  8, 'East',    'Digital',         1, 35000.00, 1750.00, 33250.00, 10000.00, 2024, 1, 2);
