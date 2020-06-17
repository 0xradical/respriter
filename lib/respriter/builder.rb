# frozen_string_literal: true

require 'net/http'
require 'nokogiri'
require 'json'

module Respriter
  class Builder
    def initialize(namespaces)
      @namespaces = namespaces
      @definitions_tree = {}
      @definitions = {}
      @symbols = {}
    end

    def setup
      Respriter.setup
    end

    # Download everything upfront and then process
    # This is necessary for dependency tree building
    def load
      @namespaces.each do |namespace|
        @definitions[namespace] ||= {}
        @symbols[namespace]     ||= {}
        ns_defs_dir = File.join(Respriter.defs_dir, namespace)
        ns_symbols_dir = File.join(Respriter.symbols_dir, namespace)

        Dir.mkdir(ns_defs_dir) unless File.exist?(ns_defs_dir)
        Dir.mkdir(ns_symbols_dir) unless File.exist?(ns_symbols_dir)

        response = Net::HTTP.get_response(
          URI("https://elements-prd.classpert.com/8.2.1/svgs/sprites/#{namespace}.svg")
        )

        sprite = Nokogiri::XML(response.body)

        sprite.css('defs > *').each do |definition|
          @definitions[namespace][definition['id']] = definition

          File.open(File.join(ns_defs_dir, definition['id']), 'w+') do |f|
            f.write(definition.to_xml)
          end
        end

        sprite.css('symbol').each do |symbol|
          @symbols[namespace][symbol['id']] = symbol

          File.open(File.join(ns_symbols_dir, symbol['id']), 'w+') do |f|
            f.write(symbol.to_xml)
          end
        end
      end
    end

    def extract_dependencies
      @namespaces.each do |namespace|
        @definitions_tree[namespace] ||= {}

        @symbols[namespace].each do |symbol_id, symbol|
          symbol.xpath(".//*[@*[starts-with(.,'url(#')]]").each do |property|
            @definitions_tree[namespace][symbol_id] = definition_dependencies(@definitions, property, [])
          end
        end
      end
    end

    def definition_dependencies(definitions, definition, result = [])
      definition.attributes.each do |_, attribute|
        match = attribute&.value&.match(/url\(#(?<id>[^)]+)\)/)

        next unless match && match['id']

        result << match['id']

        if definitions[match['id']]
          result.concat(definition_dependencies(definitions, definitions[match['id']], result))
        end
      end

      result
    end

    def dump_dependencies
      File.open(Respriter.dependencies_file, 'w+') do |f|
        f.write(JSON.dump(@definitions_tree))
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
