call

document = Nokogiri::HTML(open('https://frontendmasters.com/join/'))

prices = []
document.css('.SubscriptionList .details').each do |k|
  plan_name = k.css(".name").text.downcase
  billing = {"unit"=> (plan_name.include?('monthly') ? 'months' : 'years'), 
    "value"=>1}
  total_price = k.css(".price").text.delete("\n $") << '.00'
  price = {
    'type' => 'subscription',
    'currency' => 'USD',    
    'price' => total_price, 
    'total_price' => total_price,
    'customer_type' => (plan_name.include?('team') ? 'enterprise' : 'individual'),
    'subscription_period' => billing, 
    'payment_period' => billing
  }
  prices << price 
end

raise "No valid prices for Frontend Masters" if prices.empty?

next_pipeline = Pipeline.find pipeline.data[:next_pipeline_id]
next_pipeline.data ||= Hash.new
next_pipeline.data[:prices] = prices
next_pipeline.save!
