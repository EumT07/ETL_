-- View: Sales Details
DROP VIEW IF EXISTS gold.vw_sales_details;
CREATE VIEW gold.vw_sales_details AS (
    SELECT
        ord.id AS order_id, 
        cst.id AS customer_id,
        pr.id AS product_id,
        cst.cst_first_name || ' ' || cst.cst_last_name AS customer,
        cst.cst_country AS country,
        pr.pro_brand AS brand,
        pr.pro_category AS category,
        pr.pro_sub_category AS sub_category,
        ord.or_status AS status,
        oi.itm_price AS product_price,
        oi.itm_quantity AS quantity,
        (oi.itm_price * oi.itm_quantity) AS total,
        ord.or_purchase_date AS pruchase_date
    FROM silver.crm_order_items AS oi
    INNER JOIN silver.crm_orders AS ord
    ON oi.itm_order_id = ord.id
    INNER JOIN silver.crm_customers AS cst
    ON ord.or_customer_id = cst.id
    INNER JOIN silver.crm_products AS pr
    ON oi.itm_product_id = pr.id
);

-- Checking view 
SELECT * FROM gold.vw_sales_details;

-- View: Customer Details
DROP VIEW IF EXISTS gold.vw_customers_details;
CREATE VIEW gold.vw_customers_details AS
SELECT
    cst.id AS customer_id,
    cst.cst_first_name || ' ' || cst.cst_last_name AS full_name,
    cst.cst_country AS country,
    COUNT(DISTINCT ord.id) AS total_orders,
    COALESCE(SUM(ord.or_order_total), 0) AS total_spent,
    COALESCE(ROUND(AVG(ord.or_order_total), 2), 0) AS avg_total,
    MIN(ord.or_purchase_Date) AS first_order_date,
    MAX(ord.or_purchase_Date) AS last_order_date
FROM silver.crm_customers AS cst
LEFT JOIN silver.crm_orders AS ord
ON cst.id = ord.or_customer_id
GROUP BY
    cst.id,
    cst.cst_first_name,
    cst.cst_last_name,
    cst.cst_country;

-- checking view
SELECT * FROM gold.vw_customers_details;

-- Product Performance

DROP VIEW IF EXISTS gold.vw_product_performance;
CREATE VIEW gold.vw_product_performance AS
SELECT
    pr.id,
    pr.pro_brand AS brand,
    pr.pro_category AS category,
    pr.pro_sub_category AS sub_category,
    COALESCE(SUM(oi.itm_quantity), 0) AS total_units_sold,
    COALESCE(ROUND(AVG(oi.itm_price),2),0) AS avg_sales_price,
    COUNT(oi.itm_order_id) AS total_orders,
    COALESCE(SUM((oi.itm_price * oi.itm_quantity)),0) AS total_revenue,
    MIN(ord.or_purchase_Date) AS first_order_date,
    MAX(ord.or_purchase_Date) AS last_order_date
FROM silver.crm_products AS pr
LEFT JOIN silver.crm_order_items AS oi
ON pr.id = oi.itm_product_id
LEFT JOIN silver.crm_orders AS ord
ON oi.itm_order_id = ord.id
GROUP BY
    pr.pro_category,
    pr.pro_brand,
    pr.id;

-- check view
SELECT * FROM gold.vw_product_performance;

DROP VIEW IF EXISTS gold.vw_monthly_sales_trends;
CREATE VIEW gold.vw_monthly_sales_trends AS
SELECT
    COUNT(DISTINCT ord.or_customer_id) AS active_customers,
    EXTRACT(YEAR FROM ord.or_purchase_date) AS sales_year,
    EXTRACT(MONTH FROM ord.or_purchase_date) AS month,
    TO_CHAR(ord.or_purchase_date, 'YYYY-MM' ) AS  year_month,
    TO_CHAR(ord.or_purchase_date, 'FMMonth' ) AS  month_name,
    COUNT(DISTINCT oi.itm_order_id) AS total_orders,
    COALESCE(SUM(oi.itm_quantity), 0) AS total_units_sold,
    COALESCE(SUM((oi.itm_price * oi.itm_quantity)),0) AS total_revenue,
    ROUND(
        COALESCE(SUM((oi.itm_price * oi.itm_quantity)),0) / NULLIF(COUNT(DISTINCT oi.itm_order_id),0)
        ,2
    ) AS avg_order_value
FROM silver.crm_orders AS ord
INNER JOIN silver.crm_order_items AS oi
ON ord.id = oi.itm_order_id
GROUP BY 
    EXTRACT(YEAR FROM ord.or_purchase_date),
    EXTRACT(MONTH FROM ord.or_purchase_date),
    TO_CHAR(ord.or_purchase_date, 'YYYY-MM' ),
    TO_CHAR(ord.or_purchase_date, 'FMMonth' )
ORDER BY
    EXTRACT(YEAR FROM ord.or_purchase_date),
    EXTRACT(MONTH FROM ord.or_purchase_date);

-- Check View
SELECT * FROM gold.vw_monthly_sales_trends;
