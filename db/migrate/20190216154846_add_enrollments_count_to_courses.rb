class AddEnrollmentsCountToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :enrollments_count, :integer, default: 0
    Enrollment.find_each do |enrollment|
      Course.reset_counters(enrollment.course.id, :enrollments)
    end
  end
end
