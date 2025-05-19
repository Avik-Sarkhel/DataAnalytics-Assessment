ALTER TABLE savings_savingsaccount
ADD COLUMN is_deleted TINYINT(1) DEFAULT 0;
-- Soft-delete clearly broken savings records
UPDATE savings_savingsaccount
SET is_deleted = 1
WHERE 
    -- 1. Critical fields cannot be NULL
    savings_id IS NULL OR
    amount IS NULL OR
    confirmed_amount IS NULL OR
    transaction_date IS NULL OR
    transaction_status IS NULL OR
    owner_id IS NULL OR
    plan_id IS NULL
    -- 2. Maturity end date before start date (business logic failure)
    OR (
        maturity_start_date IS NOT NULL AND 
        maturity_end_date IS NOT NULL AND 
        maturity_end_date < maturity_start_date
    )
    -- 3. Future transaction or verification dates (future-dated record issues)
    OR transaction_date > CURDATE()
    OR verification_transaction_date > CURDATE()
    -- 4. Negative or suspicious financial figures (amounts shouldn't be negative)
    OR amount < 0
    OR confirmed_amount < 0
    OR deduction_amount < 0
    OR new_balance < 0
    OR book_returns < 0
    OR available_returns < 0
    OR returns_on_hold < 0
    -- 5. Known dummy/test records based on common spam patterns
    OR LOWER(description) LIKE '%test%'
    OR LOWER(transaction_reference) LIKE '%test%'
    OR LOWER(gateway_response_message) LIKE '%test%'
    OR LOWER(payment_gateway) LIKE '%test%'
    -- 6. Invalid fee records (negative fee values)
    OR (fee_in_kobo IS NOT NULL AND fee_in_kobo < 0)
    OR (fee_in_cents IS NOT NULL AND fee_in_cents < 0)
    -- 7. Invalid or unknown currency codes (should only be NGN)
    OR (currency IS NOT NULL AND currency != 'NGN')
    -- 8. Illogical amounts (confirmed > amount or deduction > confirmed)
    OR (confirmed_amount > amount)
    OR (deduction_amount > confirmed_amount)
    -- 9. Return dates logic broken (next date before last date)
    OR (
        last_returns_date IS NOT NULL AND
        next_returns_date IS NOT NULL AND
        next_returns_date < last_returns_date
    );