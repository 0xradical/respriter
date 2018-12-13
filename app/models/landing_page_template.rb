class LandingPageTemplate

  VAR_REGEX=/<%= html\.([a-z_]*) %>/

  include ActiveModel::Model

  attr_accessor :id, :data, :layout

  def initialize(layout_name, context={})
    @id     = layout_name
    @layout = set_layout(layout_name, context)
    @data   = set_data
  end

  class << self

    def renderer(context={})
      renderer = ApplicationController.renderer.new
      renderer.instance_variable_set(:@env, context)
      renderer
    end

  end

  private

  def template_path(layout_name)
    "layouts/landing_pages/#{layout_name}"
  end

  def set_layout(layout_name, context={})
    self.class.renderer(context).render(template_path(layout_name), layout: false)
  end

  def set_data
    @data = Hash[@layout.scan(VAR_REGEX).flatten.map do |captured_group|
      [captured_group.strip, '']
    end]
  end

end
