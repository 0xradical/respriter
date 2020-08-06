CREATE INDEX index_preview_course_pricings_on_preview_course_id
ON app.preview_course_pricings
USING btree (preview_course_id);

CREATE UNIQUE INDEX index_preview_course_pricing_uniqueness
ON app.preview_course_pricings
USING btree (
              preview_course_id,
              pricing_type,
              plan_type,
              COALESCE(customer_type, 'unknown'),
              currency,
              COALESCE(payment_period_unit, 'unknown'),
              COALESCE(subscription_period_unit, 'unknown'),
              COALESCE(trial_period_unit, 'unknown')
            );