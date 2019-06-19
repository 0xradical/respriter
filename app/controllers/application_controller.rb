class ApplicationController < ActionController::Base

  http_basic_authenticate_with(name: ENV['BASIC_AUTH_USER'], password: ENV['BASIC_AUTH_PASSWORD']) if ENV['BASIC_AUTH_REQUIRED']

  protect_from_forgery with: :exception
  prepend_before_action :track_session
  before_action :set_locale
  before_action :rendertron?
  before_action :set_sentry_raven_context

  layout :fetch_layout

  protected

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end

  private

  def set_locale
    parsed_locale = I18nHelper.sanitize_locale(request.subdomains.first)
    I18n.locale = ([parsed_locale] & I18n.available_locales).present? ? parsed_locale : :en
  end

  def session_tracker
    @session_tracker ||= SessionTracker.track self
  end
  alias :track_session :session_tracker

  def rendertron?
    request.headers['HTTP_X_RENDERTRON_USER_AGENT'] == 'true'
  end
  helper_method :rendertron?

  def fetch_layout
    devise_controller? ? 'devise' : 'application'
  end

  def set_sentry_raven_context
    Raven.user_context(id: @session_tracker&.session_payload&.send(:[], 'id'))
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

end
