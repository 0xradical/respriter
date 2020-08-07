content = pipe_process.data[:content]
product_id = pipe_process.data[:product_id]

price_json = JSON.load(pipe_process.accumulator[:payload])

if !price_json

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

call
