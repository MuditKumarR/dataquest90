# 🎯 MISSION 13 — Analytics Use Cases

```
┌────────────────────────────────────────────────────────────────────┐
│  LEVEL 7: Data Architect / Analytics Lead                          │
│  XP AVAILABLE: 800                                              │
│  CONCEPTS: Headcount · Attrition · Revenue · Retention           │
│            · Customer Lifetime Value · Sales Funnel              │
│            · Learning Analytics · Executive Dashboards           │
│  ESTIMATED TIME: 80 minutes                                       │
└────────────────────────────────────────────────────────────────────┘
```

---

## 📧 The Executive Ask

> **From:** Angela Davis (Chief Data Officer)
> **To:** You (Analytics Lead)
> **Subject:** Build our executive analytics suite
>
> *"The executive team wants a single source of truth for the metrics that run this company: headcount, attrition, revenue, retention, customer lifetime value, sales funnel conversion, and learning ROI.*
>
> *You now have every SQL skill needed. This mission is about applying them to real business questions — the kind that get presented to the board.*
>
> *Let's turn data into decisions.*
>
> *— Angela"*

---

## 🧭 Why This Matters (The Real World)

This is where everything converges. The aggregations, joins, CTEs, and window functions you've learned now solve **real executive analytics**. These exact queries appear in every analytics interview and BI dashboard.

| Role | How they use these |
|------|--------------------|
| **Analytics Engineer** | Builds these as dbt models |
| **Data Analyst** | Powers dashboards (Tableau/Power BI) |
| **Data Architect** | Designs the semantic layer |
| **BI Developer** | Materializes for performance |

---

## 📚 Use Case 1 — Headcount Analytics

```sql
-- Current headcount by department
SELECT 
    d.department_name,
    COUNT(*) FILTER (WHERE e.status = 'Active') AS active_headcount,
    COUNT(*) FILTER (WHERE e.employment_type = 'Full-Time') AS full_time,
    COUNT(*) FILTER (WHERE e.employment_type = 'Contract') AS contractors,
    ROUND(AVG(e.salary), 0) AS avg_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY active_headcount DESC;

-- Headcount growth over time (cumulative hires by month)
SELECT 
    DATE_TRUNC('month', hire_date) AS month,
    COUNT(*) AS hires,
    SUM(COUNT(*)) OVER (ORDER BY DATE_TRUNC('month', hire_date)) AS cumulative_headcount
FROM employees
GROUP BY DATE_TRUNC('month', hire_date)
ORDER BY month;
```

---

## 📚 Use Case 2 — Attrition Analysis

Attrition (turnover) is one of the most-watched HR metrics.

```sql
-- Attrition rate by department
WITH dept_stats AS (
    SELECT 
        d.department_name,
        COUNT(*) AS total_employees,
        COUNT(*) FILTER (WHERE e.status = 'Terminated') AS terminated
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    GROUP BY d.department_name
)
SELECT 
    department_name,
    total_employees,
    terminated,
    ROUND(100.0 * terminated / total_employees, 1) AS attrition_rate_pct
FROM dept_stats
ORDER BY attrition_rate_pct DESC;

-- Flight risk: high performers who might leave (from hr_analytics_summary)
SELECT 
    full_name,
    department_name,
    flight_risk_score,
    engagement_score,
    tenure_years
FROM hr_analytics_summary
WHERE flight_risk_score >= 7
  AND engagement_score <= 5
ORDER BY flight_risk_score DESC;
```

---

## 📚 Use Case 3 — Revenue Analytics

```sql
-- Revenue trend with month-over-month growth
WITH monthly AS (
    SELECT 
        DATE_TRUNC('month', sale_date) AS month,
        SUM(revenue) AS revenue
    FROM sales_transactions
    GROUP BY DATE_TRUNC('month', sale_date)
)
SELECT 
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS prev_month,
    ROUND(100.0 * (revenue - LAG(revenue) OVER (ORDER BY month)) 
          / NULLIF(LAG(revenue) OVER (ORDER BY month), 0), 1) AS mom_growth_pct
FROM monthly
ORDER BY month;

-- Top sales reps by revenue with ranking
SELECT 
    e.first_name || ' ' || e.last_name AS rep,
    SUM(st.revenue) AS total_revenue,
    SUM(st.gross_profit) AS total_profit,
    RANK() OVER (ORDER BY SUM(st.revenue) DESC) AS revenue_rank
FROM sales_transactions st
JOIN employees e ON st.sales_rep_id = e.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY total_revenue DESC;
```

---

## 📚 Use Case 4 — Customer Retention & Churn

```sql
-- Retention status breakdown
SELECT 
    customer_status,
    COUNT(*) AS customers,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct_of_base,
    ROUND(AVG(lifetime_value), 0) AS avg_ltv,
    ROUND(AVG(nps_score), 1) AS avg_nps
FROM customers
GROUP BY customer_status
ORDER BY customers DESC;

-- Churn risk: customers inactive for 90+ days
SELECT 
    company_name,
    industry,
    last_activity_date,
    CURRENT_DATE - last_activity_date AS days_inactive,
    lifetime_value
FROM customers
WHERE customer_status = 'Active'
  AND last_activity_date < CURRENT_DATE - INTERVAL '90 days'
ORDER BY lifetime_value DESC;
```

---

## 📚 Use Case 5 — Customer Lifetime Value (CLV)

```sql
-- CLV by customer with segmentation (NTILE quartiles)
WITH customer_value AS (
    SELECT 
        c.customer_id,
        c.company_name,
        c.industry,
        c.contract_tier,
        COALESCE(SUM(st.revenue), 0) AS total_revenue,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    LEFT JOIN sales_transactions st ON o.order_id = st.order_id
    GROUP BY c.customer_id, c.company_name, c.industry, c.contract_tier
)
SELECT 
    company_name,
    industry,
    contract_tier,
    total_revenue,
    total_orders,
    NTILE(4) OVER (ORDER BY total_revenue DESC) AS value_quartile
FROM customer_value
ORDER BY total_revenue DESC;
```

---

## 📚 Use Case 6 — Sales Funnel & Recruitment Funnel

```sql
-- Recruitment funnel conversion
WITH funnel AS (
    SELECT 
        COUNT(*) AS applied,
        COUNT(*) FILTER (WHERE stage NOT IN ('Applied','Rejected','Withdrawn')) AS screened,
        COUNT(*) FILTER (WHERE stage IN ('Technical Interview','Onsite','Offer','Hired')) AS interviewed,
        COUNT(*) FILTER (WHERE stage IN ('Offer','Hired')) AS offered,
        COUNT(*) FILTER (WHERE stage = 'Hired') AS hired
    FROM recruitment
)
SELECT 
    applied,
    screened,
    interviewed,
    offered,
    hired,
    ROUND(100.0 * hired / NULLIF(applied, 0), 1) AS applied_to_hire_pct,
    ROUND(100.0 * offered / NULLIF(interviewed, 0), 1) AS interview_to_offer_pct
FROM funnel;
```

---

## 📚 Use Case 7 — Learning Analytics

```sql
-- Course completion rates and ROI
SELECT 
    c.course_name,
    c.category,
    COUNT(le.enrollment_id) AS enrollments,
    COUNT(*) FILTER (WHERE le.status = 'Completed') AS completions,
    ROUND(100.0 * COUNT(*) FILTER (WHERE le.status = 'Completed') 
          / NULLIF(COUNT(le.enrollment_id), 0), 1) AS completion_rate_pct,
    ROUND(AVG(le.final_score) FILTER (WHERE le.status = 'Completed'), 1) AS avg_score
FROM courses c
LEFT JOIN learning_enrollments le ON c.course_id = le.course_id
GROUP BY c.course_id, c.course_name, c.category
ORDER BY enrollments DESC;
```

---

## 📚 Use Case 8 — Executive Dashboard (One Query)

The "single pane of glass" — key company KPIs in one result using scalar subqueries.

```sql
SELECT 
    (SELECT COUNT(*) FROM employees WHERE status = 'Active')        AS active_employees,
    (SELECT COUNT(*) FROM customers WHERE customer_status = 'Active') AS active_customers,
    (SELECT ROUND(SUM(revenue), 0) FROM sales_transactions
        WHERE sale_date >= DATE_TRUNC('year', CURRENT_DATE))       AS ytd_revenue,
    (SELECT ROUND(SUM(gross_profit), 0) FROM sales_transactions
        WHERE sale_date >= DATE_TRUNC('year', CURRENT_DATE))       AS ytd_profit,
    (SELECT ROUND(AVG(nps_score), 1) FROM customers)              AS avg_nps,
    (SELECT COUNT(*) FROM recruitment WHERE stage = 'Hired')      AS total_hires,
    (SELECT ROUND(100.0 * COUNT(*) FILTER (WHERE status='Terminated')
        / COUNT(*), 1) FROM employees)                            AS attrition_rate_pct;
```

This single row is what powers an executive dashboard's KPI cards.

---

## 🏋️ Exercises

1. Build a headcount-by-location report with active vs inactive counts.
2. Calculate attrition rate by tenure band (0-1yr, 1-3yr, 3-5yr, 5+yr).
3. Build a quarterly revenue report with QoQ growth % using `LAG`.
4. Identify the top 10 customers by lifetime value with their order counts.
5. Segment customers into CLV quartiles and show avg revenue per quartile.
6. Build the recruitment funnel by department.
7. Calculate course completion rate and average score by course category.
8. Write a single-query executive dashboard with 6+ company KPIs.

→ Solutions: [SOLUTIONS/MISSION-13.md](../../SOLUTIONS/MISSION-13.md)

---

## 🧪 Quiz

→ [QUIZZES/MISSION-13-quiz.md](../../QUIZZES/MISSION-13-quiz.md)

---

## 🔥 Challenge (Bonus 150 XP)

> Angela asks: *"Build the complete DataVerse Executive Scorecard: a set of views (`vw_headcount`, `vw_revenue`, `vw_retention`, `vw_funnel`) plus one master dashboard query. This becomes our board reporting layer."*

---

## 🎓 What You Learned

```
✓ Headcount analytics + cumulative growth
✓ Attrition rate + flight risk scoring
✓ Revenue trends with MoM/QoQ growth
✓ Retention & churn risk analysis
✓ Customer Lifetime Value + quartile segmentation
✓ Funnel conversion analysis
✓ Learning analytics & completion rates
✓ Single-query executive dashboards
```

**XP EARNED: 800** (+150 bonus for the challenge)

---

## ➡️ Next Mission

The final frontier — how SQL powers AI, RAG, and agentic systems...

→ [MISSION 14 — SQL for AI](../MISSION-14/README.md)
