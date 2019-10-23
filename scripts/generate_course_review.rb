# for testing purposes only
# forces creation of course_review
# given an enrollment with user_account_id
# example: "82576ad6-1dac-490b-8f55-21008e5f695a"
def course_review(enrollment_id)
  rakuten = Integration::TrackedActions::RakutenMarketingService.new
  enrollment = Enrollment.find(enrollment_id)
  provider = enrollment.course.provider
  time = Time.now

  # rakuten
  if provider.id.in?([1,3,33])
    transaction_id = SecureRandom.alphanumeric(32).upcase
    vowels = [65, 69, 73, 79, 85]
    consonants = (65..90).to_a - vowels
    course_name = (0..5).map do |i|
      if i % 2 == 0
        vowels[rand(vowels.size)].chr
      else
        consonants[rand(consonants.size)].chr
      end
    end.join.downcase.upcase_first
    course_id = SecureRandom.random_number(99999999)

    resource = {
      "u1"               => enrollment.id,
      "sid"              => SecureRandom.random_number(9999999),
      "currency"         => "USD",
      "is_event"         => "N",
      "offer_id"         => "#{SecureRandom.random_number(99999)}",
      "order_id"         => "#{SecureRandom.random_number(9999999)}",
      "quantity"         => 1,
      "sku_number"       => "linkshare.course.#{SecureRandom.random_number(99999999)}",
      "commissions"      => 1.8,
      "sale_amount"      => 12,
      "process_date"     => time.utc.strftime('%a %b %e %Y %H:%M:%S GMT+0000 (UTC)'),
      "product_name"     => "Learn #{course_name} Programming | Complete Course",
      "advertiser_id"    => provider.id + 39197,
      "etransaction_id"  => transaction_id,
      "transaction_date" => (time - 10.seconds).utc.strftime('%a %b %e %Y %H:%M:%S GMT+0000 (UTC)'),
      "transaction_type" => "realtime",
      "bogus"            => true
    }

    tracked_action = rakuten.tracked_action(resource)

    class << tracked_action
      def trigger_webhook; end
    end

    tracked_action.save
  else
    nil
  end
end