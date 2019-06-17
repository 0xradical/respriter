class LocaleRouter

  def initialize(app)
    @app = app
  end

  def call(env)

    @path, @env = env['REQUEST_PATH'], env
    @subdomains, @tld_domain = extract_subdomains, extract_tld_domain
    @request = Rack::Request.new(env)

    env['rack.session']['intl'] ||= @request.params['intl']
    if (intl_subdomain? && !whitelisted_routes && preferred_locale != :en)
      if (preferred_locale.present? && !env['rack.session']['intl'])
        return [301, { "Location" => redirection_url, "Cache-Control" => "no-cache"}, {}]
      end
    end

    @app.call(env)

  end

  def extract_tld_domain
    ActionDispatch::Http::URL.extract_domain(@env['HTTP_HOST'],1)
  end

  def extract_subdomains
    ActionDispatch::Http::URL.extract_subdomains(@env['HTTP_HOST'],1)
  end

  def redirection_url
    "//#{[i18n_subdomains[preferred_locale], @subdomains, @tld_domain].compact.flatten.join('.')}#{@path}"
  end

  def preferred_locale
    (browser_language & I18n.available_locales).first
  end

  def browser_language
    return [:en] if @env['HTTP_ACCEPT_LANGUAGE'].nil?
    http_accept_language_parser = HTTP::Accept::Languages.parse(@env['HTTP_ACCEPT_LANGUAGE'])
    http_accept_language_parser&.map { |l| l&.locale.to_sym }
  end

  def intl_subdomain?
    subdomain = @subdomains&.first&.downcase
    subdomain.blank? || subdomain.eql?('www') || subdomain.eql?('staging')
  end

  def whitelisted_routes
    @path =~ /^\/api\/admin\// || @path =~ /^\/admin_accounts\/sign_in/
  end

  def i18n_subdomains
    locale_subdomain_map = Hash[I18n.available_locales.map { |k| [k, k.to_s] }]
    locale_subdomain_map[:en] = nil
    locale_subdomain_map
  end

end
