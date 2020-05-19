require_relative '../napoleon'

require 'ruby-progressbar'

def filtered_token_collection(tsp)
  Napoleon::HTMLTokenCollection[ *tsp.last_path.ways_and_tokens{ |a, t| a == :remove || a.nil? ? nil : t }.compact ]
end

def each_tokens(&block)
  tokens = SitemapCrawler.new('./providers/alura/sitemap_config.yml').crawl
  pb = ProgressBar.create total: tokens.size, format: '%c / %C | %a %B %e at %R'
  tokens.each_with_index do |params, index|
    yield index, params[:url], params[:response].response.html.to_diff_tree.tokens
    pb.increment
  end
end

def perform
  keep_tokens = Marshal.load File.read 'diff_trees/alura/structure_tokens.dump'

  each_tokens do |index, url, tokens|
    begin
      data = Napoleon::ExtractedData.new keep_tokens, index, url, tokens
      if data.extract
        File.write "./diff_trees/alura/data_#{index}.dump", Marshal.dump(data)
      else
        binding.pry if $debug
        puts "Missing Data at #{index}"
      end
    rescue
      binding.pry if $debug
    end
  end

end

$debug = true
perform
