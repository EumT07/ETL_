CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

DROP TABLE IF EXISTS silver.crm_customers;

CREATE TABLE IF NOT EXISTS silver.crm_customers (
  id          VARCHAR(50) PRIMARY KEY,
  crm_id      VARCHAR(50),
  first_name  VARCHAR(50),
  last_name   VARCHAR(50),
  gender      VARCHAR(50),
  email       VARCHAR(50),
  birthdate   DATE,
  country     VARCHAR(50),
  address     TEXT,
  created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
);

DROP TABLE IF EXISTS silver.crm_products;

CREATE TABLE IF NOT EXISTS silver.crm_products (
  id            VARCHAR(50) PRIMARY KEY,
  name          VARCHAR(50),
  brand         VARCHAR(50),
  category      VARCHAR(50),
  sub_category  VARCHAR(50),
  current_price NUMERIC(10,2),
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
);

DROP TABLE IF EXISTS silver.crm_orders;

CREATE TABLE IF NOT EXISTS silver.crm_orders (
  id             VARCHAR(50) PRIMARY KEY,
  customer_id    VARCHAR(50),
  status         VARCHAR(50),
  payment_method VARCHAR(50),
  purchase_date  DATE,
  shipping_date  DATE,
  delivery_date  DATE,
  order_total    INTEGER,
  created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
);

DROP TABLE IF EXISTS silver.crm_order_items;

CREATE TABLE IF NOT EXISTS silver.crm_order_items (
  id UUID    PRIMARY KEY DEFAULT uuid_generate_v4(),
  order_id   VARCHAR(50),
  product_id VARCHAR(50),
  quantity   INTEGER CHECK ("quantity" > 0),
  price      NUMERIC(10,2),
  reviews    INTEGER CHECK ("reviews" >= 0 AND "reviews" <=5),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
);

ALTER TABLE silver.crm_orders ADD FOREIGN KEY ("customer_id") REFERENCES silver.crm_customers ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE silver.crm_order_items ADD FOREIGN KEY ("order_id") REFERENCES silver.crm_orders ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE silver.crm_order_items ADD FOREIGN KEY ("product_id") REFERENCES silver.crm_products ("id") DEFERRABLE INITIALLY IMMEDIATE;