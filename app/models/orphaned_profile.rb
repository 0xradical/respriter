class OrphanedProfile < ApplicationRecord
  include Slugifyable
  slugify run_on: :before_save,
          callback_options: { unless: -> { slug.present? } }

  belongs_to :user_account, optional: true

  scope :enabled, -> { where(state: 'enabled') }
  scope :with_slug, -> { where.not(slug: nil) }

  def claimed?
    !!user_account_id
  end

  def enabled?
    state == 'enabled'
  end

  def courses
    Course.where(id: course_ids)
  end

  def self.courses_by_instructor_name(name)
    query = <<-SQL
    WITH
    A AS (
    SELECT
      id
      ,jsonb_array_elements(instructors) AS instructor
    FROM courses
    )
    SELECT *
    FROM A
    WHERE (instructor->>'name') = '#{name}';
    SQL
    ActiveRecord::Base.connection.execute(query)
  end
end
