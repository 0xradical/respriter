class RootTag

  include ActiveSupport::Inflector
  include ActiveModel::Model

  attr_reader :id, :name, :icon, :act_as_category

  def initialize(locale, id:, icon:)
    @locale, @id, @icon = locale, id, icon
    @name = I18n.t("tags.#{@id}", locale: @locale)
  end

  def slugify
    @id.gsub('_','-')
  end

  def self.all(locale=I18n.locale)
    YAML::load_file(Rails.root.join('config','root_tags.yml')).map do |c|
      self.new(locale, id: c['id'], icon: c['icon'])
    end
  end

end
