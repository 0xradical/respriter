CREATE OR REPLACE VIEW api.promo_account_certificates AS
  SELECT
    app.promo_account_certificates.id,
    COALESCE( if_admin(promo_account_id), if_user_by_id(app.promo_accounts.user_account_id, promo_account_id) ) AS promo_account_id,
    COALESCE( if_admin(certificate_id),   if_user_by_id(app.promo_accounts.user_account_id, certificate_id)   ) AS certificate_id,
    COALESCE( if_admin(state),            if_user_by_id(app.promo_accounts.user_account_id, state)            ) AS state,
    COALESCE( if_admin(file),             if_user_by_id(app.promo_accounts.user_account_id, file)             ) AS file,
    app.promo_account_certificates.created_at,
    app.promo_account_certificates.updated_at
  FROM app.promo_account_certificates
  INNER JOIN app.promo_accounts ON app.promo_accounts.id = promo_account_certificates.promo_account_id
  INNER JOIN app.certificates ON app.promo_account_certificates.certificate_id = app.certificates.id
  LIMIT 1;