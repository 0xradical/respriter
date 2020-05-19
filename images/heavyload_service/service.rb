require 'sinatra'

get '/hello' do
  'Hello world!'
end

class BigFile
  def initialize(pattern, repeats)
    @pattern, @repeats = pattern, repeats
  end

  def each
    @repeats.times{ yield @pattern }
  end
end

get '/big_file/:pattern/:repeats.:format' do
  params['pattern'] * params['repeats'].to_i
end

get '/stream_big_file/:pattern/:repeats.:format' do
  BigFile.new params['pattern'], params['repeats'].to_i
end

puts 'Dummy Service Running'
