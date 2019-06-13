module ApplicationHelper

  def alert_alias(name)
    alert_map = { notice: 'blue', info: 'blue', alert: 'magenta', danger: 'magenta', warning: 'yellow', success: 'green' }
    alert_map[name.to_sym]
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

  def borderless_navbar?
    %w(home posts).include?(controller_name || devise_controller?)
  end

  def sticky_navbar?
    !(%w(home static_pages posts).include?(controller_name) || devise_controller?)
  end

end
