module ApplicationHelper

  def alert_alias(name, tone = 2)
    alert_map = { notice: 'blue', info: 'blue', alert: 'red', danger: 'red', warning: 'yellow', success: 'green' }
    "#{alert_map[name.to_sym]}#{tone}"
  end

  def omniauth_button(provider:, label:)
    link_to(label, send("user_account_#{provider.to_s}_omniauth_authorize_path"))
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
    !(%w(home static_pages posts contact_us).include?(controller_name) || devise_controller?)
  end

  def atomic_css
    %w(home).include?(controller_name) ? 'atomic.full' : 'atomic.slim'
  end

end
