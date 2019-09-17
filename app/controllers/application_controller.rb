require 'hypernova'

class ApplicationController < ActionController::Base

  http_basic_authenticate_with(name: ENV['BASIC_AUTH_USER'], password: ENV['BASIC_AUTH_PASSWORD']) if ENV['BASIC_AUTH_REQUIRED']

  protect_from_forgery with: :exception
  prepend_before_action :track_session
  before_action :set_locale
  before_action :rendertron?
  before_action :set_sentry_raven_context if Rails.env.production?
  before_action :store_user_account_location, if: :devise_controller?
  around_action :hypernova_render_support
  layout :fetch_layout

  unless Rails.application.config.consider_all_requests_local
    rescue_from ActionController::UnknownFormat,  with: :render_406
    rescue_from ActionController::RoutingError,   with: :render_404
  end

  protected

  def store_user_account_location
    # for omniauth
    omniauth_params = request.env["omniauth.params"]
    if omniauth_params && omniauth_params['redirect_to'].present?
      store_location_for(:user_account, omniauth_params['redirect_to'])
    end

    # for simple signin
    if params['redirect_to'].present?
      store_location_for(:user_account, params['redirect_to'])
    end
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || request.env['omniauth.origin'] || user_logged_default_path
  end

  private
  def user_logged_default_path
    redirect_params = {
      locale: I18n.locale,
      token: SessionToken.new(request.env['warden-jwt_auth.token'], request_ip).encrypt
    }
    "#{ ENV.fetch 'USER_DASHBOARD_URL' }?#{ redirect_params.to_query }"
  end

  def request_ip
    ((request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip).to_s).scan(/(.*),|\A(.*)\z/).flatten.compact.first
  end

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

  if Rails.env.production?
    def set_sentry_raven_context
      Raven.user_context(id: @session_tracker&.session_payload&.send(:[], 'id'))
      Raven.extra_context(params: params.to_unsafe_h, url: request.url)
    end
  end

  def render_404(exception)
    render file: Rails.root.join('public', '404.html'),  status: 404, layout: false
  end

  def render_406(exception)
    render plain: "406 - not acceptable", status: 406
  end

end
