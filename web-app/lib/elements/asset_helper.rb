# frozen_string_literal: true

module Elements
  module AssetHelper
    include ActionView::Helpers::AssetTagHelper

    def elements_javascript_include_tag(*sources)
      options = sources.extract_options!
      version = get_version(options.extract!(:version))
      sources.map { |source| source.prepend("/#{version}/").squeeze('/') }
      javascript_include_tag(*sources, { host: Elements.asset_host }.merge(options))
    end

    def elements_stylesheet_link_tag(*sources)
      options = sources.extract_options!
      version = get_version(options.extract!(:version))
      sources.map { |source| source.prepend("/#{version}/").squeeze('/') }
      stylesheet_link_tag(*sources, { host: Elements.asset_host }.merge(options))
    end

    def elements_asset_path(source, options = {})
      source = source.delete_prefix('/')
      version = get_version(options.extract!(:version))
      source.prepend("#{Elements.asset_host}/#{version}/")
      asset_path(source, options)
    end

    private

    def get_version(opts)
      opts[:version].blank? ? Elements.asset_version : opts[:version]
    end
  end
end
