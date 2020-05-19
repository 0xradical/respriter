#!/usr/bin/env ruby

require_relative '../napoleon'

path    = ARGV[0] || 'debug/samples/simple'
content = File.read "#{path}.html"
tree    = Nokogiri::HTML(content).to_diff_tree

lmth = tree.to_lmth
File.write "#{path}.lmth", lmth

puts lmth
