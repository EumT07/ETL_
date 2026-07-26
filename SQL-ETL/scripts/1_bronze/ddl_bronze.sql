DROP TABLE IF EXISTS bronze.crm_data_info;

CREATE TABLE IF NOT EXISTS bronze.crm_data_info (
    crm_id            VARCHAR(50),
    cst_id            VARCHAR(50),
    cst_first_name    VARCHAR(50),
    cst_last_name     VARCHAR(50),
    cst_birthdate     VARCHAR(50),
    cst_email         VARCHAR(50),
    cst_address       TEXT,
    cst_gender        VARCHAR(50),
    cst_country       VARCHAR(50),
    cst_reviews       VARCHAR(50),
    cst_ads_source    VARCHAR(50),
    pro_id            VARCHAR(50),
    pro_name          VARCHAR(50),
    pro_brand         VARCHAR(50),
    pro_category      VARCHAR(50),
    pro_sub_category  VARCHAR(50),
    pro_unit_price    VARCHAR(50),
    pro_quantity      VARCHAR(50),
    pro_total         VARCHAR(50),
    or_id             VARCHAR(50),
    or_status         VARCHAR(50),
    or_payment_method VARCHAR(50),
    or_purchase_date  VARCHAR(50),
    or_shipping_date  VARCHAR(50),
    or_delivery_date  VARCHAR(50)
);

-- Check
SELECT * FROM bronze.crm_data_info;
SELECT COUNT(*) FROM bronze.crm_data_info;