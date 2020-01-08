module Integration::Napoleon
  class SchemaValidator
    attr_reader :kind, :version

    def initialize(kind, version)
      @kind, @version = kind, version
    end

    def schema
      @schema ||= fetch_schema
    end

    def schemer
      @schemer ||= JSONSchemer.schema schema, insert_property_defaults: true
    end

    def validate(data)
      cloned_data = data.deep_dup.deep_stringify_keys
      [
        cloned_data,
        schemer.validate(cloned_data)
      ]
    end

    protected
    def fetch_schema
      uri = URI.join ENV.fetch('NAPOLEON_POSTGREST_URI'), "/resource_schemas?kind=eq.#{kind}&schema_version=eq.#{version}"

      Net::HTTP.start(uri.host, uri.port) do |http|
        request = Net::HTTP::Get.new uri
        request['Authorization'] = "Bearer #{ENV.fetch 'NAPOLEON_POSTGREST_JWT'}"

        response = http.request request
        raise 'Could not get schema' if response.code != '200'

        results = JSON.parse(response.body)
        raise "Could not find schema for #{kind}:#{version}" if response.empty?

        results[0]['specification']
      end
    end
  end
end
