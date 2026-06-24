# 📊 Data Warehouse Architecture

How data flows from operational sources into a dimensional warehouse for analytics.

---

## End-to-End Flow

```mermaid
graph LR
    subgraph "Sources (OLTP)"
    APP[(App DB)]
    CRM[(CRM)]
    FILES[Files/APIs]
    end
    subgraph "Ingestion"
    EL[Extract + Load]
    end
    subgraph "Warehouse (OLAP)"
    STG[Staging]
    DIM[Dimensions]
    FACT[Fact Tables]
    AGG[Aggregates]
    end
    subgraph "Consumption"
    BI[BI Dashboards]
    AI[AI / ML]
    end
    APP & CRM & FILES --> EL --> STG
    STG --> DIM --> FACT --> AGG
    AGG --> BI & AI
```

---

## The Star Schema (core of the warehouse)

```mermaid
erDiagram
    DIM_DATE ||--o{ FACT_SALES : ""
    DIM_CUSTOMER ||--o{ FACT_SALES : ""
    DIM_PRODUCT ||--o{ FACT_SALES : ""
    DIM_EMPLOYEE ||--o{ FACT_SALES : ""
    FACT_SALES {
        int sales_key PK
        int date_key FK
        int customer_key FK
        int product_key FK
        int employee_key FK
        numeric revenue
        numeric cost
        numeric gross_profit
        int quantity
    }
    DIM_CUSTOMER {
        int customer_key PK
        int customer_id "natural key"
        string company_name
        string industry
        string segment
        date valid_from "SCD2"
        date valid_to "SCD2"
        boolean is_current "SCD2"
    }
    DIM_DATE {
        int date_key PK
        date full_date
        int year
        int quarter
        int month
    }
    DIM_PRODUCT {
        int product_key PK
        int product_id
        string product_name
        string category
    }
```

---

## OLTP vs OLAP

| | OLTP (sources) | OLAP (warehouse) |
|--|----------------|------------------|
| Purpose | Run the business | Analyze the business |
| Design | Normalized | Dimensional (star) |
| Workload | Many small writes | Large reads/scans |
| Example | Place an order | Revenue by quarter |

---

## Layered Build

```mermaid
graph TB
    R[Raw / Staging] --> D[Conformed Dimensions]
    D --> F[Fact Tables]
    F --> A[Aggregate / Summary Tables]
    A --> S[Semantic Layer / Views]
    S --> C[Dashboards & AI]
```

→ Related: [Mission 10](../MISSIONS/MISSION-10/README.md) · [Project 05](../PROJECTS/PROJECT-05/README.md) · [DW Cheat Sheet](../CHEATSHEETS/07-data-warehouse-sql.md)
