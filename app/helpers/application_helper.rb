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

  def home_controller?
    params[:controller].eql?('home')
  end

  def borderless_navbar?
    %w(home posts).include?(params[:controller] || devise_controller?)
  end

  def sticky_navbar?
    !(%w(home static_pages posts).include?(params[:controller]) || devise_controller?)
  end

end
