module Integration::Napoleon
  class SchemaValidator
    attr_reader :kind, :version

    AUTHORIZATION_HEADER = "Bearer #{ENV.fetch 'NAPOLEON_POSTGREST_JWT'}"

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
        ValidatorHandler.new( schemer.validate(cloned_data) ).errors
      ]
    end

    protected
    def schema_uri
      URI.join ENV.fetch('NAPOLEON_POSTGREST_URI'), "/resource_schemas?kind=eq.#{kind}&schema_version=eq.#{version}"
    end

    def fetch_schema
      Net::HTTP.start(schema_uri.host, schema_uri.port) do |http|
        request = Net::HTTP::Get.new schema_uri
        request['Authorization'] = AUTHORIZATION_HEADER

        response = http.request request
        raise 'Could not get schema' if response.code != '200'

        results = JSON.parse(response.body)
        raise "Could not find schema for #{kind}:#{version}" if results.empty?

        results[0]['specification']
      end
    end
  end
end
