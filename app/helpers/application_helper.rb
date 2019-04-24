module ApplicationHelper

  def alert_alias(name)
    alert_map = { notice: 'blue', info: 'blue', alert: 'magenta', danger: 'magenta', warning: 'yellow', success: 'green' }
    alert_map[name.to_sym]
  end

  def omniauth_button(provider:, label:)
    link_to(label, send("user_account_#{provider.to_s}_omniauth_authorize_path"))
  end

  # Important: SVG use has a very strong CORS restriction (it does not serve SVG from
  # other domains). That is the reason host: '//´ is being used to bypass the CDN
  def svg_lib(svg_path, svg_options={})
    tag.svg(svg_options) do
      tag.use 'xlink:href': svg_path
    end
  end

  def svg_icons_lib(icon_name, svg_options={})
    svg_lib("#{asset_pack_url('icons-lib.svg', host: '//')}##{icon_name}", svg_options)
  end

  def svg_providers_lib(provider_name, svg_options={})
    svg_lib("#{asset_pack_url('providers-lib.svg', host: '//')}##{provider_name}", svg_options)
  end
end
