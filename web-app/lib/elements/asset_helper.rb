# frozen_string_literal: true

module Elements
  module AssetHelper
    include ActionView::Helpers::AssetTagHelper

    def elements_javascript_include_tag(*sources)
      options = sources.extract_options!
      host, version = get_options(options.extract!(:host, :version))
      sources.map { |source| source.prepend("/#{version}/").squeeze('/') }
      javascript_include_tag(*sources, { host: host }.merge(options))
    end

    def elements_stylesheet_link_tag(*sources)
      options = sources.extract_options!
      host, version = get_options(options.extract!(:host, :version))
      sources.map { |source| source.prepend("/#{version}/").squeeze('/') }
      stylesheet_link_tag(*sources, { host: host }.merge(options))
    end

    def elements_asset_path(source, options = {})
      source = source.delete_prefix('/')
      host, version = get_options(options.extract!(:host, :version))
      source.prepend("#{host}/#{version}/")
      asset_path(source, options)
    end

    private

    def get_options(opts)
      [
        (opts[:host]     || controller.page_version[:elements][:host]    || Elements.asset_host),
        (opts[:version]  || controller.page_version[:elements][:version] || Elements.asset_version)
      ]
    end

  end
end
