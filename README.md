# RCM Risk Mitigator Pipeline

## Project Overview

In the healthcare industry, **Accounts Receivable (AR)** plays a critical role in determining the financial health of hospitals and clinics. When AR goes uncollected — especially past **90 days**, it can significantly disrupt cash flow and impact patient services.

> Industry statistics:
> - 93.4% collected within 30 days  
> - 85.2% within 60 days  
> - Only 73.1% within 90 days

To mitigate this risk, healthcare providers need real-time insights into AR metrics and other **Revenue Cycle Management (RCM)** KPIs.

---

## Solution

This project delivers an **end-to-end cloud-based data pipeline** to monitor and analyze RCM metrics like:

- **Accounts Receivable (AR)** aging
- **Days in AR**
- **Net Collection Rate**
- **Claim acceptance and denial trends**
- **Provider payment performance**

The pipeline is built using **Medallion Architecture** (Landing → Bronze → Silver → Gold), ensuring **data quality, scalability**, and **reliability**.

---

## Architecture & Workflow

### **Medallion Architecture Breakdown:**

- **Landing Layer**  
  Raw flat files from APIs, Azure SQL, and other external sources.

- **Bronze Layer**  
  Data ingestion using **Azure Data Factory (ADF)** into **ADLS Gen2**.

- **Silver Layer**  
  Transformations in **Azure Databricks (PySpark)**:
  - Schema unification
  - SCD2 for patient records
  - Data quality checks (nulls, type mismatch)
  - Metadata logging

- **Gold Layer**  
  Analytical **Fact/Dim models** for KPIs and dashboards.

### Key Features

- **Metadata-driven** design with external configuration files
- **Supports full & incremental loads** via parameterization
- **Retry & timeout logic** for pipeline robustness
- **Toggle components on/off** dynamically with config flags


---

## Tech Stack

| Tool/Service       | Purpose                         |
|--------------------|----------------------------------|
| **Azure Data Factory** | Data ingestion (ETL)              |
| **Azure Databricks (PySpark)** | Transformations & aggregations     |
| **Azure SQL Database** | Source system for structured data |
| **Delta Lake**           | Storage format for Silver/Gold     |
| **ADLS Gen2**            | Cloud data lake for raw & curated layers |
| **SQL, Python**          | Logic & analytics                  |
| **Git**                  | Version control                    |

---

## Sample KPIs & Queries

### Revenue & Provider Performance

- **Total Charges per Provider by Department**
- **Top 10 Providers by Revenue**
- **Monthly Billing Trends**

### Payment Collection Efficiency

- **Collection % by Provider**
- **Monthly Payment Collection Trend**

### Accounts Receivable (AR) Analysis

- **AR Aging Buckets (0-30, 31-60, 61-90, >90 days)**
- **AR > 90 Days %**
- **Days in AR Calculation**
- **Forecasting Uncollected AR Risk**

### Claims & Denial Metrics

- **Claim Acceptance Rate**
- **Denial Patterns by Procedure Code (CPT)**

> 📎 All queries are in the `Gold Layer Queries.sql/` file.

---

## Why This Matters

By identifying revenue leaks early and tracking AR aging effectively, healthcare providers can:
- Boost cash flow
- Reduce claim denials
- Focus on high-performing providers
- Optimize patient billing and follow-up processes

---

