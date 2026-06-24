# 📊 SQL Join Types

A visual reference for how each join combines two tables, A (left) and B (right).

---

## Overview

```mermaid
graph TB
    subgraph "INNER JOIN"
    I[Only rows matching in BOTH]
    end
    subgraph "LEFT JOIN"
    L[ALL of A + matches from B]
    end
    subgraph "RIGHT JOIN"
    R[ALL of B + matches from A]
    end
    subgraph "FULL OUTER JOIN"
    F[Everything from A and B]
    end
```

---

## ASCII Venn Diagrams

```
INNER JOIN              LEFT JOIN               RIGHT JOIN
   A   B                   A   B                   A   B
  ( ∩ )                  (███∩ )                 ( ∩███)
  only overlap           all A + overlap         all B + overlap

FULL OUTER JOIN         LEFT ANTI (A only)      CROSS JOIN
   A   B                   A   B                  A × B
  (███████)              (███  )                 every combination
  everything             A without B match       (M × N rows)
```

---

## Side-by-Side

| Join | Keeps | NULLs appear for |
|------|-------|------------------|
| INNER | matches only | never |
| LEFT | all left + matches | unmatched left's right columns |
| RIGHT | all right + matches | unmatched right's left columns |
| FULL | all rows both sides | both sides where unmatched |
| CROSS | every combination | never (no condition) |

---

## Decision Flow

```mermaid
graph TD
    Q{What do you need?} --> M[Only matching rows]
    Q --> AL[All of the left table]
    Q --> AR[All of the right table]
    Q --> AB[All rows, both tables]
    Q --> COMBO[Every combination]
    Q --> MISSING[Rows in A with no B]
    M --> IJ[INNER JOIN]
    AL --> LJ[LEFT JOIN]
    AR --> RJ[RIGHT JOIN]
    AB --> FJ[FULL OUTER JOIN]
    COMBO --> CJ[CROSS JOIN]
    MISSING --> ANTI[LEFT JOIN + WHERE B.key IS NULL]
```

→ Related: [Mission 4](../MISSIONS/MISSION-04/README.md) · [Joins Cheat Sheet](../CHEATSHEETS/02-sql-joins.md)
