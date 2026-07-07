SELECT
    cst_id,
    COUNT(cst_id) AS total_customers
FROM bronze.crm_data_info
GROUP BY cst_id;

SELECT * FROM bronze.crm_data_info;
-- Customer

SELECT
    crm_id,
    cst_id,
    cst_first_name,
    cst_last_name,
    cst_birthdate,
    cst_email,
    cst_address,
    cst_gender,
    cst_reviews
FROM bronze.crm_data_info;


SELECT
    crm_id,
    pro_id,
    pro_name,
    pro_brand,
    pro_category,
    pro_sub_category,
    pro_unit_price,
    pro_quantity,
    pro_total
FROM bronze.crm_data_info;


SELECT
    crm_id,
    or_id,
    or_status,
    or_payment_method,
    or_purchase_date,
    or_shipping_date,
    or_delivery_date
FROM bronze.crm_data_info;