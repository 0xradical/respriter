class TranslationsController < ApplicationController
  def index
    @translations = fetch_translations params[:locale], params[:keys]
    render json: @translations
  end

  protected
  def fetch_translations(locale = :en, keys = nil)
    scope = Lit::Localization.joins :locale, :localization_key

    if keys.present?
      dotted_keys = keys.gsub '/', '.'

      scope = scope.where(
        'lit_locales.locale = ? AND (lit_localization_keys.localization_key ILIKE ? OR lit_localization_keys.localization_key = ?)',
        locale,
        "#{dotted_keys}.%",
        dotted_keys
      )
    else
      scope = scope.where 'lit_locales.locale = ?', locale
    end

    scope.pluck('
      lit_localization_keys.localization_key,
      COALESCE(translated_value, default_value)
    ').inject(Hash.new) do |hash, key_value|
      dotted_key, value = key_value

      *keys, last_key = dotted_key.split('.')
      last_hash = keys.inject(hash) do |h, key|
        h[key] ||= Hash.new
      end

      last_hash[last_key] = value && YAML.load(value)

      hash
    end
  end
end
