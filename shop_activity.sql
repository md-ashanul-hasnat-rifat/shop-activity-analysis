USE shop_activity;
select * from task_dataset;
-- Total Sales Amount by Date
SELECT 
    DATE(date) AS date,
    SUM(total_sales_amount) AS total_sales
FROM task_dataset
GROUP BY date
ORDER BY date desc;
-- Total Sales Amount by Shop Type
SELECT 
    shop_type,
    SUM(total_sales_amount) AS total_sales
FROM task_dataset
GROUP BY shop_type
ORDER BY total_sales DESC;
-- Average Transactions per Shop
SELECT 
    AVG(transactions_count) AS avg_daily_transactions
FROM task_dataset;

-- Q1. Daily Performance Classification
-- Write a SQL query to:
-- Show date
-- Total sales amount
-- Total transactions
-- Classify activity type as good or bad or worst
-- (I define my own logic for classification based on sales or transactions.)
SELECT
	DATE(date) AS date,
    SUM(total_sales_amount) AS total_sales_amount,
    SUM(transactions_count) AS total_transactions,
    CASE
        WHEN SUM(total_sales_amount) >= 100000 AND SUM(transactions_count) >= 100 THEN 'Good'
        WHEN SUM(total_sales_amount) BETWEEN 50000 AND 99999 OR SUM(transactions_count) BETWEEN 50 AND 99 THEN 'Bad'
        ELSE 'Worst'
    END AS activity_type
FROM
    task_dataset
GROUP BY
    DATE(date)
ORDER BY
    2 desc;
    
-- Q2. New vs Existing User Analysis
-- Write a SQL query to compare new users vs existing users in terms of:
-- Total sales amount
-- Number of shops
-- Subscription purchases
SELECT
    CASE 
        WHEN new_user = 1 THEN 'New User'
        ELSE 'Existing User'
    END AS user_type,
    FORMAT(SUM(total_sales_amount), 0) AS total_sales_amount,
    COUNT(DISTINCT shop_id) AS number_of_shops,
    SUM(subscription_purchased) AS subscription_purchases
FROM task_dataset
GROUP BY new_user;
select * from task_dataset;
-- Q3. Subscription Conversion by Shop Type
-- Write a SQL query to calculate:
-- Subscription conversion rate by shop type
 SELECT
    shop_type,
    COUNT(DISTINCT shop_id) AS total_shops,
    SUM(subscription_purchased) AS subscription_purchased,
    ROUND(
        (SUM(total_sales_amount)/ (SELECT SUM(total_sales_amount) FROM task_dataset)) * 100,
        2
    )  as sales_percentage,
    ROUND(
        (SUM(subscription_purchased) / COUNT(DISTINCT shop_id)) * 100,
        2
    ) AS subscription_conversion_rate_pct
FROM task_dataset
GROUP BY shop_type;


-- Q4. City Performance
-- Write a SQL query to:
-- Find the top 5 cities by total sales
-- Only include cities where at least one subscription was purchased
SELECT 
    city,
    FORMAT(SUM(total_sales_amount), 0) AS total_sales_amount,
    SUM(subscription_purchased) AS subscription_purchased
FROM
    task_dataset
GROUP BY 1
HAVING SUM(COALESCE(subscription_purchased,0)) >= 1
ORDER BY 3 DESC
LIMIT 5;



    
        