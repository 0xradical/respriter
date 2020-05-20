module Elements
  module AssetHelper

    include ActionView::Helpers::AssetTagHelper

    def elements_javascript_include_tag(*sources)
      sources.extract_options!
      sources.map { |source| source.prepend("/#{Elements.asset_version}/").squeeze('/') }
      javascript_include_tag(*sources, host: Elements.asset_host, skip_pipeline: true)
    end

    def elements_stylesheet_link_tag(*sources)
      sources.extract_options!
      sources.map { |source| source.prepend("/#{Elements.asset_version}/").squeeze('/') }
      stylesheet_link_tag(*sources, host: Elements.asset_host, skip_pipeline: true)
    end

    def elements_asset_path(source, options={})
      source.delete_prefix!('/')
      source.prepend("#{Elements.asset_host}/#{Elements.asset_version}/")
      asset_path(source, options)
    end

  end
end
