class LocaleRouter

  def initialize(app)
    @app = app
  end

  def call(env)

    @path, @env = env['REQUEST_PATH'], env
    @subdomains, @tld_domain = extract_subdomains, extract_tld_domain
    @request = Rack::Request.new(env)

    env['rack.session']['intl'] ||= @request.params['intl']
    if (intl_subdomain? && !whitelisted_routes)
      if (supported_locale.present? && !env['rack.session']['intl'])
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
    "//#{[supported_locale&.downcase, @subdomains, @tld_domain].flatten.join('.')}#{@path}"
  end

  def supported_locale
    (browser_language & i18n_subdomains).first
  end

  def browser_language
    return :en if @env['HTTP_ACCEPT_LANGUAGE'].nil?
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
    I18n.available_locales.reject { |l| l == :en }
  end

end
