# call
#
# document = Nokogiri::HTML(pipe_process.accumulator[:payload])
# prices   = document.css('.prices').map(&:text).map(&:strip).map{ |pr| pr.match(/\$(.*)\/Mo/)[1] }
#
# yearly_price, monthly_price = prices.sort_by{ |x| x.to_f }
# total_yearly_price = '%.2f' % (yearly_price.to_f*12)
#
# prices = [
#   { type: 'subscription', price: monthly_price, total_price: monthly_price,      trial_period: '2M', subscription_period: '1M', payment_period: '1M' },
#   { type: 'subscription', price: yearly_price,  total_price: total_yearly_price, trial_period: '2M', subscription_period: '1Y', payment_period: '1M' }
# ]

prices = [
  { type: 'subscription', currency: 'USD', price: '15.00', total_price: '15.00',                   trial_period: '2M', subscription_period: '1M', payment_period: '1M' },
  { type: 'subscription', currency: 'USD', price:  '8.25', total_price: '99.00', discount: '6.75', trial_period: '2M', subscription_period: '1Y', payment_period: '1M' }
]

next_pipeline = Pipeline.find pipeline.data[:next_pipeline_id]
next_pipeline.data ||= Hash.new
next_pipeline.data[:prices] = prices
next_pipeline.save!
