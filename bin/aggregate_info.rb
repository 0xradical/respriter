require_relative '../napoleon'

require 'ruby-progressbar'

def each_data(&block)
  count = 0
  tokens = SitemapCrawler.new('./providers/alura/sitemap_config.yml').crawl
  pb = ProgressBar.create total: tokens.size, format: '%a %B %e at %R'
  tokens.map do |params|
    data = Marshal.load File.read "diff_trees/alura/data_#{count}.dump"
    parsed_tokens = data[:ass].tokens.find_all{ |step, token| !( token[0] == :Text && token[2] == '' ) }
    yield count, params[:url], params[:response].response.html.to_diff_tree.tokens, data, parsed_tokens
    count += 1
    pb.increment
  end
  count
end

def perform(last_structure_index)
  all_tokens = []
  each_data do |index, url, raw_tokens, ass, tokens|
    begin
      last_keep_index = 0
      open_added  = []
      root_tokens = []
      all_tokens.push root_tokens
      tokens.each do |step, token|
        indexed_token = {
          index: last_keep_index,
          step:  step,
          token: token
        }

        case step
        when :keep
          if open_token = open_added.last
            open_token[:children] ||= []
            open_token[:children].push indexed_token
          else
            root_tokens.push indexed_token
          end
          last_keep_index += 1
        when :add
          if open_token = open_added.last
            open_token[:children] ||= []
            open_token[:children].push indexed_token
          else
            root_tokens.push indexed_token
          end

          case token.first
          when :Element
            open_added.push indexed_token
          when :ElementClose
            open_added.pop
          end
        end
      end
      all_tokens
    rescue
      binding.pry if $debug
    end
  end
  all_tokens
end

def perform_flat(last_structure_index)
  all_tokens = []
  each_data do |index, url, raw_tokens, ass, tokens|
    begin
      last_keep_index = 0
      root_tokens = []
      all_tokens.push root_tokens

      tokens.each do |step, token|
        case step
        when :keep
          indexed_token = {
            index: last_keep_index,
            step:  step,
            token: token
          }
          root_tokens.push indexed_token
          last_keep_index += 1
        when :add
          if root_tokens.last[:step] == :keep
            root_tokens.push(
              index: last_keep_index,
              step: :add,
              tokens: []
            )
          end
          root_tokens.last[:tokens].push token
        end
      end
      all_tokens
    rescue
      binding.pry if $debug
    end
  end
  all_tokens
end

# $debug      = true
# tokens      = perform 561
# flat_tokens = perform_flat 561
# binding.pry

# # Childrenless
# union = tokens.inject([]){ |res, tk| res | tk.find_all{|t| t[:step] == :add && t[:children].blank? }.map{ |t| t[:index] } }.sort
# intersection = tokens.inject(union){ |res, tk| res & tk.find_all{|t| t[:step] == :add && t[:children].blank? }.map{ |t| t[:index] } }.sort
#
# # Childrened
# union = tokens.inject([]){ |res, tk| res | tk.find_all{|t| t[:step] == :add }.map{ |t| t[:index] } }.sort
# intersection = tokens.inject(union){ |res, tk| res & tk.find_all{|t| t[:step] == :add }.map{ |t| t[:index] } }.sort
#
# tokens.map{ |tk| tk.find{ |t| t[:step] == :add && t[:index] == 24 } }

# # Flat Childrened
# flat_union = flat_tokens.inject([]){ |res, tk| res | tk.find_all{|t| t[:step] == :add }.map{ |t| t[:index] } }.sort
# flat_intersection = flat_tokens.inject(flat_union){ |res, tk| res & tk.find_all{|t| t[:step] == :add }.map{ |t| t[:index] } }.sort


# indexed_add_tokens = flat_tokens.map do |tk|
#   Hash[
#     tk.find_all{ |t| t[:step] == :add }.map do |add_token|
#       add_token.values_at :index, :tokens
#     end
#   ]
# end
#
# flat_replacements = Hash.new
# flat_union.each do |index|
#   summary = indexed_add_tokens.map do |indexed_token|
#     # next [ nil, 1 ] if indexed_token[index].nil?
#     #
#     # indexed_token[index].group_by(&:first).map do |type, tokens|
#     #   [type, tokens.count]
#     # end.sort
#
#     indexed_token[index].nil? ? [] : indexed_token[index].map(&:first)
#
#   end.group_by(&:itself).map do |element, occurrences|
#     [occurrences.count, element]
#   end.sort_by(&:first).reverse!
#
#   flat_replacements[index] = summary
# end; nil

require_relative '../napoleon/strucure_html_visualizer'

vis   = StrucureHTMLVisualizer.new 'alura'
repls = vis.flat_replacements
binding.pry
