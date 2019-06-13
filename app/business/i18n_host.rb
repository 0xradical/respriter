class I18nHost

  attr_reader :tld

  def initialize(host)
    set_tld(host)
  end

  def each
    Hash[I18n.available_locales.map do |locale|
      item = locale.eql?(:en) ? [locale.downcase.to_s, tld] : [locale.downcase.to_s, [locale.downcase,tld].join('.').chomp('.')]
      yield item if block_given?
      item
    end]
  end

  private

  def set_tld(host)
    @tld = ActionDispatch::Http::URL.extract_domain(host,1)
  end

end
