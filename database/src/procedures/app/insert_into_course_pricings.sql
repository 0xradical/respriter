CREATE FUNCTION app.insert_into_course_pricings(cid uuid, pricing jsonb)
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
    cid,
    (pricing->>'type')::app.pricing,
    COALESCE(pricing->>'plan_type', 'regular')::app.pricing_plan,
    COALESCE(pricing->>'customer_type', 'individual')::app.pricing_customer,
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
  ) ON CONFLICT (
    course_id,
    pricing_type,
    plan_type,
    COALESCE(customer_type, 'unknown'),
    currency,
    COALESCE(payment_period_unit, 'unknown'),
    COALESCE(subscription_period_unit, 'unknown'),
    COALESCE(trial_period_unit, 'unknown')
  ) DO UPDATE SET
    pricing_type              = EXCLUDED.pricing_type,
    plan_type                 = EXCLUDED.plan_type,
    customer_type             = EXCLUDED.customer_type,
    price                     = EXCLUDED.price,
    total_price               = EXCLUDED.total_price,
    discount                  = EXCLUDED.discount,
    currency                  = EXCLUDED.currency,
    payment_period_unit       = EXCLUDED.payment_period_unit,
    payment_period_value      = EXCLUDED.payment_period_value,
    trial_period_unit         = EXCLUDED.trial_period_unit,
    trial_period_value        = EXCLUDED.trial_period_value,
    subscription_period_unit  = EXCLUDED.subscription_period_unit,
    subscription_period_value = EXCLUDED.subscription_period_value;
END;
$$ LANGUAGE plpgsql;
