CREATE TABLE app.tracked_actions (
  id               uuid                DEFAULT public.uuid_generate_v4() PRIMARY KEY,
  enrollment_id    uuid                REFERENCES app.enrollments(id),
  status           app.payment_status,
  source           app.payment_source,
  created_at       timestamptz         DEFAULT NOW() NOT NULL,
  updated_at       timestamptz         DEFAULT NOW() NOT NULL,
  sale_amount      numeric,
  earnings_amount  numeric,
  payload          jsonb,
  compound_ext_id  varchar,
  ext_click_date   timestamptz,
  ext_id           varchar,
  ext_sku_id       varchar,
  ext_product_name varchar
);
