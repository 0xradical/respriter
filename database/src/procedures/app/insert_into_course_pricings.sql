CREATE FUNCTION app.insert_into_course_pricings(course_id uuid, pricing jsonb)
RETURNS void AS $$
BEGIN
  INSERT INTO app.course_pricings (
          course_id,
          pricing_type,
          plan_type,
          customer_type,
          price,
          total_price,
          discount,
          currency,
          payment_period_unit,
          payment_period_value,
          trial_period_unit,
          trial_period_value,
          subscription_period_unit,
          subscription_period_value
        ) VALUES (
          course_id,
          (pricing->>'type')::app.pricing,
          (pricing->>'plan_type')::app.pricing_plan,
          (pricing->>'customer_type')::app.pricing_customer,
          (pricing->>'price')::numeric(8,2),
          (pricing->>'total_price')::numeric(8,2),
          (pricing->>'discount')::numeric(8,2),
          (pricing->>'currency')::app.iso4217_code,
          (pricing->'payment_period'->>'unit')::app.period_unit,
          (pricing->'payment_period'->>'value')::integer,
          (pricing->'trial_period'->>'unit')::app.period_unit,
          (pricing->'trial_period'->>'value')::integer,
          (pricing->'subscription_period'->>'unit')::app.period_unit,
          (pricing->'subscription_period'->>'value')::integer
        ) ON CONFLICT ON CONSTRAINT course_pricing_uniqueness
          DO UPDATE SET pricing_type = (pricing->>'type')::app.pricing,
                        plan_type = (pricing->>'plan_type')::app.pricing_plan,
                        customer_type = (pricing->>'customer_type')::app.pricing_customer,
                        price = (pricing->>'price')::numeric(8,2),
                        total_price = (pricing->>'total_price')::numeric(8,2),
                        discount = (pricing->>'discount')::numeric(8,2),
                        currency = (pricing->>'currency')::app.iso4217_code,
                        payment_period_unit = (pricing->'payment_period'->>'unit')::app.period_unit,
                        payment_period_value = (pricing->'payment_period'->>'value')::integer,
                        trial_period_unit = (pricing->'trial_period'->>'unit')::app.period_unit,
                        trial_period_value = (pricing->'trial_period'->>'value')::integer,
                        subscription_period_unit = (pricing->'subscription_period'->>'unit')::app.period_unit,
                        subscription_period_value = (pricing->'subscription_period'->>'value')::integer;
END;
$$ LANGUAGE plpgsql;