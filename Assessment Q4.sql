-- Step 1: Soft-cleaned versions of the tables
WITH clean_users AS (
    SELECT 
        id AS customer_id,
        CONCAT(first_name, ' ', last_name) AS name,
        date_joined
    FROM users_customuser
    WHERE is_deleted = 0 -- Soft filter
),

clean_savings AS (
    SELECT 
        owner_id,
        confirmed_amount
    FROM savings_savingsaccount
    WHERE is_deleted = 0 -- Soft filter
),
-- Step 2: Aggregate total transactions and amount per user
user_tx_summary AS (
    SELECT 
        cs.owner_id AS customer_id,
        COUNT(*) AS total_transactions,
        SUM(confirmed_amount) AS total_amount_kobo -- Total amount in kobo
    FROM clean_savings cs
    GROUP BY cs.owner_id
),
-- Step 3: Combine user info and transaction summary to calculate tenure and average profit
final_metrics AS (
    SELECT 
        cu.customer_id,
        cu.name,
        TIMESTAMPDIFF(MONTH, cu.date_joined, CURDATE()) AS tenure_months, -- User lifetime in months
        uts.total_transactions,
        uts.total_amount_kobo / 100000.0 AS total_amount_naira, -- Convert to naira
        (uts.total_amount_kobo / uts.total_transactions) * 0.001 AS avg_profit_per_tx_kobo -- Simplified proxy for unit profit
    FROM clean_users cu
    JOIN user_tx_summary uts ON cu.customer_id = uts.customer_id
    WHERE TIMESTAMPDIFF(MONTH, cu.date_joined, CURDATE()) > 0 -- Only include users with tenure > 0 months
),
-- Step 4: Calculate estimated CLV using frequency and avg profit
final_output AS (
    SELECT 
        customer_id,
        name,
        tenure_months,
        total_transactions,
        ROUND(((total_transactions / tenure_months) * 12 * (avg_profit_per_tx_kobo / 100)), 2) AS estimated_clv
		-- Explanation:
        -- (txns/month) * 12 = yearly txn frequency
        -- multiplied by average profit (converted from kobo to naira)
        -- gives annual CLV estimate
    FROM final_metrics
)
-- Step 5: Output ranked customers by estimated CLV
SELECT *
FROM final_output
ORDER BY estimated_clv DESC;
