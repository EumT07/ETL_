CREATE OR REPLACE FUNCTION silver.load_silver_layer()
RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE
    load_start_time TIMESTAMP;
    load_end_time TIMESTAMP;
    batch_load_start_time TIMESTAMP;
    batch_load_end_time TIMESTAMP;
    v_error_state TEXT;
    v_error_msg TEXT;
    total_rows INTEGER;
BEGIN
    batch_load_start_time := NOW();
    RAISE NOTICE '=============================================';
    RAISE NOTICE 'Starting data load into silver layer...';
    RAISE NOTICE '=============================================';

    RAISE NOTICE 'CRM Tables..';

    load_start_time := NOW();
    RAISE NOTICE '----------------Customer Table----------------';
    RAISE NOTICE 'Truncating table: silver.crm_customers.';
    TRUNCATE TABLE silver.crm_customers CASCADE;
    RAISE NOTICE 'Loading data From csv into silver.crm_customers.';
    INSERT INTO silver.crm_customers(
        id,
        cst_crm_id,
        cst_first_name, 
        cst_last_name,
        cst_gender,
        cst_email,
        cst_birthdate,
        cst_address,
        cst_ads_source,
        cst_country
    )
    WITH customers AS (
        SELECT
            CASE
                WHEN LOWER(cst_id) LIKE 'cst-%' THEN REPLACE(LOWER(cst_id),'-','_')
                WHEN LOWER(cst_id) LIKE 'cst/%' THEN REPLACE(LOWER(cst_id),'/','_')
                WHEN LOWER(cst_id) LIKE 'customer-%' THEN REPLACE(REPLACE(LOWER(cst_id),'-','_'),'customer','cst')
                WHEN LOWER(cst_id) LIKE 'customer/%' THEN REPLACE(REPLACE(LOWER(cst_id),'/','_'),'customer','cst')
                WHEN LOWER(cst_id) LIKE 'customer_%' THEN REPLACE(LOWER(cst_id),'customer','cst')
                WHEN LOWER(cst_id) LIKE 'user-%' THEN REPLACE(REPLACE(LOWER(cst_id),'-','_'),'user','cst')
                WHEN LOWER(cst_id) LIKE 'user/%' THEN REPLACE(REPLACE(LOWER(cst_id),'/','_'),'user','cst')
                WHEN LOWER(cst_id) LIKE 'user_%' THEN REPLACE(LOWER(cst_id),'user','cst')
                ELSE LOWER(cst_id)
            END AS cst_id,
            CASE 
                WHEN crm_id LIKE '%-%' THEN REPLACE(crm_id,'-','_')
                ELSE crm_id
            END AS crm_id,
            TRIM(cst_first_name) AS cst_first_name,
            TRIM(cst_last_name) AS cst_last_name,
            CASE 
                WHEN LOWER(cst_gender) IN ('m','masculino','masc','male') THEN 'Male'
                WHEN LOWER(cst_gender) IN ('f','feminino','femenino','female', 'fem')THEN 'Female'
                ELSE 'No gender'
            END AS cst_gender,
            cst_email,
            cst_birthdate:: DATE,
            cst_address,
            CASE
                WHEN LOWER(cst_ads_source) IN ('facebook', 'fb','faceboo','facebok', 'fb_ads', 'face') THEN 'facebook'
                WHEN LOWER(cst_ads_source) IN ('ig', 'instagram', 'instagr', 'insta', 'ig_ads', 'instgram') THEN 'instagram'
                WHEN LOWER(cst_ads_source) IN ('tt', 'tik tok', 'tiktok', 'tik_tok', 'tiktok_ads','tiktokk', 'tktk') THEN 'tiktok'
                WHEN LOWER(cst_ads_source) IN ('google', 'goog', 'good', 'ggl', 'googleads','google_ads', 'g_ads', 'googl_ads') THEN 'google'
                WHEN LOWER(cst_ads_source) IN ('yt', 'youtube', 'you_tube', 'you_tub', 'youtub', 'yt_ads', 'youtube_ads') THEN 'youtube'
                WHEN LOWER(cst_ads_source) IN ('amz', 'amazon', 'amazn', 'amazon_ads', 'amzn') THEN 'amazon'
                WHEN LOWER(cst_ads_source) IN ('meli', 'mercadolibre','mercado_libre', 'm_libre', 'mercadolibr') THEN 'mercadolibre'
                WHEN LOWER(cst_ads_source) IN ('x', 'tw', 'twitter', 'titter_ads', 'x_ads', 'twiter') THEN 'x'
                WHEN LOWER(cst_ads_source) IN ('li', 'linkedin', 'linkdin', 'linkedin_ads') THEN 'linkedin'
                WHEN LOWER(cst_ads_source) IN ('pinterest', 'pin', 'pinteres', 'pintrst', 'pin_ads', 'pinterest_ads') THEN 'pinterest'
                WHEN LOWER(cst_ads_source) IN ('bing', 'bingads', 'bing_ads', 'msn', 'msn_ads', 'microsoft_ads') THEN 'microsoft'
                WHEN LOWER(cst_ads_source) IN ('ebay', 'e-bay', 'eby') THEN 'ebay'
                WHEN LOWER(cst_ads_source) IN ('walmart', 'wm', 'wallmart', 'walmart_ads') THEN 'walmart'
                WHEN LOWER(cst_ads_source) IN ('email', 'mail', 'mailchimp', 'klaviyo', 'e-mail') THEN 'email'
                WHEN LOWER(cst_ads_source) IN ('newsletter') THEN 'newsletter'
                WHEN LOWER(cst_ads_source) IN ('seo', 'organic', 'organico', 'search_organic') THEN 'seo'
                ELSE 'N/A'
            END AS cst_ads_source,
            CASE 
                WHEN LOWER(TRIM(cst_country)) IN ('ar', 'arg', 'argentina', 'arjentina', 'argentinna') THEN 'Argentina'
                WHEN LOWER(TRIM(cst_country)) IN ('br', 'bra', 'brazil', 'brasil') THEN 'Brasil'
                WHEN LOWER(TRIM(cst_country)) IN ('ca', 'can', 'canada', 'cananda', 'cAnada', 'canadá') THEN 'Canadá'
                WHEN LOWER(TRIM(cst_country)) IN ('cl', 'chl', 'chile', 'chil', 'chli', 'chille', 'cL') THEN 'Chile'
                WHEN LOWER(TRIM(cst_country)) IN ('co', 'col', 'colombia', 'colombia', 'colonbia', 'colom', 'cO', 'cOlombia') THEN 'Colombia'
                WHEN LOWER(TRIM(cst_country)) IN ('cr', 'cri', 'costa rica', 'costarica', 'costa rica') THEN 'Costa Rica'
                WHEN LOWER(TRIM(cst_country)) IN ('do', 'dom', 'rep dom', 'republica dominicana', 'r. dominicana', 'repdominicana', 'república dominicana', 'rep dominicana', 'repdom') THEN 'República Dominicana'
                WHEN LOWER(TRIM(cst_country)) IN ('ec', 'ecu', 'ecuador', 'ecudador', 'ecuandor') THEN 'Ecuador'
                WHEN LOWER(TRIM(cst_country)) IN ('sv', 'salv', 'slv', 'salvador', 'el salvador', 'elsalvador', 'el salvador') THEN 'El Salvador'
                WHEN LOWER(TRIM(cst_country)) IN ('hn', 'hnd', 'honduras', 'hond', 'hondura', 'onduras') THEN 'Honduras'
                WHEN LOWER(TRIM(cst_country)) IN ('mx', 'mex', 'mexico', 'méjico', 'mejico') THEN 'México'
                WHEN LOWER(TRIM(cst_country)) IN ('pa', 'pan', 'panama', 'panamá', 'panana') THEN 'Panamá'
                WHEN LOWER(TRIM(cst_country)) IN ('py', 'pry', 'paraguay', 'paraguai', 'paragay') THEN 'Paraguay'
                WHEN LOWER(TRIM(cst_country)) IN ('pe', 'per', 'peru', 'perú', 'pEru', 'perúu','peruú', 'peRú') THEN 'Perú'
                WHEN LOWER(TRIM(cst_country)) IN ('pr', 'pri', 'puerto rico', 'puertorico', 'pto rico') THEN 'Puerto Rico'
                WHEN LOWER(TRIM(cst_country)) IN ('us', 'usa', 'eeuu', 'united states', 'unites states', 'uSa') THEN 'United States'
                WHEN LOWER(TRIM(cst_country)) IN ('ve', 'ven', 'venezuela', 'venezual', 'venezla', 'venezuela', 'venzla') THEN 'Venezuela'
            ELSE 'Not Country Found'
            END AS cst_country,
            ROW_NUMBER() OVER(
                PARTITION BY
                CASE
                    WHEN LOWER(cst_id) LIKE 'cst-%' THEN REPLACE(LOWER(cst_id),'-','_')
                    WHEN LOWER(cst_id) LIKE 'cst/%' THEN REPLACE(LOWER(cst_id),'/','_')
                    WHEN LOWER(cst_id) LIKE 'customer-%' THEN REPLACE(REPLACE(LOWER(cst_id),'-','_'),'customer','cst')
                    WHEN LOWER(cst_id) LIKE 'customer/%' THEN REPLACE(REPLACE(LOWER(cst_id),'/','_'),'customer','cst')
                    WHEN LOWER(cst_id) LIKE 'customer_%' THEN REPLACE(LOWER(cst_id),'customer','cst')
                    WHEN LOWER(cst_id) LIKE 'user-%' THEN REPLACE(REPLACE(LOWER(cst_id),'-','_'),'user','cst')
                    WHEN LOWER(cst_id) LIKE 'user/%' THEN REPLACE(REPLACE(LOWER(cst_id),'/','_'),'user','cst')
                    WHEN LOWER(cst_id) LIKE 'user_%' THEN REPLACE(LOWER(cst_id),'user','cst')
                    ELSE LOWER(cst_id)
                END
                ORDER BY cst_id
            ) AS row_id
        FROM bronze.crm_data_info
    )
    SELECT
        cst_id,
        crm_id,
        cst_first_name,
        cst_last_name,
        cst_gender,
        cst_email,
        cst_birthdate,
        cst_address,
        cst_ads_source,
        cst_country
    FROM customers
    WHERE row_id = 1;
    RAISE NOTICE 'Data loaded.';
    GET DIAGNOSTICS total_rows = ROW_COUNT;
    RAISE NOTICE 'Rows affected: %', total_rows;
    load_end_time := NOW();
    RAISE NOTICE 'Data load completed in % seconds.', EXTRACT(EPOCH FROM (load_end_time - load_start_time));
    RAISE NOTICE '---------------------------------------------';


    load_start_time := NOW();
    RAISE NOTICE '----------------Products Table----------------';
    RAISE NOTICE 'Truncating table: silver.crm_products.';
    TRUNCATE TABLE silver.crm_products CASCADE;
    RAISE NOTICE 'Loading data From csv into silver.crm_products.';
    INSERT INTO silver.crm_products(
        id,
        pro_name,
        pro_brand,
        pro_category,
        pro_sub_category,
        pro_current_price
    )
    WITH products AS (
        SELECT
            CASE 
                WHEN pro_id LIKE '%-%' OR pro_id LIKE '%/%' THEN LOWER(REPLACE(REPLACE(pro_id,'/','_'),'-','_'))
                ELSE LOWER(pro_id)
            END AS pro_id,
            pro_name,
            CASE
                WHEN LOWER(pro_brand) IN ('apple','aple', 'appel') THEN 'apple'
                WHEN LOWER(pro_brand) IN ('asus','asuss', 'assus', 'asssus') THEN 'asus'
                WHEN LOWER(pro_brand) IN ('aser','acer', 'ascer', 'acser') THEN 'acer'
                WHEN LOWER(pro_brand) IN ('amd','ammd') THEN 'amd'
                WHEN LOWER(pro_brand) IN ('benq','benk','ben-q') THEN 'benq'
                WHEN LOWER(pro_brand) IN ('bose','boze','bozze') THEN 'bose'
                WHEN LOWER(pro_brand) IN ('corsair','cursair','corseir') THEN 'corsair'
                WHEN LOWER(pro_brand) IN ('crucial','crucialm') THEN 'crucial'
                WHEN LOWER(pro_brand) IN ('dell','del') THEN 'dell'
                WHEN LOWER(pro_brand) IN ('gigabyte') THEN 'gigabyte'
                WHEN LOWER(pro_brand) IN ('hp', 'hpp', 'h-p') THEN 'hp'
                WHEN LOWER(pro_brand) IN ('hyperx', 'hyper x') THEN 'hyperx'
                WHEN LOWER(pro_brand) IN ('intel', 'intl', 'inttel') THEN 'intel'
                WHEN LOWER(pro_brand) IN ('jbl', 'jbl audio', 'inttel') THEN 'jbl'
                WHEN LOWER(pro_brand) IN ('kigston','kingston') THEN 'kingston'
                WHEN LOWER(pro_brand) IN ('lg','l-g') THEN 'lg'
                WHEN LOWER(pro_brand) IN ('lenovo','lenv', 'lenobo') THEN 'lenovo'
                WHEN LOWER(pro_brand) IN ('logitec','logitech', 'logi') THEN 'logitech'
                WHEN LOWER(pro_brand) IN ('m-si','msi') THEN 'msi'
                WHEN LOWER(pro_brand) IN ('samsung', 'samsong', 'samsum') THEN 'samsung'
                WHEN LOWER(pro_brand) IN ('sony', 'soni', 'sonny') THEN 'sony'
                WHEN LOWER(pro_brand) IN ('razer', 'razer rgb', 'razr') THEN 'razer'
                WHEN LOWER(pro_brand) IN ('redragon', 'redragn') THEN 'redragon'
                ELSE 'Not brand'
            END AS pro_brand,
            pro_category,
            pro_sub_category,
            CASE
                WHEN pro_unit_price IS NULL THEN ROUND(pro_total::NUMERIC / pro_quantity::NUMERIC, 2)
                WHEN pro_unit_price LIKE '$%' THEN ROUND(CAST(REPLACE(pro_unit_price,'$','') AS NUMERIC),2)
                ELSE ROUND(pro_unit_price::NUMERIC,2)
            END AS pro_unit_price,
            ROW_NUMBER() OVER (
                PARTITION BY
                CASE 
                    WHEN pro_id LIKE '%-%' OR pro_id LIKE '%/%' THEN REPLACE(REPLACE(pro_id,'/','_'),'-','_')
                    ELSE pro_id
                END
                ORDER BY pro_id
            ) AS row_id
        FROM bronze.crm_data_info
    )
    SELECT
        pro_id,
        pro_name,
        pro_brand,
        pro_category,
        pro_sub_category,
        pro_unit_price
    FROM products
    WHERE row_id = 1;
    RAISE NOTICE 'Data loaded.';
    GET DIAGNOSTICS total_rows = ROW_COUNT;
    RAISE NOTICE 'Rows affected: %', total_rows;
    load_end_time := NOW();
    RAISE NOTICE 'Data load completed in % seconds.', EXTRACT(EPOCH FROM (load_end_time - load_start_time));
    RAISE NOTICE '---------------------------------------------';

    load_start_time := NOW();
    RAISE NOTICE '----------------Order Table----------------';
    RAISE NOTICE 'Truncating table: silver.crm_orders.';
    TRUNCATE TABLE silver.crm_orders CASCADE;
    RAISE NOTICE 'Loading data From csv into silver.crm_orders.';
    INSERT INTO silver.crm_orders(
        id,
        or_customer_id,
        or_status,
        or_payment_method,
        or_purchase_date,
        or_shipping_date,
        or_delivery_date,
        or_order_total
    )
    SELECT
        CASE 
            WHEN crm_id LIKE 'ASTT-%' OR crm_id LIKE 'ASTT_%' THEN CONCAT('or','_',REPLACE(SUBSTRING(crm_id,6,length(crm_id)),'-','_'))
            ELSE crm_id
        END AS crm_id,
        CASE
            WHEN LOWER(cst_id) LIKE 'cst-%' THEN REPLACE(LOWER(cst_id),'-','_')
            WHEN LOWER(cst_id) LIKE 'cst/%' THEN REPLACE(LOWER(cst_id),'/','_')
            WHEN LOWER(cst_id) LIKE 'customer-%' THEN REPLACE(REPLACE(LOWER(cst_id),'-','_'),'customer','cst')
            WHEN LOWER(cst_id) LIKE 'customer/%' THEN REPLACE(REPLACE(LOWER(cst_id),'/','_'),'customer','cst')
            WHEN LOWER(cst_id) LIKE 'customer_%' THEN REPLACE(LOWER(cst_id),'customer','cst')
            WHEN LOWER(cst_id) LIKE 'user-%' THEN REPLACE(REPLACE(LOWER(cst_id),'-','_'),'user','cst')
            WHEN LOWER(cst_id) LIKE 'user/%' THEN REPLACE(REPLACE(LOWER(cst_id),'/','_'),'user','cst')
            WHEN LOWER(cst_id) LIKE 'user_%' THEN REPLACE(LOWER(cst_id),'user','cst')
            ELSE LOWER(cst_id)
        END AS cst_id,
        or_status,
        or_payment_method,
        or_purchase_date::Date,
        or_shipping_date::Date,
        or_delivery_date::Date,
        CASE
            WHEN pro_total LIKE '$%' THEN ROUND(CAST(REPLACE(pro_total,'$','') AS NUMERIC),2)
            ELSE ROUND(pro_total::NUMERIC,2)
        END AS pro_total
    FROM bronze.crm_data_info;
    RAISE NOTICE 'Data loaded.';
    GET DIAGNOSTICS total_rows = ROW_COUNT;
    RAISE NOTICE 'Rows affected: %', total_rows;
    load_end_time := NOW();
    RAISE NOTICE 'Data load completed in % seconds.', EXTRACT(EPOCH FROM (load_end_time - load_start_time));
    RAISE NOTICE '---------------------------------------------';

    load_start_time := NOW();
    RAISE NOTICE '----------------Order Items Table----------------';
    RAISE NOTICE 'Truncating table: silver.crm_order_items.';
    TRUNCATE TABLE silver.crm_order_items CASCADE;
    RAISE NOTICE 'Loading data From csv into silver.crm_order_items.';
    INSERT INTO silver.crm_order_items(
        itm_order_id,
        itm_product_id,
        itm_quantity,
        itm_price,
        itm_reviews
    )
    SELECT
        CASE 
            WHEN crm_id LIKE 'ASTT-%' OR crm_id LIKE 'ASTT_%' THEN CONCAT('or','_',REPLACE(SUBSTRING(crm_id,6,length(crm_id)),'-','_'))
            ELSE crm_id
        END AS crm_id,
        CASE 
            WHEN pro_id LIKE '%-%' OR pro_id LIKE '%/%' THEN LOWER(REPLACE(REPLACE(pro_id,'/','_'),'-','_'))
            ELSE LOWER(pro_id)
        END AS pro_id,
        CASE
            WHEN pro_quantity IS NULL
                AND pro_total LIKE '$%'
                AND pro_unit_price LIKE '$%' 
                THEN ROUND(REPLACE(pro_total,'$','')::NUMERIC / REPLACE(pro_unit_price,'$','')::NUMERIC, 0)
            WHEN pro_quantity IS NULL 
                AND pro_total NOT LIKE '$%'
                AND pro_unit_price LIKE '$%' 
                THEN ROUND(pro_total::NUMERIC  / REPLACE(pro_unit_price,'$','')::NUMERIC, 0)
            WHEN pro_quantity IS NULL 
                AND pro_total LIKE '$%'
                AND pro_unit_price NOT LIKE '$%' 
                THEN ROUND(REPLACE(pro_total,'$','')::NUMERIC / pro_unit_price::NUMERIC, 0)
            WHEN pro_quantity IS NULL 
                AND pro_total NOT LIKE '$%'
                AND pro_unit_price NOT LIKE '$%' 
                THEN ROUND(REPLACE(pro_total,'$','')::NUMERIC / pro_unit_price::NUMERIC, 0)
            ELSE ROUND(pro_quantity::NUMERIC,0)
        END AS pro_quantity,
        CASE
            WHEN pro_unit_price IS NULL THEN ROUND(pro_total::NUMERIC / pro_quantity::NUMERIC, 2)
            WHEN pro_unit_price LIKE '$%' THEN ROUND(CAST(REPLACE(pro_unit_price,'$','') AS NUMERIC),2)
            ELSE ROUND(pro_unit_price::NUMERIC,2)
        END AS pro_unit_price,
        cst_reviews::INTEGER
    FROM bronze.crm_data_info;
    RAISE NOTICE 'Data loaded.';
    GET DIAGNOSTICS total_rows = ROW_COUNT;
    RAISE NOTICE 'Rows affected: %', total_rows;
    load_end_time := NOW();
    RAISE NOTICE 'Data load completed in % seconds.', EXTRACT(EPOCH FROM (load_end_time - load_start_time));
    RAISE NOTICE '---------------------------------------------';
EXCEPTION
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS 
            v_error_state = RETURNED_SQLSTATE,
            v_error_msg = MESSAGE_TEXT;
            RAISE WARNING '¡ETL Error!';
            RAISE WARNING 'SQLState Code: %', v_error_state;
            RAISE WARNING 'Error Message: %', v_error_msg;
END;
$$;

SELECT silver.load_silver_layer();