class ApplicationController < ActionController::Base

  http_basic_authenticate_with(name: ENV['BASIC_AUTH_USER'], password: ENV['BASIC_AUTH_PASSWORD']) if ENV['BASIC_AUTH_REQUIRED']

  protect_from_forgery with: :exception
  prepend_before_action :parse_browser_session
  before_action :set_locale

  layout :fetch_layout

  protected

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end

  private

  def set_locale
    parsed_locale = I18nHelper.strict_locale(request.subdomains.first)
    I18n.locale = ([parsed_locale] & I18n.available_locales).present? ? parsed_locale : :en
  end

  def parse_browser_session
    @browser_session = BrowserSessionParser.new(request).call
    session[:tracking_data] ||= @browser_session
  end

  def fetch_layout
    devise_controller? ? "devise" : "application"
  end

end
