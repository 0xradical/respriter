require 'nokogiri'

module Sitemap
  class Validator
    SITEMAP_SCHEMA =
      File.join(
        File.expand_path(File.dirname(__FILE__)),
        'schemas',
        'sitemap.xsd'
      )
    SITEINDEX_SCHEMA =
      File.join(
        File.expand_path(File.dirname(__FILE__)),
        'schemas',
        'siteindex.xsd'
      )

    attr_reader :sitemap_schema, :siteindex_schema

    def initialize
      @sitemap_schema = Nokogiri::XML.Schema(File.open(SITEMAP_SCHEMA))
      @siteindex_schema = Nokogiri::XML.Schema(File.open(SITEINDEX_SCHEMA))
    end

    def validate(source)
      contents =
        begin
          Zlib::Inflate.inflate(source)
        rescue StandardError
          source
        end

      document = Nokogiri.XML(contents)

      # remove unknown namespaces
      document.collect_namespaces.except('xmlns').each do |namespace, namespace_uri|
        document.xpath('//namespace:*', {
          namespace: namespace_uri
        }).each(&:remove)
      end

      sitemap_errors = @sitemap_schema.validate(document)
      siteindex_errors = @siteindex_schema.validate(document)

      if sitemap_errors.size == 0 || siteindex_errors.size == 0
        sitemap_errors.size == 0 ? :sitemap : :sitemap_index
      else
        :invalid
      end
    rescue StandardError
      :error
    end
  end
end
