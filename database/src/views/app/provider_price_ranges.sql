CREATE MATERIALIZED VIEW app.provider_price_ranges AS (
  SELECT provider_id,
         MIN(app.price_in_decimal(price)),
         MAX(app.price_in_decimal(price))
    FROM (
      SELECT DISTINCT ON (id)
             provider_id,
             MIN(CASE WHEN TYPE = 'single_course' THEN price ELSE total_price END) AS price
        FROM (
          SELECT id,
                provider_id,
                jsonb_array_elements(pricing_models)->>'type' AS type,
                jsonb_array_elements(pricing_models)->>'price' AS price,
                jsonb_array_elements(pricing_models)->>'total_price' AS total_price,
                app.currency_index(jsonb_array_elements(pricing_models)->>'currency'::VARCHAR) AS currency
            FROM app.courses
            WHERE published = 't'
        ) sq
        GROUP BY id, provider_id, currency
    ) sq2 GROUP BY provider_id
);
