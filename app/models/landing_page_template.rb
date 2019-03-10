class LandingPageTemplate

  VAR_REGEX=/<%= slots\.([a-z0-9_]*).* %>/

  include ActiveModel::Model

  attr_accessor :id, :data, :layout

  def initialize(template)
    @id     = File.basename(template, '.html.erb')
    @layout = set_layout(template)
    @data   = set_placeholders
  end

  def fill_slots(slots)
    ERB.new(@layout).result(slots.instance_eval { binding })
  end

  private

  def set_layout(template)
    @layout = File.read(template_path(template))
  end

  def set_placeholders
    @data = Hash[@layout.scan(VAR_REGEX).flatten.map do |captured_group|
      [captured_group.strip, '']
    end]
  end

  def template_path(template)
    Rails.root.join('app','views','layouts','landing_pages',template)
  end

end
