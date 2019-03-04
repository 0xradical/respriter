module ApplicationHelper

  def alert_alias(name)
    alert_map = { notice: 'blue', info: 'blue', alert: 'magenta', danger: 'magenta', warning: 'yellow', success: 'green' }
    alert_map[name.to_sym]
  end

  def omniauth_button(provider: provider, label: label)
    link_to(label, send("user_account_#{provider.to_s}_omniauth_authorize_path"))
  end

  def svg_lib(svg_path, svg_options={})
    tag.svg(svg_options) do
      tag.use 'xlink:href': svg_path
    end
  end

  def svg_icons_lib(icon_name, svg_options={})
    svg_lib("#{asset_pack_path('icons-lib.svg')}##{icon_name}", svg_options)
  end

  def svg_providers_lib(provider_name, svg_options={})
    svg_lib("#{asset_pack_path('providers-lib.svg')}##{icon_name}", svg_options)
  end

end
