class LabelPrinter

  include Rails.application.routes.url_helpers

  def initialize(locale=I18n.locale)
    @locale = locale
  end

  def labels
    YAML::load_file(Rails.root.join('config', 'categories.yml')).map do |category|
      slug = category['id'].gsub('_','-')
      {
        id: category['id'],
        path: courses_path(slug, locale: @locale),
        slug: slug,
        text: I18n.t("categories.#{category['id']}"),
        icon: category['icon']
      }
    end
  end

end
