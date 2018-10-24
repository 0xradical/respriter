module ApplicationHelper

  WEB_COMPONENT_ASSET = "/web-components/%{name}%{version}.%{extname}"

  def omniauth_button(provider: provider, label: label)
    link_to(label, send("user_account_#{provider.to_s}_omniauth_authorize_path"))
  end

  def web_component_path(path)
    path =~ /([^\/]*)\.(js|css|json|gif|png|jpe?g|svg)$/
    asset = WEB_COMPONENT_ASSET % { name: $1, version: ENV['WEB_COMPONENTS_VERSION'], extname: $2 }
    if !Rails.env.production?
      asset_path(asset, host: ENV['WEB_COMPONENTS_HOST']) 
    else
      asset_path(asset)
    end
  end

end
