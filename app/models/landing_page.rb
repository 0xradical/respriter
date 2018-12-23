class LandingPage < ApplicationRecord

  def slots
    OpenStruct.new(Hash[html.map { |k,v| [k, v.html_safe] }])
  end

  def exec_context_script(env)
    data['script'].each do |directive|
      context = directive['context']['resource'].camelize.constantize
      result = directive['context']['methods'].inject(context) do |obj,m| 
        obj.send(m['name'], *m['args'])
      end
      env.instance_variable_set(directive['expose'].to_sym, result)
    end
  end

end
