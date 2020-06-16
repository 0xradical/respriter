# frozen_string_literal: true

require 'json'

ROOT    = File.expand_path(File.join(File.dirname(__FILE__), '..'))
dist    = File.join(ROOT, 'dist')
defs    = File.join(dist, 'defs')
symbols = File.join(dist, 'symbols')

dependencies = JSON.parse(File.read(File.join(dist, 'dependencies.json')))

puts ARGV[0]
tags = %w[computer_science ruby_programming]

tag_dependencies = tags.flat_map do |tag|
  dependencies['tags-' + tag]
end.compact

output = StringIO.new
output.write(%(<svg xmlns="http://www.w3.org/2000/svg">))
tag_dependencies.each do |dep|
  output.write(File.read(File.join(defs, dep)))
end
tags.each do |tag|
  output.write(File.read(File.join(symbols, 'tags-' + tag)))
end
output.write(%(</svg>))
output.rewind
puts output.read
