class TrackedAction < ApplicationRecord

  belongs_to :enrollment, optional: true
  has_one :user_account, through: :enrollment
  has_one :course, through: :enrollment
  has_one :provider, through: :course

  after_create :trigger_webhook
  after_create :send_course_review_emails

  scope :with_user, -> { joins(enrollment: :user_account) }

  def trigger_webhook
    if ENV['RAVEN_GOD_URI'].present?
      data = self.as_json(include: {
        enrollment: {
          include: {
            course: {
              include: {
                provider: {
                  only: :name
                }
              },
              only: :name
            }
          },
          only: :tracking_data
        }
      }).to_json

      HTTParty.post(ENV['RAVEN_GOD_URI'], body: data, headers: { 'Content-Type' => 'application/json' })
      sleep(5)
    end
  end

  def send_course_review_emails
    return unless self.source == 'rakuten'
    return unless self.user_account.present?
    return unless self.ext_product_name.present?
    return unless self.sale_amount >= 0

    reference_date = self.ext_click_date || Time.now

    self.user_account.course_reviews.find_or_create_by({
      tracked_action_id: self.id
    }).tap do |course_review|
      # first try
      CourseReviewMailer.with(course_review: course_review).build.deliver_later(wait_until: reference_date + 12.days)
      # second try
      CourseReviewMailer.with(course_review: course_review).build.deliver_later(wait_until: reference_date + 15.days)
    end
  end
end
