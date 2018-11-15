class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  prepend_before_action :set_locale
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
    pref_locale = current_user_account&.profile&.preferences&.send(:[], 'locale')
    I18n.locale = pref_locale || params[:locale] || load_locale_preferences_from_accept_language_header!
    rescue I18n::InvalidLocale, HttpAcceptLanguageParser::MissingHttpAcceptLanguageHeader
      I18n.locale = I18n.default_locale
  end

  def load_locale_preferences_from_accept_language_header!
    pref_langs = HttpAcceptLanguageParser.parse(request.env['HTTP_ACCEPT_LANGUAGE'])
    pref_langs.each do |lang|
      return lang if I18n.available_locales.include?(lang.to_sym)
    end
  end

  def fetch_layout
    if devise_controller?
      "devise"
    else
      "application"
    end
  end

end
