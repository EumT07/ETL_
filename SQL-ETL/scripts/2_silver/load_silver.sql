
SELECT * FROM bronze.crm_data_info;

-- Customer

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
        WHEN LOWER(TRIM(cst_country)) IN ('ar', 'arg', 'argentina', 'arjentina', 'argentinna') THEN 'Argentina'
        WHEN LOWER(TRIM(cst_country)) IN ('br', 'bra', 'brazil', 'brasil') THEN 'Brasil'
        WHEN LOWER(TRIM(cst_country)) IN ('ca', 'can', 'canada', 'cananda', 'cAnada') THEN 'Canadá'
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
    END AS cst_country
FROM bronze.crm_data_info;


-- Product
SELECT
    CASE 
        WHEN pro_id LIKE '%-%' OR pro_id LIKE '%/%' THEN REPLACE(REPLACE(pro_id,'/','_'),'-','_')
        ELSE pro_id
    END AS pro_id,
    pro_name,
    CASE
        WHEN LOWER(pro_brand) IN ('apple','aple', 'appel') THEN 'apple'
        WHEN LOWER(pro_brand) IN ('asus','asuss', 'assus') THEN 'asus'
        WHEN LOWER(pro_brand) IN ('aser','acer', 'ascer') THEN 'acer'
        WHEN LOWER(pro_brand) IN ('amd','ammd') THEN 'amd'
        WHEN LOWER(pro_brand) IN ('benq','benk','ben-q') THEN 'benq'
        WHEN LOWER(pro_brand) IN ('bose','boze','bozze') THEN 'bose'
        WHEN LOWER(pro_brand) IN ('corsair','cursair','corseir') THEN 'corsair'
        WHEN LOWER(pro_brand) IN ('crucial','crucialm') THEN 'crucial'
        WHEN LOWER(pro_brand) IN ('dell','del') THEN 'dell'
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
        ELSE 'No brand'
    END AS pro_brand,
    pro_category,
    pro_sub_category,
    CASE
        WHEN pro_unit_price IS NULL THEN ROUND(pro_total::NUMERIC / pro_quantity::NUMERIC, 2)
        WHEN pro_unit_price LIKE '$%' THEN ROUND(CAST(REPLACE(pro_unit_price,'$','') AS NUMERIC),2)
        ELSE ROUND(pro_unit_price::NUMERIC,2)
    END AS pro_unit_price
FROM bronze.crm_data_info;


SELECT
    CASE 
        WHEN or_id LIKE '%-%' OR or_id LIKE '%/%' THEN REPLACE(REPLACE(or_id,'/','_'),'-','_')
        ELSE or_id
    END AS or_id,
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


SELECT
    CASE 
        WHEN or_id LIKE '%-%' OR or_id LIKE '%/%' THEN REPLACE(REPLACE(or_id,'/','_'),'-','_')
        ELSE or_id
    END AS or_id,
    CASE 
        WHEN pro_id LIKE '%-%' OR pro_id LIKE '%/%' THEN REPLACE(REPLACE(pro_id,'/','_'),'-','_')
        ELSE pro_id
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
    cst_reviews
FROM bronze.crm_data_info;