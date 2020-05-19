# pricing
price_regx = Regexp.new(["5c24285b5c645d2b29"].pack('H*'))

call

document = Nokogiri::HTML(pipe_process.accumulator[:payload])

basic_plan = document.css('.plan-panel.plan-basic .plan-cta a').first[:href]
pro_plan   = document.css('.plan-panel.plan-pro .plan-cta a').first[:href]

pipe_process.accumulator = { url: basic_plan }
call

document      = Nokogiri::HTML(pipe_process.accumulator[:payload])
monthly_basic = document.css('#subscribe_monthly .price').text.strip[price_regx,1]
annual_basic  = document.css('#subscribe_annually .price').text.strip[price_regx,1]

pipe_process.accumulator = { url: pro_plan }
call

document      = Nokogiri::HTML(pipe_process.accumulator[:payload])

monthly_pro = document.css('#subscribe_monthly .price').text.strip[price_regx,1]
annual_pro  = document.css('#subscribe_annually .price').text.strip[price_regx,1]

prices      = [
  {
    type: 'subscription',
    price: ('%.2f' % monthly_basic),
    total_price: ('%.2f' % monthly_basic),
    currency: 'USD',
    plan_type: 'regular',
    customer_type: 'individual',
    subscription_period: { value: 1, unit: 'months' },
    payment_period: { value: 1, unit: 'months' },
    trial_period: { value: 7, unit: 'days' }
  },
  {
    type: 'subscription',
    price: ('%.2f' % annual_basic),
    total_price: ('%.2f' % annual_basic),
    currency: 'USD',
    plan_type: 'regular',
    customer_type: 'individual',
    subscription_period: { value: 1, unit: 'years' },
    payment_period: { value: 1, unit: 'years' },
    trial_period: { value: 7, unit: 'days' }
  },
  {
    type: 'subscription',
    price: ('%.2f' % monthly_pro),
    total_price: ('%.2f' % monthly_pro),
    currency: 'USD',
    plan_type: 'premium',
    customer_type: 'individual',
    subscription_period: { value: 1, unit: 'months' },
    payment_period: { value: 1, unit: 'months' },
    trial_period: { value: 7, unit: 'days' }
  },
  {
    type: 'subscription',
    price: ('%.2f' % annual_pro),
    total_price: ('%.2f' % annual_pro),
    currency: 'USD',
    plan_type: 'premium',
    customer_type: 'individual',
    subscription_period: { value: 1, unit: 'years' },
    payment_period: { value: 1, unit: 'years' },
    trial_period: { value: 7, unit: 'days' }
  }
]

pipeline.data ||= {}
pipeline.data[:prices] = prices
pipeline.save!