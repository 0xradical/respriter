require 'json'
require 'yaml'
require 'digest'
require 'logger'
require 'strscan'
require 'fileutils'

require 'pry'
require 'nokogiri'
require 'awesome_print'
require 'faraday'
require 'faraday_middleware'
require 'active_support'
require 'active_support/cache'
require 'active_support/core_ext'

require 'colorize'
require 'algorithms'

[
  './core_ext/*.rb'
].each do |glob|
  Dir[glob].sort.each{ |file| require_relative(file) }
end

require_relative './napoleon/configuration'

[
  './config/initializers/*.rb'
].each do |glob|
  Dir[glob].sort.each{ |file| require_relative(file) }
end

module Napoleon
  autoload :BaseCrawler,    './napoleon/crawler/base.rb'
  autoload :SitemapCrawler, './napoleon/crawler/sitemap.rb'

  autoload :Storage, './napoleon/storage.rb'

  autoload :HTTPClient,           './napoleon/http_client.rb'
  autoload :SafeMarkdownRenderer, './napoleon/safe_markdown_renderer.rb'

  autoload :HTMLTokenCollection, './napoleon/html_token_collection.rb'
  autoload :HTMLToken,           './napoleon/html_token.rb'

  autoload :ExtractedData, './napoleon/extracted_data.rb'

  autoload :Parser,   './napoleon/parser.rb'
  autoload :Automata, './napoleon/automata.rb'

  autoload :VideoDownloader, './napoleon/video_downloader.rb'
  autoload :JavaScript, './napoleon/javascript.rb'

  module Automatum
    autoload :Base,  './napoleon/automatum/base.rb'

    autoload :Tag,          './napoleon/automatum/tag.rb'
    autoload :CloseOpenTag, './napoleon/automatum/tag.rb'
    autoload :CloseTag,     './napoleon/automatum/tag.rb'

    autoload :Attributes, './napoleon/automatum/attributes.rb'

    autoload :IteratorStart, './napoleon/automatum/iterator.rb'
    autoload :IteratorClose, './napoleon/automatum/iterator.rb'

    autoload :TagPlaceholder,      './napoleon/automatum/tag_placeholder.rb'
    autoload :TagPlaceholderClose, './napoleon/automatum/tag_placeholder.rb'

    autoload :PlaceholderCapture, './napoleon/automatum/placeholder_capture.rb'
    autoload :CDATACapture,       './napoleon/automatum/placeholder_capture.rb'
    autoload :CommentCapture,     './napoleon/automatum/placeholder_capture.rb'
    autoload :DoctypeCapture,     './napoleon/automatum/placeholder_capture.rb'
    autoload :DTDCapture,         './napoleon/automatum/placeholder_capture.rb'
    autoload :TextCapture,        './napoleon/automatum/placeholder_capture.rb'
    autoload :TagCapture,         './napoleon/automatum/placeholder_capture.rb'
    autoload :CloseTagCapture,    './napoleon/automatum/placeholder_capture.rb'

    autoload :StringAutomatum,       './napoleon/automatum/string_automatum.rb'
    autoload :Text,                  './napoleon/automatum/text.rb'
    autoload :CDATA,                 './napoleon/automatum/cdata.rb'
    autoload :Comment,               './napoleon/automatum/comment.rb'
    autoload :Doctype,               './napoleon/automatum/doctype.rb'
    autoload :ProcessingInstruction, './napoleon/automatum/processing_instruction.rb'

    autoload :Empty, './napoleon/automatum/empty.rb'
  end

  module Path
    autoload :Base,     './napoleon/path/base.rb'
    autoload :HTMLDiff, './napoleon/path/html_diff.rb'
    autoload :Automata, './napoleon/path/automata.rb'
  end

  module Search
    autoload :Base,          './napoleon/search/base.rb'
    autoload :NotFoundError, './napoleon/search/base.rb'
    autoload :AStar,         './napoleon/search/a_star.rb'
  end

  module Graph
    autoload :Base,     './napoleon/graph/base.rb'
    autoload :HTMLDiff, './napoleon/graph/html_diff.rb'
    autoload :Automata, './napoleon/graph/automata.rb'
  end

  module HTMLDiffTree
    autoload :Node,                  './napoleon/html_diff_tree/node.rb'
    autoload :StringNode,            './napoleon/html_diff_tree/string_node.rb'
    autoload :Document,              './napoleon/html_diff_tree/document.rb'
    autoload :Element,               './napoleon/html_diff_tree/element.rb'
    autoload :Text,                  './napoleon/html_diff_tree/text.rb'
    autoload :CDATA,                 './napoleon/html_diff_tree/cdata.rb'
    autoload :Comment,               './napoleon/html_diff_tree/comment.rb'
    autoload :ProcessingInstruction, './napoleon/html_diff_tree/processing_instruction.rb'
  end
end

AwesomePrint.defaults = { indent: 2, index: false }
