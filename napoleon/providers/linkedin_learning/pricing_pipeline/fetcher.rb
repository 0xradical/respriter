call

status_code = pipe_process.accumulator[:status_code]
raise "Something wrong happened, got status code #{status_code}" if status_code != 200

default_price_options = {
  type:           'subscription',
  currency:       'USD',
  customer_type:  'individual',
  plan_type:      'regular',
  trial_period:   { value: 1, unit: 'months' },
  payment_period: { value: 1, unit: 'months' }
}

document = Nokogiri::HTML(pipe_process.accumulator[:payload])
pattern = /\d+[\,\.]\d*/
prices = document
  .css('.plan-detail__subtext')
  .map(&:text)
  .map{ |pr| pr.match(pattern)[0].gsub(',', '.') }
  .sort_by(&:to_f)
  .zip( [1, 12] )
  .map do |price, months|
    default_price_options.merge(
      price:       price,
      total_price: format('%0.2f', price.to_f*months)
    )
  end

prices[0][:subscription_period] = { value: 1, unit: 'months' }
prices[1][:subscription_period] = { value: 1, unit: 'years'  }

prices[1][:original_price] = prices[0][:total_price]

discount = prices[1][:original_price].to_f - prices[1][:total_price].to_f
prices[1][:discount] = format '%0.2f', discount

pipeline.data[:prices] = prices
pipeline.save!

pipe_process.accumulator = { url: pipeline.data[:search_page_url] }
