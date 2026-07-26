DROP TABLE IF EXISTS silver.crm_customers CASCADE;

CREATE TABLE IF NOT EXISTS silver.crm_customers (
  id          VARCHAR(50) PRIMARY KEY,
  cst_crm_id      VARCHAR(50),
  cst_first_name  VARCHAR(50),
  cst_last_name   VARCHAR(50),
  cst_gender      VARCHAR(50),
  cst_email       VARCHAR(50),
  cst_birthdate   DATE,
  cst_address     TEXT,
  cst_ads_source  VARCHAR(50),
  cst_country     VARCHAR(50),
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS silver.crm_products CASCADE;

CREATE TABLE IF NOT EXISTS silver.crm_products (
  id            VARCHAR(50) PRIMARY KEY,
  pro_name          VARCHAR(50),
  pro_brand         VARCHAR(50),
  pro_category      VARCHAR(50),
  pro_sub_category  VARCHAR(50),
  pro_current_price NUMERIC(10,2),
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS silver.crm_orders CASCADE;

CREATE TABLE IF NOT EXISTS silver.crm_orders (
  id             VARCHAR(50) PRIMARY KEY,
  or_customer_id    VARCHAR(50),
  or_status         VARCHAR(50),
  or_payment_method VARCHAR(50),
  or_purchase_date  DATE,
  or_shipping_date  DATE,
  or_delivery_date  DATE,
  or_order_total    INTEGER,
  created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS silver.crm_order_items;

CREATE TABLE IF NOT EXISTS silver.crm_order_items (
  id    BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  itm_order_id   VARCHAR(50),
  itm_product_id VARCHAR(50),
  itm_quantity   INTEGER CHECK ("itm_quantity" > 0),
  itm_price      NUMERIC(10,2),
  itm_reviews    INTEGER CHECK ("itm_reviews" >= 0 AND "itm_reviews" <=5),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE silver.crm_orders ADD FOREIGN KEY ("or_customer_id") REFERENCES silver.crm_customers ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE silver.crm_order_items ADD FOREIGN KEY ("itm_order_id") REFERENCES silver.crm_orders ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE silver.crm_order_items ADD FOREIGN KEY ("itm_product_id") REFERENCES silver.crm_products ("id") DEFERRABLE INITIALLY IMMEDIATE;


-- Checks Tables
-- SELECT * FROM silver.crm_customers;
-- SELECT * FROM silver.crm_products;
-- SELECT * FROM silver.crm_orders;
-- SELECT * FROM silver.crm_order_items;