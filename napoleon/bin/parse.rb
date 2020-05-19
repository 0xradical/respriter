#!/usr/bin/env ruby

require_relative '../napoleon'

$debug = true

path = ARGV[0] || 'debug/samples/simple.lmth'
src  = File.read path
begin
  ap Napoleon::Parser.new(src).parse!
rescue Napoleon::Parser::ParserError => error
  STDERR.puts error.pretty_message
  exit -1
end