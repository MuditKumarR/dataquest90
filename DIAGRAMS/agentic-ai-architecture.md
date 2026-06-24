# 📊 Agentic AI Architecture

How an AI agent uses your database as its source of truth — thinking in a loop of plan → act (SQL) → observe → repeat.

---

## The Agent Loop

```mermaid
graph TB
    G[Business Goal] --> PLAN[Plan: decompose into questions]
    PLAN --> ACT[Act: call a tool]
    ACT --> T1[Tool: query_database<br/>read-only SQL]
    ACT --> T2[Tool: semantic_search<br/>vector retrieval]
    T1 --> RDB[(Relational DB)]
    T2 --> VDB[(Vector Store)]
    RDB & VDB --> OBS[Observe results]
    OBS --> THINK{Enough info?}
    THINK -- No --> PLAN
    THINK -- Yes --> REPORT[Synthesized Answer]
```

---

## The Full Stack

```mermaid
graph TB
    subgraph "Application"
    AGENT[AI Agent / Copilot]
    end
    subgraph "Retrieval Layer (SQL!)"
    T2S[Text-to-SQL]
    RAG[RAG Retrieval]
    KG[Knowledge Graph]
    end
    subgraph "Data Layer"
    REL[(Relational: facts)]
    VEC[(Vector: embeddings)]
    end
    AGENT --> T2S --> REL
    AGENT --> RAG --> VEC
    AGENT --> KG --> REL
```

---

## Security Boundary (critical)

```mermaid
graph LR
    AGENT[AI Agent] --> VAL[Validation Layer]
    VAL --> CHECK{SELECT-only?<br/>No DDL/DML?}
    CHECK -- Pass --> ROLE[Read-only role<br/>+ statement timeout]
    CHECK -- Fail --> BLOCK[Reject query]
    ROLE --> DB[(Database)]
```

```sql
CREATE ROLE ai_agent_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO ai_agent_readonly;
ALTER ROLE ai_agent_readonly SET statement_timeout = '15s';
-- NO INSERT/UPDATE/DELETE/DROP
```

---

## Worked Example

**Goal:** "Find our biggest revenue risks this quarter."

| Step | Agent action (SQL) |
|------|--------------------|
| 1 | Query high-value customers at churn risk |
| 2 | Compute revenue concentration (top-5 %) |
| 3 | Find declining product lines (QoQ) |
| 4 | RAG: retrieve playbook docs for recommendations |
| 5 | Synthesize a board-ready risk analysis |

Every "thought" the agent has becomes a SQL query. **SQL is the agent's sense of reality.**

→ Related: [Mission 14](../MISSIONS/MISSION-14/README.md) · [Project 08](../PROJECTS/PROJECT-08/README.md) · [AI+SQL Cheat Sheet](../CHEATSHEETS/09-ai-sql-cheatsheet.md)
