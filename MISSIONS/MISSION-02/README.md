# 🎯 MISSION 02 — HR Director Needs Employee Insights

```
┌────────────────────────────────────────────────────────────────────┐
│  LEVEL 1: Junior Data Analyst                                      │
│  XP AVAILABLE: 400                                                │
│  CONCEPTS: WHERE · AND · OR · NOT · IN · BETWEEN · LIKE · ILIKE   │
│            · IS NULL                                              │
│  ESTIMATED TIME: 60 minutes                                       │
└────────────────────────────────────────────────────────────────────┘
```

---

## 📧 The Message

> **From:** Patricia Williams (HR Director)
> **To:** You (Junior Data Analyst)
> **Subject:** Need to filter the employee list — several questions
>
> *"Great work on the CEO report! Word travels fast here.*
>
> *I have several specific questions for an HR audit:*
>
> *- Who works in our Austin office?*
> *- Which employees earn more than $150K?*
> *- Who was hired between 2020 and 2022?*
> *- I need everyone whose job title contains the word 'Engineer'.*
> *- And critically — are there any employees missing a phone number or termination date in our records?*
>
> *Can you filter the data for each of these?*
>
> *— Patricia"*

---

## 🧭 Why This Matters (The Real World)

Mission 01 taught you to *see* data. Now you'll learn to **filter** it.

99% of real queries have a `WHERE` clause. Without filtering, you drown in data. With it, you answer precise business questions.

| Role | How they use WHERE |
|------|---------------------|
| **Data Analyst** | "Show me only Q4 sales in the West region" |
| **Data Engineer** | "Process only rows updated since yesterday" |
| **Analytics Engineer** | "Filter out test accounts and internal users" |
| **AI Engineer** | "Select only high-quality records for training" |

Filtering is also where **data quality** lives — `IS NULL` checks catch missing data before it breaks your reports or AI models.

---

## 📚 Concept 1 — WHERE

`WHERE` filters rows based on a condition.

```sql
-- Only employees in Austin
SELECT first_name, last_name, location
FROM employees
WHERE location = 'Austin';
```

Comparison operators:

| Operator | Meaning | Example |
|----------|---------|---------|
| `=` | equals | `salary = 100000` |
| `<>` or `!=` | not equal | `status <> 'Active'` |
| `>` | greater than | `salary > 150000` |
| `<` | less than | `salary < 80000` |
| `>=` | greater or equal | `salary >= 100000` |
| `<=` | less or equal | `salary <= 90000` |

```sql
-- Employees earning more than $150K
SELECT first_name, last_name, salary
FROM employees
WHERE salary > 150000
ORDER BY salary DESC;
```

> 💡 Text values go in **single quotes** (`'Austin'`). Numbers do not (`150000`).

---

## 📚 Concept 2 — AND, OR, NOT

Combine multiple conditions.

```sql
-- Austin employees earning over $130K
SELECT first_name, last_name, location, salary
FROM employees
WHERE location = 'Austin' AND salary > 130000;
```

```sql
-- Employees in EITHER Austin OR Chicago
SELECT first_name, last_name, location
FROM employees
WHERE location = 'Austin' OR location = 'Chicago';
```

```sql
-- Everyone NOT in Austin
SELECT first_name, last_name, location
FROM employees
WHERE NOT location = 'Austin';
```

### ⚠️ The Parentheses Trap

`AND` is evaluated before `OR`. Always use parentheses to be explicit:

```sql
-- WRONG: ambiguous logic
SELECT * FROM employees
WHERE location = 'Austin' OR location = 'Chicago' AND salary > 150000;

-- RIGHT: clear intent — (Austin or Chicago) AND high salary
SELECT * FROM employees
WHERE (location = 'Austin' OR location = 'Chicago') AND salary > 150000;
```

This is a **classic bug** that produces wrong reports. Always parenthesize mixed AND/OR.

---

## 📚 Concept 3 — IN

`IN` is a clean shortcut for multiple OR conditions.

```sql
-- Instead of: location = 'Austin' OR location = 'Chicago' OR location = 'Dallas'
SELECT first_name, last_name, location
FROM employees
WHERE location IN ('Austin', 'Chicago', 'Dallas');
```

```sql
-- NOT IN — exclude a list
SELECT first_name, last_name, location
FROM employees
WHERE location NOT IN ('New York', 'San Francisco');
```

> ⚠️ **`NOT IN` + NULL danger:** If the list contains a NULL, `NOT IN` returns no rows. We'll explain NULLs below.

---

## 📚 Concept 4 — BETWEEN

`BETWEEN` checks a range (inclusive on both ends).

```sql
-- Salaries between $90K and $120K (inclusive)
SELECT first_name, last_name, salary
FROM employees
WHERE salary BETWEEN 90000 AND 120000;
```

```sql
-- Hired between 2020 and 2022 — answers Patricia's question
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date BETWEEN '2020-01-01' AND '2022-12-31'
ORDER BY hire_date;
```

`BETWEEN a AND b` is equivalent to `>= a AND <= b`.

---

## 📚 Concept 5 — LIKE and ILIKE (Pattern Matching)

Find text matching a pattern using wildcards:

- `%` = any number of characters (including zero)
- `_` = exactly one character

```sql
-- Job titles containing 'Engineer' — answers Patricia's question
SELECT first_name, last_name, job_title
FROM employees
WHERE job_title LIKE '%Engineer%';
```

```sql
-- Last names starting with 'M'
SELECT first_name, last_name
FROM employees
WHERE last_name LIKE 'M%';
```

```sql
-- Emails ending in @dataverse.com
SELECT email
FROM employees
WHERE email LIKE '%@dataverse.com';
```

### LIKE vs ILIKE (PostgreSQL Feature)

- `LIKE` is **case-sensitive**: `'engineer'` ≠ `'Engineer'`
- `ILIKE` is **case-insensitive** (the `I` = insensitive)

```sql
-- Matches 'Engineer', 'engineer', 'ENGINEER', etc.
SELECT job_title
FROM employees
WHERE job_title ILIKE '%engineer%';
```

> 💡 `ILIKE` is PostgreSQL-specific and incredibly useful. Other databases force you to use `LOWER()`. This is one reason data professionals love PostgreSQL.

---

## 📚 Concept 6 — IS NULL (Data Quality)

`NULL` means "no value / unknown." It is **not** the same as zero or an empty string.

> ⚠️ You **cannot** use `= NULL`. It never works. You must use `IS NULL`.

```sql
-- WRONG — always returns nothing
SELECT * FROM employees WHERE termination_date = NULL;

-- RIGHT
SELECT first_name, last_name, status
FROM employees
WHERE termination_date IS NULL;
```

```sql
-- Find data quality issues — missing phone numbers
SELECT first_name, last_name, phone
FROM employees
WHERE phone IS NULL;
```

```sql
-- Employees who HAVE a termination date (have left)
SELECT first_name, last_name, termination_date
FROM employees
WHERE termination_date IS NOT NULL;
```

**This is critical for AI and data engineering.** Missing values break ML models and produce wrong analytics. Every data professional checks for NULLs constantly.

---

## ✅ Solving the HR Director's Request

```sql
-- 1. Who works in Austin?
SELECT first_name, last_name, job_title
FROM employees
WHERE location = 'Austin'
ORDER BY last_name;

-- 2. Who earns more than $150K?
SELECT first_name, last_name, salary
FROM employees
WHERE salary > 150000
ORDER BY salary DESC;

-- 3. Who was hired between 2020 and 2022?
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date BETWEEN '2020-01-01' AND '2022-12-31'
ORDER BY hire_date;

-- 4. Who has 'Engineer' in their title?
SELECT first_name, last_name, job_title
FROM employees
WHERE job_title ILIKE '%engineer%';

-- 5. Data quality — who is missing a phone number?
SELECT first_name, last_name, phone
FROM employees
WHERE phone IS NULL;
```

---

## 🏋️ Exercises

1. Find all employees with the status `'On Leave'`.
2. Find all `'Full-Time'` employees earning between $100K and $150K.
3. Find employees whose `first_name` starts with `'A'` or `'B'`.
4. Find all employees in `'Chicago'`, `'Dallas'`, or `'Houston'` using `IN`.
5. Find employees whose `email` contains the letter sequence `'son'`.
6. Find all employees who do **not** have a `termination_date` AND are `'Active'`.
7. Find `'Contract'` or `'Intern'` employees earning less than $70K.
8. Find employees hired in 2021 (hint: `BETWEEN '2021-01-01' AND '2021-12-31'`).

→ Solutions: [SOLUTIONS/MISSION-02.md](../../SOLUTIONS/MISSION-02.md)

---

## 🧪 Quiz

→ [QUIZZES/MISSION-02-quiz.md](../../QUIZZES/MISSION-02-quiz.md)

---

## 🔥 Challenge (Bonus 75 XP)

> Patricia asks: *"Give me a 'flight risk' list — all Active, Full-Time employees hired in the last 3 years (2022 or later) who earn less than $90K. These are people we might lose to competitors."*

Combine `WHERE`, `AND`, `BETWEEN`/comparison, and proper parentheses.

---

## 🎓 What You Learned

```
✓ WHERE — filter rows
✓ Comparison operators (=, <>, >, <, >=, <=)
✓ AND, OR, NOT — combine conditions
✓ Parentheses — control logic order
✓ IN / NOT IN — match a list
✓ BETWEEN — match a range
✓ LIKE / ILIKE — pattern matching with % and _
✓ IS NULL / IS NOT NULL — data quality checks
```

**XP EARNED: 400** (+75 bonus for the challenge)

---

## ➡️ Next Mission

Finance needs numbers summarized, not listed row by row...

→ [MISSION 03 — Finance Team Needs Reports](../MISSION-03/README.md)
