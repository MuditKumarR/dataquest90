# ✅ Mission 14 — Solutions

Worked solutions for [Mission 14](../MISSIONS/MISSION-14/README.md) — the final mission. Try first!

---

### 1. Embeddings table DDL

```sql
CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE document_embeddings (
    doc_id      BIGSERIAL PRIMARY KEY,
    content     TEXT NOT NULL,
    category    VARCHAR(50),
    source_id   INT,
    embedding   vector(1536)
);

CREATE INDEX ON document_embeddings USING ivfflat (embedding vector_cosine_ops);
```

### 2. Semantic search — top 5 similar documents

```sql
SELECT doc_id, content,
       1 - (embedding <=> :query_embedding) AS similarity
FROM document_embeddings
ORDER BY embedding <=> :query_embedding
LIMIT 5;
```

### 3. Hybrid search (metadata filter + vector)

```sql
SELECT content, 1 - (embedding <=> :query_embedding) AS similarity
FROM document_embeddings
WHERE category = 'HR Policy'
ORDER BY embedding <=> :query_embedding
LIMIT 5;
```

### 4. RAG retrieval — top 4 context chunks

```sql
SELECT content
FROM document_embeddings
WHERE category = 'HR Policy'
ORDER BY embedding <=> :question_embedding
LIMIT 4;
-- These 4 chunks are injected into the LLM prompt as grounding context.
```

### 5. Text-to-SQL output

> **NL:** "What is total revenue by product category in 2024?"

```sql
SELECT p.category, SUM(s.revenue) AS total_revenue
FROM sales_transactions s
JOIN products p ON s.product_id = p.product_id
WHERE s.fiscal_year = 2024
GROUP BY p.category
ORDER BY total_revenue DESC;
```

### 6. Read-only role for an AI agent

```sql
CREATE ROLE ai_agent_readonly;
GRANT CONNECT ON DATABASE dataverse TO ai_agent_readonly;
GRANT USAGE ON SCHEMA public TO ai_agent_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO ai_agent_readonly;
ALTER ROLE ai_agent_readonly SET statement_timeout = '15s';
-- No INSERT/UPDATE/DELETE/DROP — the agent can read, never mutate.
```

### 7. Knowledge graph + recursive query

```sql
CREATE TABLE kg_nodes (node_id INT PRIMARY KEY, label TEXT, node_type TEXT);
CREATE TABLE kg_edges (from_node INT, to_node INT, relationship TEXT);

-- Everyone under the VP of Sales (assume node_id 5)
WITH RECURSIVE down AS (
    SELECT node_id, label FROM kg_nodes WHERE node_id = 5
    UNION ALL
    SELECT n.node_id, n.label
    FROM kg_edges e
    JOIN down d ON e.from_node = d.node_id
    JOIN kg_nodes n ON e.to_node = n.node_id
    WHERE e.relationship = 'manages'
)
SELECT * FROM down WHERE node_id <> 5;
```

### 8. The 3 queries an agent runs for "top customers at churn risk"

```sql
-- (1) High-value customers flagged at risk
SELECT customer_id, company_name, lifetime_value, customer_status
FROM customers
WHERE customer_status IN ('Inactive', 'Prospect')
ORDER BY lifetime_value DESC;

-- (2) Their recent activity gap
SELECT customer_id, last_activity_date,
       CURRENT_DATE - last_activity_date AS days_since_activity
FROM customers
ORDER BY days_since_activity DESC;

-- (3) Revenue exposure if they churn
SELECT c.company_name, SUM(oi.line_total) AS revenue_at_risk
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE c.customer_status = 'Inactive'
GROUP BY c.company_name
ORDER BY revenue_at_risk DESC;
```

---

## 🔥 Challenge (Capstone) — DataVerse AI Data Layer

A complete blueprint combining everything:

```sql
-- (1) Embeddings linked to relational tables
CREATE TABLE kb_embeddings (
    id BIGSERIAL PRIMARY KEY, content TEXT, entity_type TEXT,
    entity_id INT, embedding vector(1536)
);
CREATE INDEX ON kb_embeddings USING ivfflat (embedding vector_cosine_ops);

-- (2) Hybrid search
SELECT content FROM kb_embeddings
WHERE entity_type = 'department'
ORDER BY embedding <=> :q LIMIT 5;

-- (3) RAG retrieval feeds the LLM prompt (top-k chunks above)

-- (4) Secure agent role (see exercise 6)

-- (5) Text-to-SQL schema export
SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public'
ORDER BY table_name, ordinal_position;

-- (6) Org knowledge graph (see exercise 7)

-- "Which departments are at highest attrition risk and why?"
-- The agent: queries hr_analytics_summary for flight_risk_score by department,
-- joins engagement_score and tenure, retrieves policy context via RAG,
-- then synthesizes a ranked, explained answer.
SELECT department_name,
       ROUND(AVG(flight_risk_score), 2) AS avg_flight_risk,
       ROUND(AVG(engagement_score), 2)  AS avg_engagement,
       COUNT(*) AS headcount
FROM hr_analytics_summary
GROUP BY department_name
ORDER BY avg_flight_risk DESC;
```

🎉 **You've completed the entire journey — from `SELECT *` to building the data layer that powers AI.**

→ Build the [Capstone Project](../PROJECTS/PROJECT-08/README.md) · See [Agentic AI](../DIAGRAMS/agentic-ai-architecture.md) & [RAG](../DIAGRAMS/rag-architecture.md) diagrams
