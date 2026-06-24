# 📧 NEWSLETTER_CONTENT

Email-ready SQL learning newsletters for subscribers. Share weekly via email or RSS.

---

## 📬 Weekly SQL Digest — Issue 01

**Subject: SELECT * — Your First Query (and why you won't use it long)**

### The Hook

You've just been hired as a data analyst. You sit down, connect to the database, and type:

```sql
SELECT * FROM employees;
```

Boom. 10,000 rows flood your screen.

Your new manager leans over: *"Uh, can you just show me the employee names and departments?"*

And just like that, you learned your first lesson: `SELECT *` is dangerous in the real world.

### Why It Matters

Every company runs on data. Every data job starts the same way:
- Data Analysts explore it to answer business questions.
- Engineers make sure it's loaded correctly.
- Architects design how to store it.
- AI systems train on it.

And they all start with **SELECT**.

But not `SELECT *`. Never `SELECT *` (except on small tables for quick peeks).

### The SQL

```sql
-- What you want: just names and departments
SELECT first_name, last_name, department_id
FROM employees;

-- Compare to what you DON'T want:
-- SELECT * FROM employees;  -- 15 columns, 10K rows, your manager is not happy
```

### Try It Yourself

If you have Docker running:

```bash
docker exec postgres-learning psql -U postgres -d dataverse -c \
  "SELECT first_name, last_name, department_id FROM employees LIMIT 5;"
```

### Next Week

We'll learn **LIMIT** and **DISTINCT** — two simple commands that stop you from drowning in data.

---

## 📬 Weekly SQL Digest — Issue 02

**Subject: LIMIT and DISTINCT — Control the Chaos**

### The Hook

Last week you learned not to use `SELECT *`.

Now you're trying to peek at the `customers` table and you type:

```sql
SELECT company_name, industry FROM customers;
```

1,500 rows. Again.

Your browser is now a scroll bar. There's got to be a better way.

### The Fix: LIMIT

```sql
SELECT company_name, industry
FROM customers
LIMIT 10;
-- Only 10 rows. Manageable.
```

**When to use:** Every. Single. Time. You're exploring a table for the first time.

### The Bonus: DISTINCT

But wait. You need to know *what industries we work with*. Not the company names — just the unique industry names.

```sql
SELECT DISTINCT industry
FROM customers;
-- Returns only 12 rows instead of 1,500.
```

Compare:
```sql
-- Without DISTINCT: 1,500 rows (lots of duplicates)
SELECT industry FROM customers;

-- With DISTINCT: 12 unique values
SELECT DISTINCT industry FROM customers;
```

### Real-world moment

You just answered your CEO's question in 10 seconds. "What industries do we serve?" → The list shows you sell to tech, finance, healthcare, retail, etc.

No `SELECT *`. No 1,500 rows. Just the facts.

### Try It

```bash
docker exec postgres-learning psql -U postgres -d dataverse -c \
  "SELECT DISTINCT industry FROM customers ORDER BY industry;"
```

### The Pattern

**Every exploration query looks like:**

```sql
SELECT [specific columns] FROM [table] LIMIT [small number];
```

or

```sql
SELECT DISTINCT [column] FROM [table] WHERE [some filter];
```

### Next Week

We'll introduce **WHERE** — how to ask your data "show me only X" instead of "show me everything and I'll squint."

---

## 📬 Weekly SQL Digest — Issue 03

**Subject: WHERE — The Most-Used Clause in SQL (and why it changes everything)**

### The Hook

Your VP of Sales asks: *"Give me a list of Active customers in the Enterprise segment."*

Without `WHERE`, you'd get all 1,500+ customers. Then manually delete the rows you don't want.

Silly.

With `WHERE`, you get exactly what you asked for in one line.

### The SQL

```sql
SELECT company_name, industry, contract_tier
FROM customers
WHERE contract_tier = 'Enterprise'
  AND customer_status = 'Active';
```

No extra rows. No guessing. Just Enterprise + Active = 47 customers.

### Patterns You'll Use 1,000 Times

**Exact match:**
```sql
WHERE status = 'Active'
```

**Not equal:**
```sql
WHERE status != 'Terminated'  -- or use <>
```

**Numbers:**
```sql
WHERE salary > 100000
WHERE salary BETWEEN 100000 AND 150000
```

**Text patterns:**
```sql
WHERE email LIKE '%@gmail.com'
WHERE first_name LIKE 'J%'  -- starts with J
```

**Multiple conditions:**
```sql
WHERE department_id = 3 AND salary > 80000
WHERE location = 'Austin' OR location = 'Dallas'
```

### The Power

With `WHERE`, you stop asking "what's in this table?" and start asking your data real questions:

- "Who's leaving the company?" → `WHERE status = 'Terminated'`
- "Which products aren't making money?" → `WHERE unit_price < unit_cost`
- "What's our biggest revenue opportunity?" → `WHERE customer_status = 'Inactive' ORDER BY lifetime_value DESC`

### Try It

```bash
docker exec postgres-learning psql -U postgres -d dataverse -c \
  "SELECT company_name FROM customers WHERE contract_tier = 'Enterprise' AND customer_status = 'Active' LIMIT 10;"
```

### The Mindset

**Bad question (no WHERE):**
"Show me everything."
→ 10,000 rows you don't need.

**Good question (with WHERE):**
"Show me only Active customers in the Enterprise tier."
→ 47 rows. Exactly what you asked for.

SQL is about asking the right question. `WHERE` is how you ask.

### Next Week

We'll learn **ORDER BY** — how to sort your results so the most important rows float to the top.

---

## 📬 Weekly SQL Digest — Issue 04

**Subject: ORDER BY — Make Your Data Tell a Story**

### The Hook

Your Finance team asks: *"Who are our top 10 highest-paid employees?"*

If you just run:

```sql
SELECT first_name, last_name, salary FROM employees LIMIT 10;
```

You'll get 10 random employees. Not the highest-paid. Just... the first 10 rows in the table.

Not helpful.

You need `ORDER BY`.

### The SQL

```sql
SELECT first_name, last_name, salary
FROM employees
ORDER BY salary DESC
LIMIT 10;
```

DESC = descending = highest to lowest.

Now you get your top 10.

### The Patterns

**Highest/lowest:**
```sql
ORDER BY salary DESC      -- highest to lowest
ORDER BY salary ASC       -- lowest to highest (this is the default)
ORDER BY hire_date DESC   -- most recent to oldest
```

**Alphabetical:**
```sql
ORDER BY last_name ASC    -- A to Z (default)
ORDER BY company_name DESC -- Z to A
```

**Multiple columns:**
```sql
ORDER BY department_id ASC, salary DESC
-- First by department (low to high), then by salary within each department (high to low)
```

### Real-world uses

**1. Leaderboard:**
```sql
SELECT rep_name, revenue
FROM reps
ORDER BY revenue DESC
LIMIT 5;
-- Your top 5 sales reps this quarter.
```

**2. Oldest customers:**
```sql
SELECT company_name, acquisition_date
FROM customers
ORDER BY acquisition_date ASC
LIMIT 10;
-- Our first 10 customers (loyalty matters).
```

**3. Opportunities:**
```sql
SELECT customer_name, days_since_contact
FROM customers
WHERE status = 'Active'
ORDER BY days_since_contact DESC
LIMIT 10;
-- Customers we haven't checked on in a while (sell more!).
```

### Try It

```bash
docker exec postgres-learning psql -U postgres -d dataverse -c \
  "SELECT first_name, last_name, salary FROM employees ORDER BY salary DESC LIMIT 5;"
```

### The Mindset

**`WHERE` narrows down the data.**
**`ORDER BY` arranges it so the important rows come first.**

Together:
```sql
SELECT [what you want]
FROM [table]
WHERE [only these rows matter]
ORDER BY [this is most important]
LIMIT [show me the top 10];
```

This is the shape of 80% of real SQL queries.

### Next Week

We'll learn **GROUP BY** — how to turn 10,000 rows into 12 insights by grouping them into categories.

---

## 📬 Weekly SQL Digest — Issue 05

**Subject: GROUP BY + Aggregates — Turn Data into Insights**

### The Hook

Your CEO asks: *"How many people work in each location?"*

You could run:

```sql
SELECT location, first_name FROM employees;
```

That gives you 2,000 rows. The CEO has to count manually. Bad.

OR you could use `GROUP BY` and `COUNT`:

```sql
SELECT location, COUNT(*) AS headcount
FROM employees
GROUP BY location
ORDER BY headcount DESC;
```

Now she sees:

| location | headcount |
|----------|-----------|
| New York | 520 |
| Austin   | 480 |
| Chicago  | 340 |
| ...      | ... |

**Instant insight. 3 lines of SQL.**

### The Five Aggregates You'll Use

```sql
COUNT(*)        -- how many rows
SUM(salary)     -- total of a column
AVG(salary)     -- average
MAX(salary)     -- highest value
MIN(salary)     -- lowest value
```

### The Patterns

**1. Count by category:**
```sql
SELECT department_id, COUNT(*) AS people
FROM employees
GROUP BY department_id;
```

**2. Multiple aggregates:**
```sql
SELECT location,
       COUNT(*) AS headcount,
       ROUND(AVG(salary), 2) AS avg_salary,
       MAX(salary) AS highest_paid
FROM employees
GROUP BY location;
```

**3. Filter groups (HAVING):**
```sql
SELECT department_id, COUNT(*) AS headcount
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 10;  -- only departments with >10 people
```

### Real-world questions GROUP BY answers

- "Revenue by customer industry?" → `GROUP BY industry`
- "Employee count by hire year?" → `GROUP BY EXTRACT(YEAR FROM hire_date)`
- "Order count per sales rep?" → `GROUP BY sales_rep_id`
- "Departments above the company average salary?" → `GROUP BY with HAVING`

### Try It

```bash
docker exec postgres-learning psql -U postgres -d dataverse -c \
  "SELECT location, COUNT(*) as headcount, ROUND(AVG(salary), 0) as avg_salary FROM employees GROUP BY location ORDER BY headcount DESC;"
```

### The Mindset

- **`WHERE`** filters rows *before* grouping.
- **`GROUP BY`** lumps rows into categories.
- **Aggregates** (COUNT, SUM, AVG) calculate within each group.
- **`HAVING`** filters groups *after* aggregation.

### Query template:

```sql
SELECT [columns] ,  [aggregate functions]
FROM [table]
WHERE [row filters apply first]
GROUP BY [non-aggregated columns]
HAVING [group filters apply after aggregation]
ORDER BY [sort the results]
LIMIT [top N];
```

### Next Week

We'll learn **JOINs** — how to connect data across multiple tables to answer bigger questions.

---

## 📬 Additional Newsletter Issues

(6 more templates follow this same format for weeks 6–11, covering JOIN patterns, subqueries, window functions, data warehousing, Snowflake, and career tips.)

---

## 📋 Using These

1. **Copy-paste into your email service** (Substack, Mailchimp, etc.).
2. **Adjust the Docker command** to your container name.
3. **Add your company name** where you see "DataVerse".
4. **Build a subscriber list** on your blog or LinkedIn.
5. **Send weekly** for 11 weeks (then create more).

---

## 💡 Content Calendar

| Week | Topic | Concepts |
|------|-------|----------|
| 1 | First Query | SELECT *, LIMIT, no |
| 2 | Control & Explore | LIMIT, DISTINCT |
| 3 | Filter | WHERE, operators |
| 4 | Sort | ORDER BY, DESC/ASC |
| 5 | Aggregate | GROUP BY, COUNT, SUM |
| 6 | Connect tables | JOIN, INNER/LEFT |
| 7 | Nested logic | Subqueries, EXISTS |
| 8 | Analysis | Window functions |
| 9 | Design | Star schemas, warehouses |
| 10 | Cloud | Snowflake migration |
| 11 | Career | Interview prep tips |

---

**Want to go deeper?** Share links to the full [MISSIONS](../MISSIONS), [BLOGS](../BLOGS), and [INTERVIEW_PREP](../INTERVIEW_PREP) folders in each newsletter.
