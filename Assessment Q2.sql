-- Step 1: Soft-cleaned versions of the tables
WITH clean_users AS (
    SELECT id
    FROM users_customuser
    WHERE is_deleted = 0 -- Soft filter
),
clean_savings AS (
    SELECT owner_id, transaction_date
    FROM savings_savingsaccount
    WHERE is_deleted = 0 -- Soft filter
),
-- Step 2: Count number of transactions per user per month
transactions_per_user_month AS (
    SELECT 
        cs.owner_id,
         -- Extract year and month from transaction_date for grouping
        DATE_FORMAT(cs.transaction_date, '%Y-%m') AS yearmonth,
        COUNT(*) AS monthly_txn_count
    FROM clean_savings cs
    JOIN clean_users cu ON cs.owner_id = cu.id
    GROUP BY cs.owner_id, yearmonth
),
-- Step 3: Compute average number of transactions per user per month
average_txn_per_user AS (
    SELECT 
        owner_id,
        AVG(monthly_txn_count) AS avg_txn_per_month
    FROM transactions_per_user_month
    GROUP BY owner_id
),
-- Step 4: Categorize users based on their average transaction frequency
categorized_users AS (
    SELECT 
        owner_id,
        avg_txn_per_month,
        CASE
            WHEN avg_txn_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txn_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category -- Custom logic to bucket users by activity
    FROM average_txn_per_user
)
-- Step 6: Final summary report: how many users fall into each category, and their avg txns
SELECT 
    frequency_category,
    COUNT(*) AS customer_count, -- Number of users in each category
    ROUND(AVG(avg_txn_per_month), 1) AS avg_transactions_per_month -- Avg txns per user in each group
FROM categorized_users
GROUP BY frequency_category
-- Custom ordering for output: High -> Medium -> Low
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
