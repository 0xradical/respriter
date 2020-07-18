module ApplicationHelper

  def current_url_without_query_params
    request.base_url + request.path
  end

  def alert_alias(name)
    alert_map = {
      notice: 'primary',
      info: 'primary',
      alert: 'error',
      danger: 'error',
      warning: 'secondary',
      success: 'secondary-variant'
    }
    alert_map[name.to_sym]
  end

  # DEPRECATED
  def country_flag(locale, svg_options={})
    flags = {
      'en'    => 'us',
      'en-US' => 'us',
      'pt-BR' => 'br',
      'es'    => 'es',
      'de'    => 'de',
      'fr'    => 'fr',
      'ja'    => 'jp'
    }
    svg_use('country-flags', flags[locale.to_s], svg_options)
  end

  def omniauth_button(provider:, label:)
    link_to(
      label,
      send("user_account_#{provider.to_s}_omniauth_authorize_path")
    )
  end

  def svg_use(sprite_name, vector_name, svg_options = {})
    tag.svg(svg_options) do
      tag.use 'xlink:href': "##{sprite_name}-#{vector_name}"
    end
  end

  def home_controller?
    controller_name.eql?('home')
  end

  def sticky_navbar?
    !(
      %w[home static_pages posts contact_us].include?(controller_name) ||
        devise_controller?
    )
  end

  def link_to_locale(locale, opts={}, &block)
    en = (locale.to_s == 'en')
    link_to(
      (
        root_url(
          subdomain:
            (
              if en
                params[:subdomain]
              else
                [locale, params[:subdomain]].join('.').chomp('.')
              end
            )
        )
          .chomp('/') +
          request.path +
          (en ? '?intl=true' : '')
      ),
      opts,
      &block
    )
  end
end
