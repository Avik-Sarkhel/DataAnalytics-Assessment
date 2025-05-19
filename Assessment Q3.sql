-- Step 1: Soft-cleaned versions of the tables
WITH clean_plans AS (
    SELECT 
        id AS plan_id,
        owner_id,
        CASE 
            WHEN is_regular_savings = 1 THEN 'Savings'
            WHEN is_a_fund = 1 THEN 'Investment'
            ELSE 'Other'
        END AS type
    FROM plans_plan
    WHERE is_deleted = 0 -- Soft filter
      AND (is_regular_savings = 1 OR is_a_fund = 1) -- Focus only on relevant plan types
),
latest_transactions AS (
    SELECT 
        plan_id,
        MAX(transaction_date) AS last_transaction_date
    FROM savings_savingsaccount
    WHERE is_deleted = 0 -- Soft filter
    GROUP BY plan_id
),
-- step 2: Join plans with latest transactions and calculate inactivity period
combined AS (
    SELECT 
        cp.plan_id,
        cp.owner_id,
        cp.type,
        lt.last_transaction_date,
        DATEDIFF(CURDATE(), lt.last_transaction_date) AS inactivity_days -- How long it's been since last txn
    FROM clean_plans cp
    LEFT JOIN latest_transactions lt 
        ON cp.plan_id = lt.plan_id -- LEFT JOIN to include plans with no transactions at all
)
-- Step 3: Final selection - fetch only plans that are inactive for over a year (or never had a txn)
SELECT 
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    inactivity_days
FROM combined
WHERE (last_transaction_date IS NULL -- No transactions ever
OR DATEDIFF(CURDATE(), last_transaction_date) > 365) -- Inactive for more than a year
ORDER BY inactivity_days DESC;
