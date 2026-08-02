SELECT * FROM silver.crm_customers;
SELECT * FROM silver.crm_products1;
SELECT * FROM silver.crm_orders;
SELECT * FROM silver.crm_order_items;

/*
    * 1. Title: Basic Customer List Retrieval *
    - Context: The customer support team needs a master list of all registered customers and their primary contact details to update their communication logs.
    - Question: Write a query to retrieve the first name, last name, email, and country of all customers.
    - Difficulty: Junior
    - Expected Output: cst_first_name, cst_last_name, cst_email, cst_country
    - Hint: Query only the customers table without filtering or joins.
    - Business Value: Provides operational teams with direct access to user contact records.
*/

SELECT
    cst_first_name,
    cst_last_name,
    cst_email,
    cst_country
FROM silver.crm_customers;

/*
    *2. Title: Active Orders Filter*
    - Context: Operations needs to see all current orders that have been successfully delivered so they can issue digital receipts.
    - Question: Write a query to find all orders where the order status is 'delivered'. Show order ID, customer ID, purchase date, and total amount.
    - Difficulty: Junior
    - Expected Output: id, or_customer_id, or_purchase_date, or_order_total
    - Hint: Use a standard WHERE clause on the or_status column.
    - Business Value: Isolates successful transactions for financial and operational auditing.
*/

SELECT
    id,
    or_customer_id,
    or_purchase_date,
    or_order_total
FROM silver.crm_orders
WHERE or_status = 'delivered';

/*
    *3. Title: Top 10 Most Expensive Products
    - Context: Merchandising wants to identify high-ticket items in the inventory to highlight in premium marketing catalogs.
    - Question: Retrieve the top 10 products with the highest current price.
    - Difficulty: Junior
    - Expected Output: pro_name, pro_brand, pro_category, pro_current_price
    - Hint: Sort the records in descending order by pro_current_price and limit the output.
    - Business Value: Enables targeted marketing campaigns for high-margin products.
*/

SELECT
    pro_name,
    pro_brand,
    pro_category,
    pro_current_price
FROM silver.crm_products
ORDER BY pro_current_price DESC
LIMIT 10;

/*
    *4. Title: Customers from Specific Acquisition Channels*
    - Context: The performance marketing team wants to analyze users acquired via organic search to evaluate search engine optimization (SEO) efforts.
    - Question: Write a query to find all customers whose acquisition source (cst_ads_source) is 'Organic Search' or 'SEO'.
    - Difficulty: Junior
    - Expected Output: id, cst_first_name, cst_last_name, cst_email, cst_ads_source
    - Hint: Filter string values using an exact text match in the WHERE clause.
    - Business Value: Measures the volume of unpaid organic acquisition for channel evaluation.
*/

SELECT
    id,
    cst_first_name,
    cst_last_name,
    cst_email,
    cst_ads_source
FROM silver.crm_customers
WHERE cst_ads_source = 'seo';

/*
    *5. Title: Order Count by Payment Method*
    - Context: Finance needs to know which payment methods are most popular to negotiate better processing fees with vendor platforms.
    - Question: Count the total number of orders placed using each payment method.
    - Difficulty: Junior
    - Expected Output: or_payment_method, total_orders
    - Hint: Group by the payment method column and use COUNT().
    - Business Value: Optimizes payment gateway contracts based on user preference volume.
*/

SELECT
    or_payment_method,
    COUNT(*) AS total_orders
FROM silver.crm_orders
GROUP BY or_payment_method;

/*
    *6. Title: Average Order Value (AOV) Overall*
    - Context: Leadership wants a single baseline KPI figure representing the company's overall Average Order Value across all sales.
    - Question: Calculate the average order total across all records in the orders table.
    - Difficulty: Junior
    - Expected Output: overall_aov
    - Hint: Use the AVG() aggregate function on or_order_total.
    - Business Value: Establishes a fundamental benchmark for measuring revenue growth.
*/

SELECT
    AVG(or_order_total) overall_aov
FROM silver.crm_orders;

/*
    *7. Title: High-Value Orders*
    - Context: Risk management wants to review transactions over $500 to check for potential fraudulent activity.
    - Question: Select all orders where the order total is greater than 500.00, sorted from highest to lowest total.
    - Difficulty: Junior
    - Expected Output: id, or_customer_id, or_purchase_date, or_order_total
    - Hint: Combine a numeric WHERE filter with ORDER BY ... DESC.
    - Business Value: Mitigates financial loss by flagging large transactions for security checks.
*/

SELECT
    id,
    or_customer_id,
    or_purchase_date,
    or_order_total
FROM silver.crm_orders
WHERE or_order_total > 500
ORDER BY or_order_total DESC;

/*
    *8. Title: Count of Customers by Country*
    - Context: International expansion teams need to know where the existing customer base is concentrated geographically.
    - Question: Calculate the total number of registered customers in each country.
    - Difficulty: Junior
    - Expected Output: cst_country, total_customers
    - Hint: Use GROUP BY cst_country and order results from highest to lowest count.
    - Business Value: Informs localized marketing spend and logistics planning.
*/

SELECT
    cst_country,
    COUNT(*) AS total_customers
FROM silver.crm_customers
GROUP BY cst_country
ORDER BY COUNT(*) DESC;

/*
    *9. Title: Products per Category Count*
    - Context: Catalog management is auditing product diversity across different store departments.
    - Question: Find the total number of unique products offered in each product category.
    - Difficulty: Junior
    - Expected Output: pro_category, total_products
    - Hint: Perform a GROUP BY on pro_category counting product IDs.
    - Business Value: Ensures balanced catalog representation across product lines.
*/

SELECT
    pro_category,
    COUNT(DISTINCT id) AS total_products
FROM silver.crm_products
GROUP BY pro_category;

/*
    *10. Title: Unassigned or Missing Birthdates*
    - Context: CRM marketing is planning a birthday discount program but needs to know how many customer profiles lack birthday data.
    - Question: Find all customer profiles where cst_birthdate is NULL.
    - Difficulty: Junior
    - Expected Output: id, cst_first_name, cst_last_name, cst_email
    - Hint: Filter using IS NULL in your conditional predicate.
    - Business Value: Identifies data enrichment opportunities for customer profiles.
*/

SELECT
    id,
    cst_first_name,
    cst_last_name,
    cst_email
FROM silver.crm_customers
WHERE cst_birthdate IS NULL;

/*
    *11. Title: Total Revenue Generated
    - Context: Executive management requires a total gross revenue figure from all completed orders.
    - Question: Calculate the total sum of or_order_total for all orders with a status of 'delivered'.
    - Difficulty: Junior
    - Expected Output: total_revenue
    - Hint: Apply SUM() with a WHERE filter for order status.
    - Business Value: Provides primary financial performance metric on top-line sales.
*/

SELECT
    SUM(or_order_total) AS total_revenue
FROM silver.crm_orders
WHERE or_status = 'delivered';

/*
    *12. Title: Orders Placed in a Specific Year
    - Context: Accounting needs a list of all orders completed in the year 2024 for annual reporting.
    - Question: Retrieve all orders placed between '2024-01-01' and '2024-12-31'.
    - Difficulty: Junior
    - Expected Output: id, or_customer_id, or_purchase_date, or_order_total
    - Hint: Filter using date range comparisons or the YEAR() function on or_purchase_date.
    - Business Value: Ensures compliance with tax and financial reporting schedules.
*/

SELECT
    id,
    or_customer_id,
    or_purchase_date,
    or_order_total
FROM silver.crm_orders
WHERE or_purchase_date BETWEEN '2024-01-01' AND '2024-12-31'
ORDER BY or_purchase_date ASC;

-- OR

SELECT
    id,
    or_customer_id,
    or_purchase_date,
    or_order_total
FROM silver.crm_orders
WHERE EXTRACT(YEAR FROM or_purchase_date) = 2024
ORDER BY or_purchase_date ASC;

/*
    *13. Title: Distinct Brands Offered
    - Context: Branding teams want a clean, unique list of all brands currently available in the catalog.
    - Question: List all unique product brands available in the products table, alphabetized.
    - Difficulty: Junior
    - Expected Output: pro_brand
    - Hint: Use the DISTINCT keyword with an ORDER BY clause.
    - Business Value: Displays active vendor partnerships for promotional planning.
*/

SELECT DISTINCT
    pro_brand
FROM silver.crm_products
ORDER BY pro_brand;

/*
    *14. Title: Customer First and Last Orders (Basic Join)
    - Context: Support agents need to see customer names alongside order numbers when reviewing tickets.
    - Question: Display the order ID, purchase date, total amount, and customer full name (cst_first_name + cst_last_name) for the 20 most recent orders.
    - Difficulty: Junior
    - Expected Output: order_id, or_purchase_date, or_order_total, customer_name
    - Hint: Perform an INNER JOIN between orders and customers on customer ID.
    - Business Value: Streamlines support desk operations with combined user-order context.
*/

SELECT
    ord.id AS order_id,
    ord.or_purchase_date,
    ord.or_order_total,
    cst.cst_first_name || ' ' || cst.cst_last_name AS customer_name
FROM silver.crm_orders AS ord
INNER JOIN silver.crm_customers AS cst
ON ord.or_customer_id = cst.id
ORDER BY ord.or_purchase_date DESC
LIMIT 20;


/*
    *15. Title: Total Quantity Sold per Product
    - Context: Inventory planners want to see simple unit sales metrics per product ID.
    - Question: Calculate the total units sold (itm_quantity) for each product ID in the order_item table.
    - Difficulty: Junior
    - Expected Output: itm_product_id, total_units_sold
    - Hint: Group by itm_product_id and apply SUM(itm_quantity).
    - Business Value: Prevents stockouts by tracking unit demand metrics.
*/

SELECT
    itm_product_id,
    SUM(itm_quantity) AS total_units_sold
FROM silver.crm_order_items
GROUP BY itm_product_id;

-- *16. Title: Orders with Specific Payment and Status
-- - Context: Fraud prevention wants to flag orders paid via 'Credit Card' that are still 'Pending'.
-- - Question: Find all orders paid via 'Credit Card' that currently have a status of 'Pending'.
-- - Difficulty: Junior
-- - Expected Output: id, or_customer_id, or_purchase_date, or_order_total
-- - Hint: Combine multiple conditions using the AND operator in WHERE.
-- - Business Value: Prioritizes pending payments for automated payment processor checks.

SELECT
    id,
    or_customer_id,
    or_purchase_date,
    or_order_total
FROM silver.crm_orders
WHERE or_payment_method = 'credit_card' AND or_status = 'pending';

/*
    *17. Title: Product Price Categorization
    - Context: Pricing teams want to label items as 'Budget', 'Standard', or 'Premium' based on list price.
    - Question: Write a query displaying product name, price, and a new column price_tier: 'Budget' if under $50, 'Standard' if $50–$150, and 'Premium' if over $150.
    - Difficulty: Junior
    - Expected Output: pro_name, pro_current_price, price_tier
    - Hint: Use a basic conditional CASE statement.
    - Business Value: Establishes price point tiers for catalog navigation filtering.
*/

SELECT
    pro_name,
    pro_current_price,
    CASE
        when pro_current_price < 50 THEN 'Budget'
        when pro_current_price >= 50 AND pro_current_price <= 150 THEN 'Standard'
        ELSE 'Premium'
    END AS price_tier
FROM silver.crm_products;

/*
    *18. Title: Products Belonging to Specific Categories
    - Context: Category managers want a list of products in either the 'Electronics' or 'Appliances' categories.
    - Question: Retrieve product name, category, and price for items in 'Electronics' or 'Appliances'.
    - Difficulty: Junior
    - Expected Output: pro_name, pro_category, pro_current_price
    - Hint: Use the IN operator in the filtering clause.
    - Business Value: Facilitates category-specific marketing and promotion builds.
*/

SELECT
    pro_name,
    pro_category,
    pro_current_price
FROM silver.crm_products
WHERE pro_category IN ('Electronics', 'Appliances');

/*
    *19. Title: Orders Shipped Later Than Purchase Date
    - Context: Fulfillment managers need to review all shipments that were not dispatched on the exact same day they were ordered.
    - Question: List all orders where or_shipping_date is greater than or_purchase_date.
    - Difficulty: Junior
    - Expected Output: id, or_purchase_date, or_shipping_date, or_status
    - Hint: Compare two date/datetime columns directly in the WHERE clause.
    - Business Value: Flags potential warehouse processing delays for SLA monitoring.
*/

SELECT
    id,
    or_purchase_date,
    or_shipping_date,
    or_status
FROM silver.crm_orders
WHERE or_shipping_date > or_purchase_date;

/*
    20. Title: Customer Gender Distribution
    - Context: Demographic researchers want to analyze the breakdown of registered users by gender.
    - Question: Count the total number of customers for each gender recorded in the database.
    - Difficulty: Junior
    - Expected Output: cst_gender, customer_count
    - Hint: Group by cst_gender and use COUNT(*).
    - Business Value: Informs demographic-targeted marketing strategies and creative assets.
*/

SELECT
    cst_gender,
    COUNT(*) AS customer_count
FROM silver.crm_customers
GROUP BY cst_gender;

-- tips: COALESCE(cst_gender, 'Not Specified') AS cst_gender in case you find NULL values in the gender column to ensure

/*
    21. Title: Lowest and Highest Product Prices
    - Context: Merchandising wants to evaluate the minimum and maximum price points currently in the product catalog.
    - Question: Find the minimum price and maximum price across all products in a single row.
    - Difficulty: Junior
    - Expected Output: min_price, max_price
    - Hint: Use MIN() and MAX() aggregate functions together without a GROUP BY.
    - Business Value: Defines the price boundaries of the store's current inventory.
*/

SELECT
    MIN(pro_current_price) AS min_price,
    MAX(pro_current_price) AS max_price
FROM silver.crm_products
WHERE pro_current_price > 0;

/*
    22. Title: Orders by Single Customer
    - Context: Customer service needs a transaction history for a specific customer with id = 101.
    - Question: Retrieve all orders placed by customer ID 101, ordered by purchase date descending.
    - Difficulty: Junior
    - Expected Output: id, or_purchase_date, or_status, or_order_total
    - Hint: Filter specifically by or_customer_id = 101.
    - Business Value: Assists agents during direct customer communication and account reviews.
*/

SELECT 
    id,
    or_customer_id,
    or_purchase_date,
    or_status,
    or_order_total
FROM silver.crm_orders
WHERE or_customer_id = 'cst_101'
ORDER BY or_purchase_date DESC;

/*
    *23. Title: Search Products by Keyword
    - Context: Site search leads want to verify which product titles contain the keyword 'Wireless'.
    - Question: Select product name, brand, and price for all products whose name contains the word 'Wireless'.
    - Difficulty: Junior
    - Expected Output: pro_name, pro_brand, pro_current_price
    - Hint: Use the LIKE operator with wildcard characters (%Wireless%).
    - Business Value: Validates search engine metadata and product title naming conventions.
*/

SELECT 
    pro_name,
    pro_brand,
    pro_current_price
FROM silver.crm_products
WHERE LOWER(pro_name) LIKE '%wireless%';

/*
    24. Title: Total Items Purchased in Order
    - Context: Warehouse packing staff needs to see how many total line items were included in order ID 500.
    - Question: Calculate the total number of items (SUM(itm_quantity)) for order ID 500.
    - Difficulty: Junior
    - Expected Output: itm_order_id, total_items_in_order
    - Hint: Filter order_item by itm_order_id = 500.
    - Business Value: Ensures correct packing box sizes based on item quantities.
*/

SELECT 
    itm_order_id,
    SUM(itm_quantity) AS total_items_in_order
FROM silver.crm_order_items
WHERE itm_order_id LIKE '%500'
GROUP BY itm_order_id;

/*
    *25. Title: Delivered Orders Analysis
    - Context: Customer Experience wants to monitor the volume of delivered transactions.
    - Question: Count the number of orders with a status of 'Delivered' grouped by or_payment_method.
    - Difficulty: Junior
    - Expected Output: or_payment_method, delivered_orders_count
    - Hint: Filter by status 'Delivered' before applying GROUP BY.
    - Business Value: Highlights payment gateways with high delivery rates.
*/

SELECT
    or_payment_method,
    COUNT(*) AS delivered_orders_count 
FROM silver.crm_orders
WHERE or_status ILIKE '%Delivered%'
GROUP BY or_payment_method;

/*
    *26. Title: Customers born before 1990
    - Context: Retention teams want to run a win-back campaign targeting accounts opened in 2023.
    - Question: List customer first name, last name, email, and birthdate for customers born before 1990.
    - Difficulty: Junior
    - Expected Output: cst_first_name, cst_last_name, cst_email, cst_birthdate
    - Hint: Use date comparisons on cst_birthdate < '1990-01-01'.
    - Business Value: Supports demographic-based promotional targeting.
*/

SELECT
    cst_first_name,
    cst_last_name,
    cst_email,
    cst_birthdate
FROM silver.crm_customers
WHERE cst_birthdate < '1990-01-01';

/*
    27. Title: Average Price of Products per Brand
    - Context: Pricing teams are conducting a competitive brand positioning study.
    - Question: Find the average product price for each brand. Show brand and average price rounded to 2 decimal places.
    - Difficulty: Junior
    - Expected Output: pro_brand, avg_brand_price
    - Hint: Combine AVG(), ROUND(), and GROUP BY pro_brand.
    - Business Value: Identifies high-cost vs. discount vendor catalog partners.
*/

SELECT
    pro_brand,
    ROUND(AVG(pro_current_price),2) AS avg_brand_price
FROM silver.crm_products
GROUP BY pro_brand;

/*
28. Title: Order Items with Customer Reviews
Context: Product teams want to inspect text feedback provided on order line items.
Question: Select product ID, order ID, and review text for all order items where itm_reviews is NOT NULL.
Difficulty: Junior
Expected Output: itm_product_id, itm_order_id, itm_reviews
Hint: Filter using IS NOT NULL.
Business Value: Extracts qualitative customer feedback for product improvements.
*/

SELECT
    itm_product_id,
    itm_order_id,
    itm_reviews
FROM silver.crm_order_items
WHERE itm_reviews IS NOT NULL;


/*
29. Title: Subcategory Count per Category
Context: Catalog taxonomists want to see how many subcategories exist under each primary product category.
Question: Find the number of unique subcategories (pro_sub_category) under each category (pro_category).
Difficulty: Junior
Expected Output: pro_category, unique_subcategories
Hint: Combine COUNT(DISTINCT pro_sub_category) with GROUP BY pro_category.
Business Value: Ensures consistent navigation hierarchy across site departments.
*/

SELECT
    pro_category,
    COUNT(DISTINCT pro_sub_category) AS unique_subcategories
FROM silver.crm_products
GROUP BY pro_category;

/*
30. Title: Recent High-Volume Shipping Destination Countries
Context: Logistics partners want to see orders shipped to 'USA', 'Canada', or 'UK'.
Question: Select order ID, purchase date, shipping date, and customer country for orders from customers in 'United States', 'canadá', or 'colombia'.
Difficulty: Junior
Expected Output: order_id, or_purchase_date, cst_country
Hint: Join orders and customers tables and use the IN filter on country.
*/

SELECT
    ord.id,
    ord.or_purchase_date,
    cst.cst_country
FROM silver.crm_orders AS ord
INNER JOIN silver.crm_customers AS cst
ON ord.or_customer_id = cst.id
WHERE LOWER(cst.cst_country) IN ('united states', 'canadá', 'colombia');