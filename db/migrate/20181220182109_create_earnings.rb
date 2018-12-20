class CreateEarnings < ActiveRecord::Migration[5.2]

  def up
    execute <<-SQL
      CREATE OR REPLACE VIEW earnings AS
        SELECT tracked_actions.id , sale_amount, earnings_amount, ext_click_date, ext_id,
        tracked_actions.source as affiliate_network, providers.name as provider_name,
        courses.name as course_name, courses.url as course_url, 
        enrollments.tracking_data ->> 'query_string' AS qs,
        enrollments.tracking_data ->> 'referer' AS referer, 
        enrollments.tracking_data ->> 'utm_source' AS utm_source,
        enrollments.tracking_data ->> 'utm_campaign' AS utm_campaign,
        enrollments.tracking_data ->> 'utm_medium' AS utm_medium,
        enrollments.tracking_data ->> 'utm_term' AS utm_term
        FROM tracked_actions 
        LEFT JOIN enrollments ON tracked_actions.enrollment_id = enrollments.id
        LEFT JOIN courses ON enrollments.course_id = courses.id
        LEFT JOIN providers ON courses.provider_id = providers.id
    SQL
  end

  def down
    execute "DROP VIEW earnings"
  end

end
