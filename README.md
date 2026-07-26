# Medallion Data Architecture & SQL Analytics (E-Commerce CRM)

An end-to-end Data Engineering pipeline demonstrating a **Medallion Architecture (Bronze → Silver → Gold)** in PostgreSQL. This project generates synthetic e-commerce transactional data, cleanses and normalizes raw tables, and builds an analytical star-schema model optimized for Business Intelligence (Power BI) and SQL reporting.

<p align="center">
  <img src="https://github.com/EumT07/ETL_/blob/master/assets/data.png" width="650" height="400"  alt="home" />
</p>

## 📐 Architecture Overview

```text
  +------------------+      +-------------------+      +--------------------+      +----------------------+
  | Synthetic Data   | ---> | Bronze Layer      | ---> | Silver Layer       | ---> | Gold Layer           |
  | (Python Script)  |      | Raw Staging Data  |      | Cleaned & Typed    |      | Dimensional Analytics|
  +------------------+      +-------------------+      +--------------------+      +----------------------+
```
1. Synthetic Data Engine (/generator): Python script generating realistic sales, customer, and product data with intentional edge cases/anomalies for practice.

2. Bronze Layer (/sql-etl/bronze): Raw tables matching incoming CSV/JSON structure without transformations.

3. Silver Layer (/sql-etl/silver): Cleansed, deduplicated, standardized, and typed tables enforcing relational integrity.

4. Gold Layer (/sql-etl/gold): Kimball dimensional model consisting of fact tables and aggregated business views.

## 🛠️ Tech Stack
* Database Engine: PostgreSQL
* Data Generation: Python 3.x
* Containerization: Docker & Docker Compose
* Modeling Methodology: Medallion Architecture, Kimball Dimensional Modeling

## 🚀 Quickstart Guide (Running with Docker)
* Docker Desktop installed on your machine.
* Git installed.

## Clone the Repository
```
git clone https://github.com/EumT07/ETL_.git
cd ETL_
```

## Create enviroment
```
uv venv
```

## Install dependencies
```
uv sync
```

## Set .env
```
DB_NAME="name-project"
DB_USER="user_db"
DB_PASSWORD="password_db"
HOST="localhost"
PORT="port_db"
```
## Spin Up Containers
```
docker compose up -d
```

## Verify Running Services
```
docker ps
```

## Go to Data-Generator
1. Run python code and get these files: **(`crm_data.csv`)**
2. Copy **(`crm_data.csv`)** paste into **(`SQL-ETL/source`)**

## Run docker cmd

1. Create Schemas
```
docker exec -i postgres_db psql -U postgres -d ecommerce_db < sql-etl/scripts/01_db_init.sql
```

2. Execute Bronze Slayer
- Creating Bronze Tables
```
docker exec -i postgres_db psql -U postgres -d ecommerce_db < sql-etl/scripts/bronze/ddl_bronze.sql
```
- Loading Data from csv to db
```
docker exec -i postgres_db psql -U postgres -d ecommerce_db < sql-etl/scripts/bronze/load_bronze.sql
```

3. Execute Silver Slayer
- Creating Silver Tables
```
docker exec -i postgres_db psql -U postgres -d ecommerce_db < sql-etl/scripts/silver/ddl_silver.sql
```
- Loading data from broze tables to silver tables
```
docker exec -i postgres_db psql -U postgres -d ecommerce_db < sql-etl/scripts/silver/load_silver.sql
```

4. Execute Gold Slayer
```
docker exec -i postgres_db psql -U postgres -d ecommerce_db < sql-etl/scripts/gold/ddl_gold.sql
```

## Stop Containers
```
docker compose down -v
```
