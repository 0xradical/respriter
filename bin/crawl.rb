#!/usr/bin/env ruby
require 'net/http'

require_relative '../napoleon'

def build_automata(path)
  src = File.read "#{path}.lmth"
  ast = Napoleon::Parser.new(src).parse
  Napoleon::Automata.new ast
end

def get_tokens(path)
  content = if path.match(/^https?:\/\//)
    Net::HTTP.get URI(path)
  else
    File.read path
  end
  Nokogiri::HTML(content).to_diff_tree.tokens[1..-1]
end

def save_automata_graph(path, automata)
  automata_json = automata.as_json.deep_symbolize_keys
  STDERR.puts automata_json.ai.red

  nodes = automata_json[:states].flatten
  nodes.delete :finished
  node_names = (0..automata_json[:states].size - 1).to_a.map &:to_s
  node_edges = nodes.map{ |n| "#{n.first_state} -> #{n.last_state} #{ n.dot_label };" }

  template = "digraph G {\n#{ node_names.join "\n" }\n#{ node_edges.join "\n" }\n}\n"

  File.write "#{ path }.dot", template
end

def parse(automata, tokens)
  graph = Napoleon::Graph::Automata.new automata, tokens
  graph.search ? graph : nil
end

$debug = true

src_path  = ARGV[0] || 'debug/samples/simple'
html_path = ARGV[1] || "#{src_path}.html"

tokens   = get_tokens html_path
automata = build_automata src_path

save_automata_graph src_path, automata

if graph = parse(automata, tokens)
  puts JSON.pretty_generate(graph.extract_data)
else
  STDERR.puts 'Page could not be parsed by this code'.red
end
