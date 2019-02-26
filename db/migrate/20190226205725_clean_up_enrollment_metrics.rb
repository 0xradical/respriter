class CleanUpEnrollmentMetrics < ActiveRecord::Migration[5.2]
  def change
    execute <<-SQL
      DELETE FROM enrollments WHERE tracking_data -> 'user_agent' ->> 'browser' ILIKE '%Googlebot%';
      DELETE FROM enrollments WHERE tracking_data -> 'user_agent' ->> 'browser' ILIKE '%bingbot%';
      DELETE FROM enrollments WHERE tracking_data -> 'user_agent' ->> 'browser' LIKE 'MJ12bot%';
      DELETE FROM enrollments WHERE tracking_data -> 'user_agent' ->> 'browser' LIKE 'AhrefsBot%';
      DELETE FROM enrollments WHERE tracking_data -> 'user_agent' ->> 'browser' LIKE 'YisouSpider%';
      DELETE FROM enrollments WHERE tracking_data -> 'user_agent' ->> 'browser' LIKE 'ZoominfoBot%';
    SQL

    Enrollment.find_each do |enrollment|
      Course.reset_counters(enrollment.course.id, :enrollments)
    end

  end
end
