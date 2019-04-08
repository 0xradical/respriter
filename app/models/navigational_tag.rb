class NavigationalTag

  include ActiveSupport::Inflector
  include ActiveModel::Model

  attr_reader :id, :name, :icon, :act_as_category

  def initialize(locale, id:, icon:, act_as_category:)
    @locale, @id, @icon, @act_as_category = locale, id, icon, act_as_category
    @name = I18n.t("tags.#{@id}", locale: @locale)
  end

  def slugify
    @id.gsub('_','-')
  end

  def self.all(locale=I18n.locale)
    YAML::load_file(Rails.root.join('config','navigational_tags.yml')).map do |c|
      self.new(locale, id: c['id'], icon: c['icon'], act_as_category: c['act_as_category'])
    end
  end

end
