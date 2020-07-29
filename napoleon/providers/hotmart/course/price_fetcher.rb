call

content = pipe_process.data[:content]
product_id = pipe_process.data[:product_id]
offer_id = pipe_process.data[:offer_id]

price_api_url = "https://api-display.hotmart.com/back/rest/v3/product/#{product_id}/offer"

price_api_url += "?off=#{offer_id}" if offer_id

begin
  price_json = JSON.load(open(price_api_url).read)
rescue
  raise Pipe::Error.new(:skipped, 'Course offer unavailable')
end

payment_data = price_json['products'].first['offer']['paymentInfoResponse']['installmentList']&.select{|k| k['installmentNumber'] == 1}&.first&.[]('offerInstallmentTotalPrice') || price_json['products'].first['offer']['paymentInfoResponse']['offerPriceWithoutVAT']
prices = [{
  type:      'single_course',
  plan_type: 'regular',
  price:     payment_data['value'],
  currency:  payment_data['currencyCode']
}]

content[:prices] = prices

pipe_process.accumulator = {
  kind: :course,
  schema_version: '2.0.0',
  unique_id: Digest::SHA1.hexdigest(product_id),
  content: content,
  relations: Hash.new
}
