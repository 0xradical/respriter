call

document = Nokogiri::HTML(open('https://www.codecademy.com/pricing/'))

prices = []

billing = {'unit'=> 'months', 'value'=>1}
total_price = document.css('.tierTitle__VO557Do1C-1iUfE0n7D-Z.purple__91m7A2vGVG2PsJVL13ByK').first.parent.css('.pricingAmount__rKD4KFZCKk6rEUiTpWCHG').text[/[.\d]+/]
price = {
  'type' => 'subscription',
  'currency' => 'USD',    
  'price' => total_price, 
  'total_price' => total_price,
  'customer_type' => 'individual',
  'subscription_period' => billing, 
  'payment_period' => billing
}

prices << price 

raise 'No valid prices for Codecademy' if prices.empty?

next_pipeline = Pipeline.find pipeline.data[:next_pipeline_id]
next_pipeline.data ||= Hash.new
next_pipeline.data[:prices] = prices
next_pipeline.save!
