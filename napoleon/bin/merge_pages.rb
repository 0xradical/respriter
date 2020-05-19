require_relative '../napoleon'

require 'ruby-progressbar'

def filtered_token_collection(graph)
  Napoleon::HTMLTokenCollection[ *graph.last_path.ways_and_tokens{ |w, t| w == :keep ? t : nil }.compact ]
end

class RecursiveTokenReducer
  def initialize(path)
    @path = path
  end

  def reduce(&block)
    tokens = SitemapCrawler.new(@path).crawl.map do |params|
      params[:response].response.html.to_diff_tree.tokens
    end

    pb = ProgressBar.create( total: tokens.size - 1, format: '%c / %C | %a %B %e at %R' )
    tokens.each_slice(2) do |first_tokens, second_tokens|
      return first_tokens unless second_tokens

      new_tokens = yield first_tokens, second_tokens
      tokens << new_tokens if new_tokens

      pb.increment
    end
  end
end

def recursive_merge
  index = 0
  structure_tokens = RecursiveTokenReducer.new('./providers/alura/sitemap_config.yml').reduce do |first_tokens, second_tokens|
    index += 1
    path = "diff_trees/alura/merge_graph_#{index}.dump"

    if File.exists?(path)
      graph = Marshal.load File.read path
      graph.last_path
      filtered_token_collection graph
    else
      graph = Napoleon::Graph::HTMLDiff.new first_tokens, second_tokens
      if graph.last_path
        binding.pry if $debug && graph.last_path.context.open_tree.node
        File.write path, Marshal.dump(graph)
        filtered_token_collection(graph)
      else
        puts "Missing Diff #{index}"
      end
    end
  end

  File.write 'diff_trees/alura/structure_tokens.dump', Marshal.dump(structure_tokens)
end

recursive_merge
