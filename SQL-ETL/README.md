## 🏛️ Medallion Layers Detailed

### 🥉 Bronze Layer (`/bronze`)
* **Role:** Raw ingestion / Staging area.
* **Characteristics:** Tables accept all incoming data types as text/varchar with minimal constraints to avoid ingestion failures.

### 🥈 Silver Layer (`/silver`)
* **Role:** Cleaned & Standardized repository.
* **Key Operations:**
  * Typecasting text fields to proper SQL data types (`INT`, `DECIMAL`, `DATE`, `TIMESTAMP`).
  * Trimming whitespaces and standardizing string casings.
  * Handling missing or null values with baseline defaults.
  * Enforcing Primary & Foreign Key constraints.

### 🥇 Gold Layer (`/gold`)
* **Role:** Business-ready dimensional model (Kimball approach).
* **Vessel:** Consists of optimized views designed for direct consumption by BI tools (e.g., Power BI) and business analysts.

#### Core Analytical Views:
* **`gold.fact_sales_details`**: Transactional fact table with denormalized line-item details for fast ad-hoc queries.
* **`gold.vw_customer_details`**: Profiled customer metrics including total monetary spend, order frequency, average ticket size, and recency.
* **`gold.vw_product_performance`**: Product catalog performance tracking total volume sold, generated revenue, distinct order counts, and product lifecycle dates.
* **`gold.vw_monthly_sales_trends`**: Time-series aggregation breaking down monthly revenue, unique active customers, order volumes, and average order value (AOV).

---

## 🔍 SQL Highlights & Best Practices
* **Aggregations:** Extensive use of `COALESCE`, `NULLIF`, `COUNT(DISTINCT)`, `SUM`, and `AVG`.
* **Date Parsing:** Utilization of `EXTRACT()` and `TO_CHAR()` for period formatting (`YYYY-MM`).
* **Relational Integrity:** Careful application of `LEFT JOIN` vs `INNER JOIN` logic to preserve catalog integrity without discarding zero-sale entities.