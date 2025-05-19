ALTER TABLE users_customuser
ADD COLUMN is_deleted TINYINT(1) DEFAULT 0;
-- CLEAN: Mark problematic user records as deleted
UPDATE users_customuser
SET is_deleted = 1
WHERE 
     date_joined IS NULL 
    OR date_joined > CURDATE()
    OR date_of_birth > CURDATE()
    OR LOWER(email) LIKE '%test%' 
    OR LOWER(email) LIKE '%example%' 
    OR LOWER(email) LIKE '%abc%'
    OR LOWER(username) LIKE '%test%' 
    OR LOWER(name) LIKE '%test%'
    OR fraud_score > 90
	OR is_active=  0
    OR is_account_deleted = 1
    OR current_latitude NOT BETWEEN -90 AND 90
    OR current_longitude NOT BETWEEN -180 AND 180;
-- COUNT how many users are now soft-deleted
SELECT COUNT(*) AS total_soft_deleted_users
FROM users_customuser
WHERE is_deleted = 1;