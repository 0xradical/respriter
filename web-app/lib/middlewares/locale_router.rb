class LocaleRouter

  def initialize(app)
    @app = app
  end

  def call(env)
    @status, @headers, @body = @app.call(env)
    @path, @query_string, @env = env['REQUEST_PATH'], env['QUERY_STRING'], env
    @request = Rack::Request.new(env)
    @cookies = Rack::Utils.parse_cookies(env)
    return forward_to(user_locale) if user_selected_different_locale?
    return forward_to(auto_assigned_locale) if first_access_on_apex_domain?
    @app.call(env)
  end

  private

  def domain
    Domain.new(@env['HTTP_HOST'])
  end

  def apex_domain?
    domain.locale.eql?(:en)
  end

  def first_access_on_apex_domain?
    apex_domain? &&
    @cookies['isredir'].blank? &&
    auto_assigned_locale != :en && 
    !is_a_non_localized_route?
  end

  def user_selected_different_locale?
    user_locale.present? && user_locale != domain.locale
  end

  def forward_to(locale)
    @headers.merge!({
      "Set-Cookie"    => "isredir=true; Domain=.#{domain.apex}; Expires=#{(Time.now + 1.year).utc}",
      "Location"      => redirection_url(locale), 
      "Cache-Control" => "no-cache"
    })
    [301, @headers, @body]
  end

  def redirection_url(locale)
    ("//" + domain.route_for(locale) + @path + '?' + @query_string).chomp('?')
  end

  def user_locale
    @request.params['locale']&.to_sym
  end

  def auto_assigned_locale
    (browser_locales & I18n.available_locales).first || :en
  end

  def browser_locales
    HttpAcceptLanguageHandler.new(@env['HTTP_ACCEPT_LANGUAGE']).locales.map(&:to_sym)
  end

  def is_a_non_localized_route?
    @path =~ /^\/(?:admin_accounts\/sign_in|\/api\/)/
  end

end
