COPY (
  SELECT
    id,
    email,
    '$2a$11$GVNkSe3Epr6QLBfCQFLQ9e4b7tuAuV2O5o2fZUIaAkm7pgc1Hciga' AS encrypted_password, -- password: abc123
    reset_password_token,
    reset_password_sent_at,
    remember_created_at,
    sign_in_count,
    current_sign_in_at,
    last_sign_in_at,
    current_sign_in_ip,
    last_sign_in_ip,
    tracking_data,
    confirmation_token,
    confirmed_at,
    confirmation_sent_at,
    unconfirmed_email,
    failed_attempts,
    unlock_token,
    locked_at,
    destroyed_at,
    created_at,
    updated_at
  FROM app.user_accounts
) TO STDOUT WITH CSV HEADER DELIMITER ',';
