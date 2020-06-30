# frozen_string_literal: true

module RespriterHelper
  def respriter_url
    ENV['RESPRITER_URL'].presence
  end

  def respriter?
    respriter_url.present?
  end

  def sprites(params = {}, options = {})
    version = get_version(options.extract!(:version))

    if respriter?
      sprite_uri = URI.join(
        URI(respriter_url),
        version
      ).tap do |uri|
        uri.query = params.flat_map { |k, v| "#{k}=#{Array.wrap(v).join(',')}" }.join('&')
      end
      content_tag(:div, nil, "data-svg-sprite": sprite_uri.to_s)
    else
      params.keys.map do |key|
        content_tag(:div, nil, "data-svg-sprite": elements_asset_path("svgs/sprites/#{key}.svg"))
      end.reduce(&:+)
    end
  end

  private

  def get_version(opts)
    opts[:version].blank? ? Elements.asset_version : opts[:version]
  end
end
