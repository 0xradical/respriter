module HypernovaHelper
  def render_component(name, data)
    render_vue_component(name, {
      locale: I18n
    }.merge(
      data.present? ? { propsData: data } : {}
    ))
  end
end