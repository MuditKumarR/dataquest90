# 🎯 MISSION 01 — The CEO Wants Workforce Insights

```
┌────────────────────────────────────────────────────────────┐
│  LEVEL 1: Junior Data Analyst                              │
│  XP AVAILABLE: 200                                        │
│  CONCEPTS: SELECT · FROM · LIMIT · DISTINCT · ORDER BY    │
│  ESTIMATED TIME: 45 minutes                               │
└────────────────────────────────────────────────────────────┘
```

---

## 📧 The Email

> **From:** James Richardson (CEO)
> **To:** You (Junior Data Analyst)
> **Subject:** Need workforce numbers — board meeting tomorrow
>
> *"Welcome to the team! I'm walking into a board meeting tomorrow morning and I need to speak confidently about our people.*
>
> *Can you pull together some basic facts? How many people work here? What roles do we have? Where are they located? Nothing fancy — I just need to see the data.*
>
> *Your manager tells me the entire company runs on a PostgreSQL database called `dataverse`. Just open it and start looking around.*
>
> *— James"*

---

## 🧭 Why This Matters (The Real World)

Every data professional's first task is the same: **look at the data**.

Before you build dashboards, train AI models, or design warehouses, you need to answer the most basic question: *"What's actually in here?"*

| Role | How they use SELECT |
|------|---------------------|
| **Data Analyst** | Explores tables to understand the business |
| **Data Engineer** | Validates that pipelines loaded data correctly |
| **Analytics Engineer** | Previews source tables before modeling |
| **Architect** | Audits schema design and data shape |
| **AI Engineer** | Inspects training data before feeding models |

`SELECT` is the single most-used command in all of data. You will write it millions of times in your career.

---

## 📚 Concept 1 — SELECT and FROM

The two words that start almost every SQL query.

```sql
-- Show me everything from the employees table
SELECT * FROM employees;
```

- `SELECT` = "I want to see..."
- `*` = "...all columns..."
- `FROM employees` = "...from the employees table."

> ⚠️ **In the real world, never run `SELECT *` on huge tables.** It can return millions of rows and crash your session. We'll fix this with `LIMIT` below.

### Selecting Specific Columns

The CEO doesn't need every column. Be precise:

```sql
SELECT first_name, last_name, job_title
FROM employees;
```

This returns only 3 columns. Cleaner, faster, more professional.

---

## 📚 Concept 2 — LIMIT

`LIMIT` controls how many rows come back. Essential for exploration.

```sql
-- Just show me the first 5 employees
SELECT first_name, last_name, job_title
FROM employees
LIMIT 5;
```

**Why this matters:** When you first open an unfamiliar table, you `LIMIT 10` to peek at the shape of the data without overwhelming yourself.

---

## 📚 Concept 3 — DISTINCT

`DISTINCT` removes duplicate values. Perfect for "what are all the unique X?" questions.

```sql
-- What job titles exist in the company?
SELECT DISTINCT job_title
FROM employees;
```

```sql
-- What locations do we operate in?
SELECT DISTINCT location
FROM employees;
```

The CEO's question *"What roles do we have?"* is answered perfectly by `DISTINCT job_title`.

### DISTINCT on Multiple Columns

```sql
-- Unique combinations of location AND department
SELECT DISTINCT location, department_id
FROM employees;
```

> 💡 `DISTINCT` applies to the **entire row** of selected columns, not just the first one.

---

## 📚 Concept 4 — ORDER BY

Sort the results so they're readable.

```sql
-- Employees sorted by last name A→Z
SELECT first_name, last_name, salary
FROM employees
ORDER BY last_name ASC;
```

```sql
-- Highest paid employees first
SELECT first_name, last_name, salary
FROM employees
ORDER BY salary DESC
LIMIT 10;
```

- `ASC` = ascending (A→Z, low→high) — this is the default
- `DESC` = descending (Z→A, high→low)

> 💡 **`ORDER BY ... DESC LIMIT 10`** is the classic "Top 10" pattern you'll use constantly.

---

## ✅ Solving the CEO's Request

Here's the complete answer to James's email:

```sql
-- 1. How many people / what does the data look like?
SELECT employee_id, first_name, last_name, job_title, location
FROM employees
LIMIT 10;

-- 2. What roles do we have?
SELECT DISTINCT job_title
FROM employees
ORDER BY job_title;

-- 3. Where are people located?
SELECT DISTINCT location
FROM employees
ORDER BY location;

-- 4. Who are our highest-paid people? (the board always asks)
SELECT first_name, last_name, job_title, salary
FROM employees
ORDER BY salary DESC
LIMIT 5;
```

You just delivered your first executive report. 🎉

---

## 🏋️ Exercises

Try these yourself before checking [SOLUTIONS/MISSION-01.md](../../SOLUTIONS/MISSION-01.md).

1. Show the first 15 employees with only their `first_name`, `last_name`, and `email`.
2. List all distinct `employment_type` values in the company.
3. Show the 10 employees with the **lowest** salaries.
4. List all distinct combinations of `location` and `employment_type`.
5. Show every employee's `job_title` and `hire_date`, sorted by `hire_date` (oldest first).
6. How many distinct `department_id` values appear in the employees table? (Hint: use DISTINCT, then count the rows visually.)
7. Show the 3 most recently hired employees.

---

## 🧪 Quiz

→ [QUIZZES/MISSION-01-quiz.md](../../QUIZZES/MISSION-01-quiz.md)

---

## 🔥 Challenge (Bonus 50 XP)

> The CEO sends a follow-up: *"Actually, can you give me a single list showing our top 10 highest-paid employees, but I only want to see their full name (combined) and salary?"*

**Hint:** You can combine columns with `||`:
```sql
SELECT first_name || ' ' || last_name AS full_name, salary
FROM employees
ORDER BY salary DESC
LIMIT 10;
```

`AS full_name` gives the new column a friendly name. This is called an **alias** — you'll use it everywhere.

---

## 🎓 What You Learned

```
✓ SELECT — choose columns
✓ FROM — choose the table
✓ LIMIT — control row count
✓ DISTINCT — remove duplicates
✓ ORDER BY — sort results
✓ AS — alias / rename columns
✓ || — concatenate strings
```

**XP EARNED: 200** (+50 bonus if you completed the challenge)

---

## ➡️ Next Mission

The HR Director just noticed something strange in the headcount...

→ [MISSION 02 — HR Director Needs Employee Data](../MISSION-02/README.md)
