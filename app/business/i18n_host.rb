class I18nHost

  include Enumerable

  attr_reader :tld, :members

  def initialize(host)
    @tld      = extract_tld(host)
    @members  = map_locales_to_subdomains
  end

  def each(&block)
    members.each do |item|
      block.call(item)
    end
  end

  private

  def map_locales_to_subdomains
    Hash[I18n.available_locales.map do |locale|
      locale.eql?(:en) ? [locale.downcase.to_s, tld] : [locale.downcase.to_s, [locale.downcase,tld].join('.').chomp('.')]
    end]
  end

  def extract_tld(host)
    ActionDispatch::Http::URL.extract_domain(host,1)
  end

end
