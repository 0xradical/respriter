CREATE MATERIALIZED VIEW app.provider_pricings AS (
  SELECT provider_id,
         ARRAY_AGG(DISTINCT type) AS membership_types,
         MIN(app.price_in_decimal(price)) AS min_price,
         MAX(app.price_in_decimal(price)) AS max_price,
         MIN(app.price_in_decimal(trial_price)) AS min_trial_price,
         MAX(app.price_in_decimal(trial_price)) AS max_trial_price
    FROM (
      SELECT DISTINCT ON (id)
             provider_id,
             UNNEST(ARRAY_AGG(DISTINCT type)) AS type,
             MIN(CASE WHEN TYPE = 'single_course' THEN price ELSE total_price END) AS price,
             MIN(trial_price) AS trial_price
        FROM (
          SELECT id,
                provider_id,
                jsonb_array_elements(pricing_models)->>'type' AS type,
                jsonb_array_elements(pricing_models)->>'price' AS price,
                jsonb_array_elements(pricing_models)->>'total_price' AS total_price,
                jsonb_array_elements(pricing_models)->'trial_period'->>'value' AS trial_price,
                app.currency_index(jsonb_array_elements(pricing_models)->>'currency'::VARCHAR) AS currency
            FROM app.courses
            WHERE published = 't'
        ) sq
        GROUP BY id, provider_id, currency
    ) sq2 GROUP BY provider_id
);
