class LandingPageTemplate

  include ActiveModel::Model

  attr_accessor :id, :layout

  def initialize(template)
    @id     = File.basename(template, '.html.erb')
    @layout = set_layout(template)
  end

  def render
    ERB.new(@layout).result(binding)
  end

  private

  def set_layout(template)
    @layout = File.read(template_path(template))
  end

  def template_path(template)
    Rails.root.join('app','views','layouts','landing_pages',template)
  end

end
