-- Step 1: Soft-cleaned versions of the tables
WITH clean_users AS (
    SELECT id, first_name, last_name
    FROM users_customuser
    WHERE is_deleted = 0 -- Soft filter
),
clean_plans AS (
    SELECT id, owner_id, is_regular_savings, is_a_fund
    FROM plans_plan
    WHERE is_deleted = 0 -- Soft filter
),
clean_savings AS (
    SELECT confirmed_amount, plan_id
    FROM savings_savingsaccount
    WHERE is_deleted = 0 -- Soft filter
),

-- Step 2: Identify regular savings plans
-- Join savings with plans, filter only regular savings
savings_plans AS (
    SELECT cp.owner_id, cs.confirmed_amount
    FROM clean_savings cs
    JOIN clean_plans cp ON cs.plan_id = cp.id
    WHERE cp.is_regular_savings = 1
),

-- Step 3: Identify investment plans
-- Join savings with plans, filter only investment funds
investment_plans AS (
    SELECT cp.owner_id, cs.confirmed_amount
    FROM clean_savings cs
    JOIN clean_plans cp ON cs.plan_id = cp.id
    WHERE cp.is_a_fund = 1
),

-- Step 4: Aggregation of savings and investments
-- Aggregate total confirmed deposits and count of savings per user
savings_summary AS (
    SELECT owner_id, COUNT(*) AS savings_count, SUM(confirmed_amount) AS savings_deposits
    FROM savings_plans
    GROUP BY owner_id
),
-- Aggregate total confirmed deposits and count of investments per user
investment_summary AS (
    SELECT owner_id, COUNT(*) AS investment_count, SUM(confirmed_amount) AS investment_deposits
    FROM investment_plans
    GROUP BY owner_id
)

-- Step 5: Final output: Merge summaries and enrich with user info
SELECT 
    cu.id AS owner_id,
    CONCAT(cu.first_name, ' ', cu.last_name) AS name,
    sp.savings_count,
    ip.investment_count,
    -- Divide total confirmed deposits by 100 to convert from kobo to NGN
    ROUND((sp.savings_deposits + ip.investment_deposits)/100, 2) AS total_deposits
FROM savings_summary sp
JOIN investment_summary ip ON sp.owner_id = ip.owner_id
JOIN clean_users cu ON cu.id = sp.owner_id
ORDER BY total_deposits DESC;

