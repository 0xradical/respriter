# frozen_string_literal: true

require 'net/http'
require 'nokogiri'
require 'json'

module Respriter
  class Builder
    def initialize(scope, urls)
      @scope = scope
      @urls = urls
      @dependencies_tree = {}
      @definitions = {}
      @symbols = {}
    end

    def setup
      Respriter.setup(@scope)
    end

    # Download everything upfront and then process
    # This is necessary for dependency tree building
    def load
      @urls.each do |url|
        response = Net::HTTP.get_response(URI(url))

        sprite = Nokogiri::XML(response.body)

        sprite.css('defs > *').each do |definition|
          @definitions[definition['id']] = definition

          File.open(File.join(Respriter.defs_dir(@scope), definition['id']), 'w+') do |f|
            f.write(definition.to_xml)
          end
        end

        sprite.css('symbol').each do |symbol|
          @symbols[symbol['id']] = symbol

          File.open(File.join(Respriter.symbols_dir(@scope), symbol['id']), 'w+') do |f|
            f.write(symbol.to_xml)
          end
        end
      end
    end

    def extract_dependencies
      @dependencies_tree ||= {}

      resolver = Respriter::DependencyResolver.new(
        @definitions,
        proc { |entity| entity.to_xml.scan(/url\(#(?<id>[^)]+)\)/) }
      )

      @symbols.each do |symbol_id, symbol|
        symbol_dependencies = resolver.resolve(symbol)

        unless symbol_dependencies.empty?
          @dependencies_tree[symbol_id] = symbol_dependencies
        end
      end
    end

    def dump_dependencies
      File.open(Respriter.dependencies_file(@scope), 'w+') do |f|
        f.write(JSON.dump(@dependencies_tree))
      end
    end

    def run
      setup
      load
      extract_dependencies
      dump_dependencies
    end
  end
end
