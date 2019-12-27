require 'strscan'

module SitemapsSerializer
  ID_REGEX      = /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
  STATUS_REGEX  = /(confirmed|invalid|unconfirmed)/
  URL_REGEX     = /https?\:\/\/\w+(\.\w+)+\/([\.\w]*\/?)*/
  SITEMAP_REGEX = /\,?\"\((?<id>#{ID_REGEX}),(?<status>#{STATUS_REGEX}),(?<url>#{URL_REGEX})\)\"/

  KEYS = [:id, :status, :url]
  def self.load(value)
    return nil if value.nil?
    return []  if value == '{}'
    values = []
    scanner = StringScanner.new value[1..-2]
    until scanner.eos?
      values << KEYS.zip(
        scanner
          .scan(SITEMAP_REGEX)
          .match(SITEMAP_REGEX)
          .values_at(*KEYS)
      ).to_h
    end
    values
  end

  def self.dump(values)
    return nil if values.nil?

    "{" + 
    values.map do |value|
      raise 'Invalid sitemap id'     unless value[ :id     ].match(  /\A#{ID_REGEX}\Z/    )
      raise 'Invalid sitemap status' unless value[ :status ].match( /\A#{STATUS_REGEX}\Z/ )
      raise 'Invalid sitemap regex'  unless value[ :url    ].match( /\A#{URL_REGEX}\Z/    )
      '"(' + value.values_at(:id, :status, :url).join(',') + ')"'
    end.join(',') +
    "}"
  end
end
