# 📊 Shop Performance Analysis

**Excel | SQL | Business Insights**

## 📌 Project Overview

This project analyzes shop-level transactional data to evaluate overall
business performance, user behavior, subscription trends, and city-level
sales contribution.

The analysis was conducted in three stages:

-   Section A: Excel / Google Sheets Analysis
-   Section B: SQL Analysis
-   Section C: Business Insights & Recommendations

The objective was not just to write queries, but to interpret the data
and extract actionable insights.

------------------------------------------------------------------------

## 📂 Dataset Information

The dataset contains transaction-level records with the following key
fields:

-   date\
-   shop_id\
-   shop_type (Grocery, Restaurant, Pharmacy)
-   city\
-   new_user (1 = New User, 0 = Existing User)
-   total_sales_amount
-   transactions_count\
-   subscription_purchased
-   due_amount
-   expenses_amount
-   app_sessions

------------------------------------------------------------------------

# 🟢 Section A: Google Sheets / Excel Analysis

### Data Preparation

-   Imported dataset into Excel
-   Cleaned and structured data for analysis

### Summary Calculations

-   Total sales amount by date
-   Total sales amount by shop type
-   Average transactions per shop

### Pivot Tables

-   Sales amount by city\
-   Subscription purchased count by shop type

### Visualization

-   Created dynamic performance chart
-   Used interactive filters for better analysis

------------------------------------------------------------------------

# 🔵 Section B: SQL Analysis

## Q1. Daily Performance Classification

Logic: - Good → Sales ≥ 100,000 AND Transactions ≥ 100
- Bad → Sales between 50,000--99,999 OR Transactions between 50--99
- Worst → Otherwise

``` sql
SELECT 
    DATE(date) AS date,
    SUM(total_sales_amount) AS total_sales_amount,
    SUM(transactions_count) AS total_transactions,
    CASE
        WHEN SUM(total_sales_amount) >= 100000 
             AND SUM(transactions_count) >= 100 THEN 'Good'
        WHEN SUM(total_sales_amount) BETWEEN 50000 AND 99999 
             OR SUM(transactions_count) BETWEEN 50 AND 99 THEN 'Bad'
        ELSE 'Worst'
    END AS activity_type
FROM task_dataset
GROUP BY DATE(date)
ORDER BY 2 DESC;
```

## Q2. New vs Existing User Analysis

``` sql
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
```

## Q3. Subscription Conversion by Shop Type

``` sql
SELECT 
    shop_type,
    COUNT(DISTINCT shop_id) AS total_shops,
    SUM(subscription_purchased) AS subscription_purchased,
    ROUND(
        (SUM(total_sales_amount)/ 
         (SELECT SUM(total_sales_amount) FROM task_dataset)) * 100,
        2
    ) AS sales_percentage,
    ROUND(
        (SUM(subscription_purchased) / COUNT(DISTINCT shop_id)) * 100,
        2
    ) AS subscription_conversion_rate_pct
FROM task_dataset
GROUP BY shop_type;
```

## Q4. City Performance

``` sql
SELECT  
    city,
    FORMAT(SUM(total_sales_amount), 0) AS total_sales_amount,
    SUM(subscription_purchased) AS subscription_purchased
FROM task_dataset
GROUP BY city
HAVING SUM(COALESCE(subscription_purchased,0)) >= 1
ORDER BY 3 DESC
LIMIT 5;
```

------------------------------------------------------------------------

# 🟣 Business Insights

### Most Valuable Segment

Grocery shops generate the highest sales share and show strong
subscription adoption.

### User Contribution

Existing users contribute significantly more revenue and purchase more
subscriptions.

### Recommendation

Introduce first-month subscription discounts and onboarding campaigns to
convert new users into long-term customers faster.

------------------------------------------------------------------------

## 🎯 Project Outcome

This project demonstrates SQL aggregation skills, Excel-based analysis,
subscription conversion evaluation, and the ability to translate data
into business decisions.
