CREATE INDEX index_course_pricings_on_course_id
ON app.course_pricings
USING btree (course_id);

CREATE UNIQUE INDEX index_course_pricing_uniqueness
ON app.course_pricings
USING btree (
              course_id,
              pricing_type,
              plan_type,
              COALESCE(customer_type, 'unknown'),
              currency,
              COALESCE(payment_period_unit, 'unknown'),
              COALESCE(subscription_period_unit, 'unknown'),
              COALESCE(trial_period_unit, 'unknown')
            );