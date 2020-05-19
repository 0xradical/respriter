#!/usr/bin/env ruby

require_relative '../napoleon'

$debug = true

src_path      = ARGV[0] || 'debug/samples/simple'
src           = File.read "#{src_path}.lmth"
ast           = Napoleon::Parser.new(src).parse
automata      = Napoleon::Automata.new(ast)
automata_json = automata.as_json.deep_symbolize_keys
ap automata_json

nodes = automata_json[:states].flatten
nodes.delete :finished
node_names = (0..automata_json[:states].size - 1).to_a.map &:to_s
node_edges = nodes.map{ |n| "#{n.first_state} -> #{n.last_state} #{ n.dot_label };" }

template = "digraph G {\n#{ node_names.join "\n" }\n#{ node_edges.join "\n" }\n}\n"

File.write "#{ src_path }.dot", template

html_path = ARGV[1] || src_path
tokens    = Nokogiri::HTML(File.read "#{html_path}.html").to_diff_tree.tokens[1..-1]
graph     = Napoleon::Graph::Automata.new automata, tokens

begin
  graph.search!
  puts JSON.pretty_generate(graph.extract_data)
rescue Napoleon::Search::NotFoundError => error
  STDERR.puts error.pretty_message
  exit -1
rescue
  binding.pry if $debug
  exit -1
end
