ALTER TABLE withdrawals_withdrawal
ADD COLUMN is_deleted BOOLEAN DEFAULT 0;


UPDATE withdrawals_withdrawal
SET is_deleted = 1
WHERE 
    -- Critical NULL fields
    id IS NULL OR
    amount IS NULL OR
    amount_withdrawn IS NULL OR
    transaction_reference IS NULL OR
    transaction_date IS NULL OR
    owner_id IS NULL OR
    plan_id IS NULL

    -- Negative values in amount / amount_withdrawn
    OR amount < 0 OR
    amount_withdrawn < 0

    -- Future transaction dates
    OR transaction_date > CURDATE()

    -- Broken business logic: withdrawn > amount, or balance negative
    OR amount_withdrawn > amount OR
    new_balance < 0

    -- Dummy/test/spammy data in description, reference, or gateway response
    OR  LOWER(transaction_reference) LIKE '%test%' OR
    LOWER(gateway_response) LIKE '%test%' OR
	gateway_response = '{}' 
    OR description LIKE '%test%'
    OR LOWER(gateway) LIKE '%test%'

    -- Invalid currency (anything except NGN)
    OR (currency IS NOT NULL AND currency != 'NGN')

    -- Invalid or negative fees
    OR (fee_in_kobo IS NOT NULL AND fee_in_kobo < 0) OR
       (fee_in_cents IS NOT NULL AND fee_in_cents < 0)

    -- Missing transaction status
    OR transaction_status_id IS NULL;
