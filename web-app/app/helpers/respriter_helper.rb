# frozen_string_literal: true

module RespriterHelper
  def respriter_url
    ENV['RESPRITER_URL'].presence
  end

  def respriter?
    respriter_url.present?
  end

  def sprites(params = {}, options = {})
    host, version = get_options(options.extract!(:host, :version))

    if respriter?
      sprite_uri = URI.join(
        URI(respriter_url),
        version
      ).tap do |uri|
        uri.query = params.flat_map { |k, v| "#{k}=#{Array.wrap(v).uniq.join(',')}" }.join('&')
      end
      content_tag(:div, nil, "data-svg-sprite": sprite_uri.to_s)
    else
      params.keys.map do |key|
        content_tag(:div, nil, "data-svg-sprite": elements_asset_path("svgs/sprites/#{key}.svg", host: host, version: version))
      end.reduce(&:+)
    end
  end

  private

  def get_options(opts)
    [
      opts[:host]     || controller.try(:page_version).try(:[], :elements).try(:[], :host)     || Elements.asset_host,
      opts[:version]  || controller.try(:page_version).try(:[], :elements).try(:[], :version)  || Elements.asset_version
    ]
  end
end
