class ApplicationController < ActionController::Base

  http_basic_authentication_with(name: ENV['BASIC_AUTH_USER'], password: ENV['BASIC_AUTH_PASSWORD']) if ENV['BASIC_AUTH_REQUIRED']

  protect_from_forgery with: :exception
  prepend_before_action :parse_browser_session
  before_action :set_locale
  layout :fetch_layout

  protected

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end

  private

  def default_url_options
    { locale: I18n.locale }
  end

  def set_locale
    locales = [params[:locale], @browser_languages].flatten.compact.map(&:to_sym)
    available_locales = I18n.available_locales.map { |l| [l, l.to_s.split('-')[0].to_sym] }.flatten.uniq
    I18n.locale = (locales & available_locales).first
  end

  def parse_browser_session
    browser_session = BrowserSessionParser.new(request).call
    @browser_languages = browser_session[:preferred_languages]
    session[:tracking_data] ||= browser_session
  end

  def fetch_layout
    devise_controller? ? "devise" : "application"
  end

end
