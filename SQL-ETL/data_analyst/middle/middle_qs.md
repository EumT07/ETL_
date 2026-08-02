🟡 Middle Level (30 Questions)
Question 31
Title: Customer Monthly Purchase Frequency Analysis

Context: The CRM team wants to identify customers who are becoming less engaged with the platform to target them with re-engagement campaigns.

Question: For each customer, calculate their average monthly order count, latest order date, and total amount spent. Show only customers who have placed at least 3 orders.

Difficulty: Middle

Expected Output: customer_id, full_name, avg_monthly_orders, latest_order_date, total_spent

Hint: Use EXTRACT or date formatting with GROUP BY customer and filter using a HAVING clause on total order count.

Business Value: Helps identify at-risk customers and drive re-engagement strategies.

Question 32
Title: Most Recent Order per Customer (Window Function)

Context: Customer support reps need a quick view of every customer's single most recent purchase details.

Question: Write a query using ROW_NUMBER() to return each customer's most recent order details (order ID, purchase date, order total).

Difficulty: Middle

Expected Output: or_customer_id, id, or_purchase_date, or_order_total

Hint: Partition by or_customer_id and order by or_purchase_date DESC inside a CTE, then filter WHERE row_num = 1.

Business Value: Streamlines support portal lookups with immediate recent order context.

Question 33
Title: Category Rank by Sales Volume

Context: Brand managers want to rank products within their respective categories based on total volume sold.

Question: Calculate total units sold per product, and use DENSE_RANK() to rank products within each pro_category.

Difficulty: Middle

Expected Output: pro_category, pro_name, total_units_sold, category_rank

Hint: Aggregate sales in a CTE, then apply DENSE_RANK() OVER(PARTITION BY pro_category ORDER BY total_units_sold DESC).

Business Value: Identifies market-leading products within individual store departments.

Question 34
Title: Running Monthly Revenue Cumulative Total

Context: Financial planning needs a cumulative running total of monthly revenue throughout the calendar year.

Question: Calculate total monthly revenue and compute a running cumulative sum of revenue ordered chronologically by month.

Difficulty: Middle

Expected Output: sales_year, sales_month, monthly_revenue, running_cumulative_revenue

Hint: Group revenue by year and month, then use SUM(monthly_revenue) OVER(ORDER BY sales_year, sales_month).

Business Value: Tracks year-to-date performance against annual financial growth targets.

Question 35
Title: Days Elapsed Between Consecutive Customer Orders

Context: Loyalty teams want to understand the repurchase velocity of repeat buyers.

Question: Calculate the number of days elapsed between a customer's current order purchase date and their immediately preceding order purchase date using LAG().

Difficulty: Middle

Expected Output: or_customer_id, id, or_purchase_date, prev_order_date, days_since_prior_order

Hint: Use LAG(or_purchase_date) OVER(PARTITION BY or_customer_id ORDER BY or_purchase_date) and take the date difference.

Business Value: Informs the optimal timing schedule for automated repurchase reminder emails.

Question 36
Title: Customer RFM Base Metrics

Context: Marketing analytics needs raw Recency, Frequency, and Monetary (RFM) inputs for user segmentation.

Question: For each customer, compute: Recency (days since last order relative to '2024-12-31'), Frequency (count of distinct completed orders), and Monetary Value (total spend).

Difficulty: Middle

Expected Output: customer_id, recency_days, frequency, monetary_value

Hint: Group by customer ID, use DATEDIFF('2024-12-31', MAX(or_purchase_date)), COUNT(DISTINCT id), and SUM(or_order_total).

Business Value: Provides foundational data for RFM customer segmentation models.

Question 37
Title: Month-over-Month (MoM) Revenue Growth Rate

Context: Executive management reviews monthly revenue growth percentages to evaluate momentum.

Question: Calculate total monthly revenue and use LAG() to calculate the Month-over-Month percentage growth rate in revenue.

Difficulty: Middle

Expected Output: year_month, current_month_revenue, prior_month_revenue, mom_growth_pct

Hint: Extract YYYY-MM, sum revenue, get prior revenue using LAG(), and apply ((current - prior) / prior) * 100.

Business Value: Core financial KPI for tracking revenue acceleration or deceleration.

Question 38
Title: Standardizing Messy Demographics

Context: Marketing databases contain non-standardized values in cst_gender.

Question: Write a query that standardizes cst_gender values into 'Male', 'Female', or 'Other/Unknown' using a CASE statement, and return the distribution count.

Difficulty: Middle

Expected Output: clean_gender, user_count

Hint: Handle variations like 'M', 'Male', 'F', 'Female', and NULL inside CASE WHEN.

Business Value: Cleans demographic data for accurate segmentation and reporting.

Question 39
Title: Payment Method Preference by Revenue Tier

Context: Product growth wants to see if high-value orders use different payment methods than low-value orders.

Question: Aggregate total revenue per or_payment_method split across two order size buckets: 'Small Order' (< $100) and 'Large Order' (>= $100).

Difficulty: Middle

Expected Output: or_payment_method, small_order_revenue, large_order_revenue

Hint: Use conditional aggregation SUM(CASE WHEN or_order_total < 100 THEN or_order_total ELSE 0 END).

Business Value: Guides checkout customization and payment processing fee optimization.

Question 40
Title: Preventing Order Item Join Fan-out

Context: Junior analysts frequently produce inflated revenue numbers when joining orders directly to order_item.

Question: Write a query that correctly returns total revenue per customer from orders without inflating totals when joining order_item to calculate total physical items purchased.

Difficulty: Middle

Expected Output: customer_id, total_spend, total_physical_items

Hint: Pre-aggregate order line items in a CTE by order ID before joining to the orders table.

Business Value: Prevents catastrophic financial reporting errors caused by SQL join duplication.

Question 41
Title: Frequently Co-Purchased Product Pairs

Context: The site personalization engine needs product pair affinity data to power "Frequently Bought Together" recommendations.

Question: Identify the top 5 product pairs most frequently purchased together within the same order item line items.

Difficulty: Middle

Expected Output: product_1_name, product_2_name, co_purchase_count

Hint: Self-join order_item on itm_order_id where T1.itm_product_id < T2.itm_product_id, group by product pairs, and order descending.

Business Value: Powers cross-selling recommendation widgets on product detail pages.

Question 42
Title: Repeat Purchase Rate Calculation

Context: Growth teams want to track platform customer stickiness through repeat order rate.

Question: Calculate the percentage of total customers who have placed 2 or more orders compared to the total customer base.

Difficulty: Middle

Expected Output: total_customers, repeat_customers, repeat_purchase_rate_pct

Hint: Use subqueries or conditional COUNT(CASE WHEN order_count >= 2 THEN 1 END) divided by total customer count.

Business Value: Primary metric for evaluating customer retention and loyalty programs.

Question 43
Title: Average Basket Size by Product Category

Context: Operations wants to see average item units per order for orders containing products from specific categories.

Question: For orders containing items in a given category, calculate the average units per order item row and average order total spend.

Difficulty: Middle

Expected Output: pro_category, avg_units_per_item_line, avg_order_spend

Hint: Join products, order_item, and orders, grouping by pro_category.

Business Value: Informs warehouse picking efficiency and packaging capacity planning.

Question 44
Title: Zero-Sales Catalog Recovery

Context: Catalog management wants a clean list of all products showing total sales revenue, explicitly displaying $0 for unsold items.

Question: Display product ID, name, brand, and total sales revenue, substituting $0.00 for NULL values using COALESCE.

Difficulty: Middle

Expected Output: id, pro_name, pro_brand, formatted_revenue

Hint: Use LEFT JOIN from products to order_item and wrap SUM(itm_price * itm_quantity) inside COALESCE(..., 0).

Business Value: Delivers complete catalog reports without missing unsold inventory rows.

Question 45
Title: Detecting Orphaned Order Line Items

Context: Data engineering needs an audit query to catch data corruption where line items lack matching master order headers.

Question: Write a query to detect any rows in order_item whose itm_order_id does not exist in orders.

Difficulty: Middle

Expected Output: orphan_item_id, itm_order_id, itm_product_id

Hint: Use LEFT JOIN from order_item to orders and filter WHERE orders.id IS NULL.

Business Value: Maintains database referential integrity and catches pipeline ingestion errors.

Question 46
Title: Registration to First Purchase Latency

Context: User onboarding wants to measure how fast newly registered users place their initial order.

Question: Calculate the average time elapsed in days between customer creation and their first purchase date.

Difficulty: Middle

Expected Output: avg_days_to_first_purchase

Hint: Find each customer's MIN(or_purchase_date) in a CTE, join with customers, and average the date difference.

Business Value: Identifies friction points in the user activation funnel.

Question 47
Title: Quartile Customer Spend Segmentation

Context: Marketing wants to segment customers into 4 equal spend buckets (quartiles).

Question: Divide all customers who have made purchases into 4 spend quartiles using NTILE(4) based on their total spend.

Difficulty: Middle

Expected Output: or_customer_id, total_spend, spend_quartile

Hint: Aggregate spend per customer, then apply NTILE(4) OVER(ORDER BY total_spend DESC).

Business Value: Enables tiered marketing automation based on purchasing power.

Question 48
Title: Rapid Re-Order Detection (Fraud/Duplicate Check)

Context: Fraud prevention wants to flag users placing multiple separate orders within a 10-minute window.

Question: Find all instances where the same customer placed two separate orders within 10 minutes of each other.

Difficulty: Middle

Expected Output: or_customer_id, first_order_id, second_order_id, time_difference_minutes

Hint: Join orders to itself on or_customer_id where O1.id < O2.id and check time differences.

Business Value: Detects system glitches, duplicate checkout clicks, or fraudulent payment testing.

Question 49
Title: Quarterly Product Category Performance

Context: Executive reporting requires quarterly revenue snapshots broken down by department.

Question: Write a query displaying year, quarter, category name, total revenue, and total units sold.

Difficulty: Middle

Expected Output: sales_year, sales_quarter, pro_category, quarterly_revenue, units_sold

Hint: Extract YEAR and QUARTER from or_purchase_date and group by year, quarter, and category.

Business Value: Inputs directly into quarterly board presentation financial dashboards.

Question 50
Title: Shipping Delay SLA Breach Rate

Context: Fulfillment operations needs to track the percentage of orders failing the 3-day shipping SLA.

Question: Calculate the percentage of total orders where shipping date was more than 3 days after purchase date.

Difficulty: Middle

Expected Output: total_shipped_orders, delayed_orders, delayed_rate_pct

Hint: Use conditional counting COUNT(CASE WHEN DATEDIFF(or_shipping_date, or_purchase_date) > 3 THEN 1 END) divided by total count.

Business Value: Highlights operational bottlenecks in warehouse dispatch capacity.

Question 51
Title: Review Word Count vs Product Rating Analysis

Context: Product management wants to check if detailed written customer reviews correspond to negative customer experiences.

Question: Calculate the average character length of itm_reviews for each product subcategory.

Difficulty: Middle

Expected Output: pro_sub_category, avg_review_length

Hint: Join products and order_item, using LENGTH(itm_reviews) inside AVG().

Business Value: Informs sentiment analysis initiatives and product feedback prioritization.

Question 52
Title: Customer Inactivity Churn Flag

Context: Re-engagement team needs to pull accounts that were active last year but placed zero orders in the last 90 days.

Question: Identify customers who placed orders in 2024 but have no orders in the 90 days prior to '2024-12-31'.

Difficulty: Middle

Expected Output: customer_id, last_order_date

Hint: Filter MAX(or_purchase_date) per customer using HAVING clauses.

Business Value: Identifies lapsed users for win-back email campaigns.

Question 53
Title: High-Volume Categories with Low Average Prices

Context: Inventory strategy wants to spot departments relying on high unit volume at low price points.

Question: Find categories with over 1,000 total units sold but an average product price under $25.

Difficulty: Middle

Expected Output: pro_category, total_units_sold, avg_category_price

Hint: Group by pro_category, apply SUM(itm_quantity) and AVG(pro_current_price) filtered via HAVING.

Business Value: Uncovers low-margin, high-volume inventory categories.

Question 54
Title: Order Delivery Failure Rate by Country

Context: International logistics wants to audit regional delivery performance.

Question: Calculate the percentage of orders marked as 'Cancelled' or 'Lost' per customer country.

Difficulty: Middle

Expected Output: cst_country, total_orders, failed_orders, failure_rate_pct

Hint: Join customers and orders, using conditional aggregation for failed status count.

Business Value: Pinpoints unreliable regional shipping carriers.

Question 55
Title: Moving Average Sales Volume

Context: Demand planners need a 3-month moving average of total sales units to smooth out seasonal spikes.

Question: Calculate monthly total unit sales and compute a 3-month centered/moving average across time.

Difficulty: Middle

Expected Output: year_month, monthly_units, moving_avg_3_months

Hint: Use window function AVG(monthly_units) OVER(ORDER BY year_month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW).

Business Value: Improves inventory demand forecasting precision.

Question 56
Title: Single vs Multi-Category Shoppers

Context: Category expansion team wants to measure cross-department shopping behaviors.

Question: Count how many distinct product categories each customer has purchased from throughout their history.

Difficulty: Middle

Expected Output: or_customer_id, distinct_categories_bought

Hint: Join orders, order_item, and products, using COUNT(DISTINCT pro_category) grouped by customer.

Business Value: Measures customer cross-category exploration.

Question 57
Title: Order Discounting/Price Variance Detection

Context: Finance wants to catch instances where historical line item sales price (itm_price) differed from master product price (pro_current_price).

Question: List order items where itm_price is less than pro_current_price, showing price difference.

Difficulty: Middle

Expected Output: itm_order_id, itm_product_id, pro_current_price, itm_price, price_discount

Hint: Join order_item and products where itm_price < pro_current_price.

Business Value: Audits promotional pricing application correctness.

Question 58
Title: First-Time vs Repeat Order Revenue Share

Context: Business leads want to know what portion of monthly revenue comes from new vs returning customers.

Question: For each month, split total revenue into revenue from customers placing their 1st order vs 2nd+ order.

Difficulty: Middle

Expected Output: year_month, new_customer_revenue, repeat_customer_revenue

Hint: Identify first order date per customer using window functions, then flag order line items accordingly.

Business Value: Evaluates business dependence on new acquisition versus repeat retention.

Question 59
Title: Order Completion Speed by Payment Gateway

Context: Operations wants to check if payment options impact processing latency.

Question: Calculate average hours between order purchase and order delivery broken down by or_payment_method.

Difficulty: Middle

Expected Output: or_payment_method, avg_fulfillment_hours

Hint: Use TIMESTAMPDIFF(HOUR, or_purchase_date, or_delivery_date) inside AVG().

Business Value: Measures fulfillment friction across payment gateways.

Question 60
Title: Customer Registration Cohort Sizes

Context: Marketing tracks signups grouped into monthly acquisition cohorts.

Question: Group customers by signup year-month (based on earliest order date) and output total customer count per cohort.

Difficulty: Middle

Expected Output: cohort_month, total_acquired_customers

Hint: Find MIN(or_purchase_date) per customer and group by DATE_FORMAT(min_date, '%Y-%m').

Business Value: Establishes baseline cohort volumes for long-term retention analysis.
