class HypernovaBatchBuilder
  def initialize(service)
    @batch = Hypernova::Batch.new(service)
    @token_uuid_map = {}
  end

  def render_vue_component(name, **props)
    uuid = SecureRandom.uuid
    token = @batch.render(name: name, data: props)
    @token_uuid_map[token] = uuid
    uuid
  end

  def replace(str)
    result = @batch.submit!
    result.reduce(str) do |s, (token, v)|
      uuid = @token_uuid_map[token]
      s.sub(uuid, v)
    end.html_safe
  end
end
