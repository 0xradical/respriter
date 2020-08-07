module HypernovaHelper
  def render_component(name, data, run_context: self)
    run_context.send(:render_vue_component, name, { locale: I18n.locale }.merge(data.present? ? {propsData: data} : {}))
  end
end
