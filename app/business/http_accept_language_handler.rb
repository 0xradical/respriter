class HttpAcceptLanguageHandler

  attr_reader :raw

  def initialize(raw_str)
    @raw = raw_str
  end

  def locales
    return ['en'] if @raw.nil?
    HTTP::Accept::Languages.parse(@raw).map(&:locale) - ['*']
    rescue HTTP::Accept::ParseError => e
      Rails.logger.error "#{e.class} - #{e.message} (args: #{@raw})".ansi(:red)
      return ['en']
  end

end
