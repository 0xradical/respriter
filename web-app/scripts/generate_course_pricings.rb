# frozen_string_literal: true

PreviewCourse.find_each do |preview_course|
  preview_course.pricing_models.each do |pm|
    pm['plan_type'] ||= 'regular'
    begin
      PreviewCourse.connection.execute("SELECT app.insert_into_preview_course_pricings('#{preview_course.id}', '#{pm.to_json}'::jsonb)")
    rescue StandardError => e
      puts "#{preview_course.id}) #{e.message}"
    end
  end
end

Course.find_each do |course|
  course.pricing_models.each do |pm|
    pm['plan_type'] ||= 'regular'
    begin
      Course.connection.execute("SELECT app.insert_into_course_pricings('#{course.id}', '#{pm.to_json}'::jsonb)")
    rescue StandardError => e
      puts "#{course.id}) #{e.message}"
    end
  end
end

def table_print_pricing_models(course)
  headers =
    %i[pricing_type
       plan_type
       customer_type
       price
       total_price
       original_price
       discount
       currency
       payment_period_unit
       payment_period_value
       trial_period_unit
       trial_period_value
       subscription_period_unit
       subscription_period_value]
  arr = course.pricing_models.map do |pm|
    Hash[[headers, [pm['type'],
                    pm['plan_type'].presence || 'regular',
                    pm['customer_type'],
                    pm['price'],
                    pm['total_price'],
                    pm['original_price'],
                    pm['discount'],
                    pm['currency'],
                    pm.dig('payment_period', 'unit'),
                    pm.dig('payment_period', 'value'),
                    pm.dig('trial_period', 'unit'),
                    pm.dig('trial_period', 'value'),
                    pm.dig('subscription_period', 'unit'),
                    pm.dig('subscription_period', 'value')]].transpose]
  end

  headers.each do |header|
    arr = arr.sort_by { |hsh| hsh[header] }
  end

  columns = headers.each_with_object({}) do |header, h|
    h[header] = { label: header,
                  width: [arr.map { |g| g[header]&.size || 0 }.max, header.size].max }
  end
  puts "+-#{columns.map { |_, g| '-' * g[:width] }.join('-+-')}-+"
  puts "| #{columns.map { |_, g| g[:label].to_s.ljust(g[:width]) }.join(' | ')} |"
  puts "+-#{columns.map { |_, g| '-' * g[:width] }.join('-+-')}-+"
  arr.each do |entry|
    str = entry.keys.map { |k| (entry[k].to_s || '').ljust(columns[k][:width]) }.join(' | ')
    puts "| #{str} |"
  end
  puts "+-#{columns.map { |_, g| '-' * g[:width] }.join('-+-')}-+"
end
