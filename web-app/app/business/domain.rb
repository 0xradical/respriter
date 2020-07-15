class Domain

  attr_reader :apex, :subdomains

  LOCALIZED_SUBDOMAINS = Hash[(I18n.available_locales - [:en]).map { |l| [l,l.to_s.downcase]}]

  def initialize(host=ENV.fetch('HOST'))
    @host = host
    extract_domain
    extract_subdomains
  end

  def locale
    self.class.subdomain_to_locale(@subdomains.first.to_s)
  end

  def localized?
    LOCALIZED_SUBDOMAINS.values.include?(@subdomains.first.to_s)
  end

  def route_for(locale)
    localized_subdomain = self.class.locale_to_subdomain(locale.to_sym)
    subdomains = localized? ? @subdomains.drop(1) : @subdomains
    [[localized_subdomain], subdomains, @apex].compact.flatten.join('.').delete_prefix('.')
  end

  def extract_domain
    @apex = ActionDispatch::Http::URL.extract_domain(@host,1)
  end

  def extract_subdomains
    @subdomains = ActionDispatch::Http::URL.extract_subdomains(@host,1)
  end

  def self.locale_to_subdomain(locale)
    LOCALIZED_SUBDOMAINS[locale].to_s
  end

  def self.subdomain_to_locale(subdomain)
    LOCALIZED_SUBDOMAINS.invert[subdomain] || :en
  end

end
