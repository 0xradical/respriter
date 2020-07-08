# frozen_string_literal: true

class CourseReviewMailerPreview < ActionMailer::Preview
  def build
    user_account = UserAccount.find(351)
    course_review = user_account.course_reviews.first

    if course_review.nil?
      enrollment =
        user_account.enrollments.joins(:course).where(
          "courses.slug IN ('coursera','edureka','udemy')"
        )
                    .first

      course_review = phony_course_review(enrollment.id)
    end

    CourseReviewMailer.with(course_review: course_review).build
  end

  private

  def phony_course_review(enrollment_id)
    rakuten = Integration::TrackedActions::RakutenMarketingService.new
    enrollment = Enrollment.find(enrollment_id)
    user_account = enrollment.user_account
    provider = enrollment.course.provider
    time = Time.now

    # rakuten
    if provider.slug.in?(['coursera','edureka','udemy'])
      transaction_id = SecureRandom.alphanumeric(32).upcase
      vowels = [65, 69, 73, 79, 85]
      consonants = (65..90).to_a - vowels
      course_name =
        (0..5).map do |i|
          if i.even?
            vowels[rand(vowels.size)].chr
          else
            consonants[rand(consonants.size)].chr
          end
        end.join
              .downcase
              .upcase_first
      course_id = SecureRandom.random_number(99_999_999)

      resource = {
        'u1'               => enrollment.id,
        'sid'              => SecureRandom.random_number(9_999_999),
        'currency'         => 'USD',
        'is_event'         => 'N',
        'offer_id'         => SecureRandom.random_number(99_999).to_s,
        'order_id'         => SecureRandom.random_number(9_999_999).to_s,
        'quantity'         => 1,
        'sku_number'       =>
                              "linkshare.course.#{SecureRandom.random_number(99_999_999)}",
        'commissions'      => 1.8,
        'sale_amount'      => 12,
        'process_date'     =>
                              time.utc.strftime('%a %b %e %Y %H:%M:%S GMT+0000 (UTC)'),
        'product_name'     => "Learn #{course_name} Programming | Complete Course",
        'advertiser_id'    => provider.id + 39_197,
        'etransaction_id'  => transaction_id,
        'transaction_date' =>
                              (time - 10.seconds).utc.strftime(
                                '%a %b %e %Y %H:%M:%S GMT+0000 (UTC)'
                              ),
        'transaction_type' => 'realtime',
        'bogus'            => true
      }

      tracked_action = rakuten.tracked_action(resource)

      class << tracked_action
        def trigger_webhook; end
      end

      tracked_action.save

      user_account.course_reviews.find_or_create_by(
        { tracked_action_id: id }
      )
    end
  end
end
