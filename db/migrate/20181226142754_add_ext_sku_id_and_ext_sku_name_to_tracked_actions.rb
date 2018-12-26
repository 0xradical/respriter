class AddExtSkuIdAndExtSkuNameToTrackedActions < ActiveRecord::Migration[5.2]
  def change

    add_column :tracked_actions, :ext_sku_id, :string
    add_column :tracked_actions, :ext_sku_name, :string
    TrackedAction.reset_column_information

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
        enrollments.tracking_data ->> 'utm_term' AS utm_term,
        ext_sku_id, ext_sku_name
        FROM tracked_actions
        LEFT JOIN enrollments ON tracked_actions.enrollment_id = enrollments.id
        LEFT JOIN courses ON enrollments.course_id = courses.id
        LEFT JOIN providers ON courses.provider_id = providers.id
    SQL

    TrackedAction.where(source: 'rakuten').update_all("ext_sku_id = payload ->> 'sku_number'")
    TrackedAction.where(source: 'rakuten').update_all("ext_sku_name = payload ->> 'product_name'")

  end
end
