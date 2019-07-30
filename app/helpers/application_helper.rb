module ApplicationHelper

  def alert_alias(name, tone = 2)
    alert_map = { notice: 'blue', info: 'blue', alert: 'red', danger: 'red', warning: 'yellow', success: 'green' }
    "#{alert_map[name.to_sym]}#{tone}"
  end

  def omniauth_button(provider:, label:)
    link_to(label, send("user_account_#{provider.to_s}_omniauth_authorize_path"))
  end

  def default_meta_alternate_hreflang(current_locale=I18n.locale, host='classpert.com')
    I18nHost.new(host).reject { |k,v| k == current_locale.to_s.downcase }.map do |locale, subdomain|
      tag.link(rel: 'alternate', hreflang: locale, href: "https://#{subdomain}#{request.path}")
    end.join.html_safe
  end

  def svg_use(sprite_name, vector_name, svg_options={})
    tag.svg(svg_options) do
      tag.use 'xlink:href': "##{sprite_name}-#{vector_name}"
    end
  end

  def viewport_content
    controller_name.eql?('posts') ? 'width=device-width user-scalable=yes' : 'width=device-width user-scalable=no'
  end

  def home_controller?
    controller_name.eql?('home')
  end

  def sticky_navbar?
    !(%w(home static_pages posts).include?(controller_name) || devise_controller?)
  end

end
