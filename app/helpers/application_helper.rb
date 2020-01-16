module ApplicationHelper
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

  def atomic_css
    %w[home].include?(controller_name) ? 'atomic.full' : 'atomic.slim'
  end

  def link_to_locale(locale, &block)
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
      &block
    )
  end
end
