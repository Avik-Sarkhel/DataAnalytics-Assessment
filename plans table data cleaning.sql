-- COUNT affected rows BEFORE cleaning (filtered only for non-funds with zero/negative amounts)
SELECT COUNT(*) AS rows_to_clean
FROM plans_plan
WHERE 
    (start_date IS NULL OR start_date > CURDATE())
    OR (is_a_fund = 0 AND amount <= 0)
    OR LOWER(name) LIKE '%test%' 
    OR LOWER(description) LIKE '%test%' 
    OR (withdrawal_date IS NOT NULL AND withdrawal_date < start_date);
-- CLEAN: mark as deleted only if criteria is met
ALTER TABLE plans_plan
ADD COLUMN is_deleted BOOLEAN DEFAULT 0;
UPDATE plans_plan
SET is_deleted = 1
WHERE 
    (start_date IS NULL OR start_date > CURDATE())
    OR (is_a_fund = 0 AND amount <= 0)
    OR LOWER(name) LIKE '%test%' 
    OR LOWER(description) LIKE '%test%' 
    OR (withdrawal_date IS NOT NULL AND withdrawal_date < start_date);
-- COUNT total deleted (includes newly cleaned + existing)
SELECT COUNT(*) AS cleaned_rows
FROM plans_plan
WHERE is_deleted = 1;