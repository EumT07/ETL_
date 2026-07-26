# Data Generator Module (`/generator`)

This module contains the Python logic responsible for generating synthetic transactional e-commerce datasets. The data is deliberately injected with realistic data quality issues (missing values, inconsistent formats, duplicates) to simulate real-world ETL challenges.

---
<p align="center">
  <img src="https://github.com/EumT07/ETL_/blob/master/assets/py.png" width="250" height="300"  alt="home" />
</p>

## ⚙️ Generated Datasets & Entities

The generator outputs raw CSV files covering three main domain entities:

1. **Customers (`crm_customers`):** Demographic information, registration dates, locations, and contact details.
2. **Products (`crm_products`):** Product catalog, categories, subcategories, brands, and base prices.
3. **Orders (`crm_orders`):** Purchase headers and line-item details including timestamps, quantities, and applied prices.
4. **Files (`crm_data.csv`,`crm_data.xlsx` ):** Get a CSV, copy and past into SQL-ETL/source, in order to start using csv file to ETL pipeline.
---
<p align="center">
  <img src="https://github.com/EumT07/ETL_/blob/master/assets/crm_data.png" width="220" height="650"  alt="home" />
</p>
---

## 🛠️ Local Usage

If you wish to run the generator script locally outside of Docker:

### 1. Requirements
Install required Python dependencies:
```bash
pip install -r requirements.txt
```

### 2. Execution
1. By the fault
```
python data.py
```

2. By ipynb file

