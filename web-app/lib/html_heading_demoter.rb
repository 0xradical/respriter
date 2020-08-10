# frozen_string_literal: true

require 'nokogiri'

module HTMLHeadingDemoter
  module_function

  def demote(html)
    parsed_html = Nokogiri::HTML.fragment(html)
    parsed_html.css('h1, h2, h3, h4, h5').each do |node|
      if (match = node.name.match(/h(?<level>[1-5])/))
        node_level = match['level'].to_i
        node.name = "h#{node_level + 1}"
      end
    end
    parsed_html.to_s
  end
end
