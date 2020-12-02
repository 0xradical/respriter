# frozen_string_literal: true

require 'net/http'
require 'nokogiri'
require 'json'

module Respriter
  class Builder
    def initialize(scope, files)
      @scope = scope
      @files = files
      @dependencies_tree = {}
      @definitions = {}
      @symbols = {}
    end

    def setup
      Respriter.setup(@scope)
    end

    def urls
      @files
    end

    # Download everything upfront and then process
    # This is necessary for dependency tree building
    def load
      urls.each do |url|
        response = get_response(URI(url))

        raise 'Sprite not found' if response.code != '200'

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

      # <use fill="url(#id-4-i18ne)" xlink:href="#id-3-i18nd"/>
      resolver = Respriter::DependencyResolver.new(
        @definitions,
        proc { |entity| entity.to_xml.scan(/(url\(|xlink:href=["']{1})#(?<id>[^)"']+)/) }
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

    private

    def get_response(url)
      uri = URI(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == 'https'
      http.open_timeout = 5 # in seconds
      http.read_timeout = 10 # in seconds
      http.request(Net::HTTP::Get.new(uri.request_uri))
    end
  end
end
