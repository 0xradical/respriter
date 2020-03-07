require 'strscan'

module SitemapsSerializer
  ID_REGEX = /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
  STATUS_REGEX = /(verified|invalid|unverified)/
  TYPE_REGEX = /(sitemap|sitemap_index|unknown)/
  URL_REGEX = %r{https?\:\/\/[\w\-\_]+(\.[\w\-\_]+)+\/([\.\w\-\_]*\/?)*}
  SITEMAP_REGEX = /\,?\"\((?<id>#{ID_REGEX}),(?<status>#{
    STATUS_REGEX
  }),(?<url>#{URL_REGEX}),(?<type>#{TYPE_REGEX})\)\"/

  KEYS = %i[id status url type]

  def self.load(value)
    return nil if value.nil?
    return [] if value == '{}'
    values = []
    scanner = StringScanner.new value[1..-2]
    until scanner.eos?
      values <<
        KEYS.zip(
          scanner.scan(SITEMAP_REGEX).match(SITEMAP_REGEX).values_at(*KEYS)
        )
          .to_h
    end
    values
  end

  def self.dump(values)
    return nil if values.nil?

    '{' +
      values.map do |value|
        unless value[:id].match(/\A#{ID_REGEX}\Z/)
          raise "Invalid sitemap id #{value[:id].inspect}"
        end
        unless value[:status].match(/\A#{STATUS_REGEX}\Z/)
          raise "Invalid sitemap status #{value[:status].inspect}"
        end
        unless value[:type].match(/\A#{TYPE_REGEX}\Z/)
          raise "Invalid sitemap type #{value[:type].inspect}"
        end
        unless value[:url].match(/\A#{URL_REGEX}\Z/)
          raise "Invalid sitemap url #{value[:url].inspect}"
        end
        '"(' + value.values_at(:id, :status, :url, :type).join(',') + ')"'
      end.join(',') +
      '}'
  end
end
