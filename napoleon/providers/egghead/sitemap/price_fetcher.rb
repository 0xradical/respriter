call

document = Nokogiri::HTML(open('https://egghead.io/pricing'))


plans = JSON.parse(document.css('.js-react-on-rails-component').children.text)['pricing']['plans']

prices = []
plans.each do |k|
  unless k['tier'] == 'basic'
    billing = {'unit' => k['interval'] + 's', 'value' => 1}
    price = k['price'].to_s + '0'
    plan = {
    'type' => 'subscription',
    'currency' => 'USD',    
    'price' => price, 
    'total_price' => price,
    'customer_type' => (k['type'].include?('team') ? 'enterprise' : 'individual'),
    'subscription_period' => billing, 
    'payment_period' => billing
    }
    prices << plan 
  end
end

raise "No valid prices for Egghead" if prices.empty?

next_pipeline = Pipeline.find pipeline.data[:next_pipeline_id]
next_pipeline.data ||= Hash.new
next_pipeline.data[:prices] = prices
next_pipeline.save!