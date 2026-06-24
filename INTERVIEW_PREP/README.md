# 💼 INTERVIEW_PREP — 300 Questions with Answers

Everything you need to ace SQL and data interviews — from junior analyst to data architect and AI roles.

| File | Topic | Questions |
|------|-------|-----------|
| [01-sql-fundamentals.md](01-sql-fundamentals.md) | Core SQL | 100 |
| [02-advanced-sql.md](02-advanced-sql.md) | Advanced patterns, performance | 50 |
| [03-postgresql.md](03-postgresql.md) | PostgreSQL features & internals | 50 |
| [04-data-engineering.md](04-data-engineering.md) | ETL/ELT, modeling, pipelines | 50 |
| [05-snowflake.md](05-snowflake.md) | Cloud data warehouse | 50 |
| **Total** | | **300** |

---

## 🎯 How to Prepare

```mermaid
graph LR
    A[Week 1-2: Fundamentals] --> B[Week 3: Advanced]
    B --> C[Week 4: PostgreSQL]
    C --> D[Week 5: Data Engineering]
    D --> E[Week 6: Snowflake]
    E --> F[Mock Interviews]
```

1. **Understand, don't memorize** — be able to explain *why*.
2. **Write the queries** — run them against the DataVerse database.
3. **Practice out loud** — interviews test communication too.
4. **Drill the patterns** — window functions and joins appear most.
5. **Do mock interviews** — simulate pressure.

---

## 🔑 By Role

| Target role | Focus files |
|-------------|-------------|
| Data Analyst | 01, parts of 02 |
| Analytics Engineer | 01, 02, 03 |
| Data Engineer | 02, 03, 04 |
| Snowflake Developer | 04, 05 |
| Data Architect | All five |
| AI/Data role | All + [AI cheat sheet](../CHEATSHEETS/09-ai-sql-cheatsheet.md) |

---

## 💡 Interview-Day Tips

- Clarify requirements before coding (NULLs, ties, duplicates).
- Think aloud — explain your approach.
- Start with a working query, then optimize.
- Know the difference between `RANK`/`DENSE_RANK`/`ROW_NUMBER` cold.
- Be ready to discuss `EXPLAIN` and indexing for optimization questions.
