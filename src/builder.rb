# frozen_string_literal: true

require 'net/http'
require 'nokogiri'
require 'json'

ROOT    = File.expand_path(File.join(File.dirname(__FILE__), '..'))
dist    = File.join(ROOT, 'dist')
defs    = File.join(dist, 'defs')
symbols = File.join(dist, 'symbols')

Dir.mkdir(defs) unless File.exist?(defs)
Dir.mkdir(symbols) unless File.exist?(symbols)

# building dependency tree
deps_tree = {}

%w[brand i18n icons providers tags].each do |namespace|
  response = Net::HTTP.get_response(URI("https://elements-prd.classpert.com/8.2.1/svgs/sprites/#{namespace}.svg"))

  sprite = Nokogiri::XML(response.body)

  sprite.css('defs > *').each do |definition|
    File.open(File.join(defs, definition['id']), 'w+') do |f|
      f.write(definition.to_xml)
    end
  end

  sprite.css('symbol').each do |symbol|
    File.open(File.join(symbols, symbol['id']), 'w+') do |f|
      f.write(symbol.to_xml)
    end

    deps_tree[symbol['id']] = []

    symbol.xpath(".//*[@*[starts-with(.,'url(#')]]").each do |property_using_def|
      property_using_def.attributes.each do |_, attribute_with_def|
        match = attribute_with_def&.value&.match(/url\(#(?<def>[^)]+)\)/)

        deps_tree[symbol['id']] << match['def'] if match
      end
    end
  end
end

File.open(File.join(dist, 'dependencies.json'), 'w+') do |f|
  f.write(JSON.dump(deps_tree))
end
