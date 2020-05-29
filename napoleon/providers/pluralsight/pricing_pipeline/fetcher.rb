call
payload            = pipe_process.accumulator[:payload]
pricing            = JSON.load(payload)
products           = pricing['data']['products']
prices             = []
valid_skus_mkt_ids = {
  "INDIVIDUAL"                 => ["IND-Y-PLUS", "IND-M-PLUS"],
  "INDIVIDUAL-PREM"            => ["IND-Y-PREM"],
  "PROFESSIONAL-SG"            => ["PROFESSIONAL-SG"],
  "ENTERPRISE-NO-MENTORING-SG" => ["ENTERPRISE-NO-MENTORING-SG"]
}
valid_skus = valid_skus_mkt_ids.keys

products.each do |product|
  next unless valid_skus.include?(product['sku'])
  product['options'].each do |options|
    next if options['freeTrial']
    next unless valid_skus_mkt_ids[product['sku']].include?(options['marketingId'])

    options['pricing'].each do |pricing|
      price = {
        'type' => 'subscription',
        'customer_type' => (product['customerType'] == 'Individual' ? 'individual' : 'enterprise'),
        'plan_type' => (product['name'] =~ /premium/i ? 'premium' : 'regular'),
        'currency' => pricing['currency']
      }

      if options['billingPeriod']
        billing = { 'value' => 1, 'unit' => (options['billingPeriod'] == 'Month' ? 'months' : 'years') }

        price.merge!({
          'price' => ('%.2f' % pricing['price']),
          'total_price' => ('%.2f' % pricing['price']),
          'subscription_period' => billing,
          'payment_period' => billing,
          'trial_period' => { 'value' => (price['customer_type'] == 'individual' ? 10 : 14), 'unit' => 'days' }
        })

        prices << price
      end
    end
  end
end

raise "No valid prices for Pluralsight" if prices.empty?

pipeline.data ||= {}
pipeline.data[:prices] = prices
pipeline.save!
