call

document = Nokogiri::HTML(pipe_process.accumulator[:payload])

pattern = /(?<price>\d+[\,\.]\d*).* charged every (?<months>\d*)\s?month/
prices = document
  .css('.total-price')
  .map(&:text)
  .map(&:strip)
  .map{ |pr| pr.match pattern }
  .map do |m|
    {
      price: m[:price].gsub(',', '.').to_f,
      months: (m[:months] == '' ? 1 : m[:months].to_i)
    }
  end

next_pipeline = Pipeline.find pipeline.data[:next_pipeline_id]
next_pipeline.data = { prices: prices }
next_pipeline.save!
