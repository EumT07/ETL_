CREATE OR REPLACE FUNCTION bronze.load_bronze_layer()
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
    RAISE NOTICE 'Starting data load into bronze layer...';
    RAISE NOTICE '=============================================';

    RAISE NOTICE 'CRM Tables..';

    load_start_time := NOW();
    RAISE NOTICE '----------------Data info----------------';
    RAISE NOTICE 'Truncating table: bronze.crm_data_info.';
    TRUNCATE TABLE bronze.crm_data_info;
    RAISE NOTICE 'Loading data From csv into bronze.crm_data_info.';
    COPY bronze.crm_data_info
    FROM 'C:\Program Files\PostgreSQL\18\pgAdmin 4\etl_process\crm_data.csv'
    WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'UTF8');
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

CREATE OR REPLACE FUNCTION bronze.check_bronze_data()
RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE
    v_error_state TEXT;
    v_error_msg TEXT;
    total_rows INTEGER;
    columns_list TEXT;
BEGIN
    SELECT COUNT(*)
    INTO total_rows
    FROM bronze.crm_data_info;

    SELECT STRING_AGG(column_name,', ' )
    INTO columns_list
    FROM information_schema.columns 
    WHERE table_schema = 'bronze' AND table_name = 'crm_data_info';

    RAISE NOTICE 'Checking data in bronze tables...';
    RAISE NOTICE '---------------------------------------------';
    RAISE NOTICE 'Table: bronze.crm_data_info, Row Count: %', total_rows;
    RAISE NOTICE '---------------------------------------------';
    RAISE NOTICE 'Table columns info: %', columns_list;
    RAISE NOTICE '---------------------------------------------';
    RAISE NOTICE 'Data check completed.';
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

SELECT * FROM bronze.load_bronze_layer();
SELECT * FROM bronze.check_bronze_data();