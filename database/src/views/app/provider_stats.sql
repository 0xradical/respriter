CREATE MATERIALIZED VIEW app.provider_stats AS (
  WITH top_countries AS (
    SELECT provider_id, (ARRAY_AGG(country))[1:5] AS countries FROM (
      SELECT provider_id, tracking_data->>'country' AS country, count(*) AS count_all
        FROM app.enrollments
        WHERE tracking_data->>'country' IS NOT NULL
        GROUP BY provider_id, country
        ORDER BY count_all DESC
    ) sq
    GROUP BY provider_id
  ),
  areas_of_knowledge AS (
    SELECT DISTINCT ON (provider_id) provider_id, tag, count(*) AS count_all
    FROM (
      SELECT provider_id, UNNEST(curated_tags) AS tag
      FROM app.courses
      WHERE app.courses.published = true
    ) sq
    WHERE tag IN (
      'computer_science',
      'arts_and_design',
      'business',
      'personal_development',
      'data_science',
      'physical_science_and_engineering',
      'marketing',
      'language_and_communication',
      'life_sciences',
      'math_and_logic',
      'social_sciences',
      'health_and_fitness'
    )
    GROUP BY provider_id, tag
    ORDER BY provider_id, count_all DESC
  ),
  indexed_courses AS (
    SELECT provider_id, count(*) AS count_all
    FROM app.courses
    WHERE published = true
    GROUP BY provider_id
  ),
  instructors AS (
    SELECT (SELECT id FROM app.providers WHERE name = teaching_at) AS provider_id, COUNT(*) AS count_all
    FROM (
      SELECT id, UNNEST(teaching_at) AS teaching_at
      FROM app.orphaned_profiles
      WHERE orphaned_profiles.state = 'enabled'
    ) sq
    GROUP BY provider_id
  )
  SELECT app.providers.id AS provider_id,
         top_countries.countries AS top_countries,
         areas_of_knowledge.tag AS areas_of_knowledge,
         indexed_courses.count_all AS indexed_courses,
         instructors.count_all AS instructors
    FROM app.providers
    LEFT JOIN top_countries ON top_countries.provider_id = app.providers.id
    LEFT JOIN areas_of_knowledge ON areas_of_knowledge.provider_id = app.providers.id
    LEFT JOIN indexed_courses ON indexed_courses.provider_id = app.providers.id
    LEFT JOIN instructors ON instructors.provider_id = app.providers.id
    WHERE top_countries IS NOT NULL
       OR areas_of_knowledge IS NOT NULL
       OR indexed_courses IS NOT NULL
       OR instructors IS NOT NULL
);
