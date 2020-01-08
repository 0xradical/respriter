class Integration::Napoleon::CrawlerBuilder
  include HTTParty

  attr_reader :service, :version, :pipeline_templates, :pipeline_executions

  delegate :provider_crawler, to: :service
  delegate :provider,         to: :provider_crawler

  base_uri ENV.fetch('NAPOLEON_POSTGREST_HOST')
  NAPOLEON_JWT = ENV.fetch 'NAPOLEON_POSTGREST_JWT'

  def initialize(service, version)
    @service, @version = service, version
    @pipeline_templates  = []
    @pipeline_executions = []
  end

  def add_pipeline_template(params)
    response = self.class.post '/pipeline_templates', options_for_add_request.merge(body: params.to_json)
    raise 'Invalid Response' if response.code != 201
    template = response.parsed_response.first.deep_symbolize_keys
    @pipeline_templates << template
    template
  end

  def add_pipeline_execution(params)
    response = self.class.post '/pipeline_executions', options_for_add_request.merge(body: params.to_json)
    raise 'Invalid Response' if response.code != 201
    execution = response.parsed_response.first.deep_symbolize_keys
    @pipeline_executions << execution
    execution
  end

  def delete_pipeline_templates(id)
    response = self.class.delete '/pipeline_templates', options_for_delete_request(id)
    raise 'Invalid Response' if response.code != 204
  end

  def delete_pipeline_executions(id)
    response = self.class.delete '/pipeline_executions', options_for_delete_request(id)
    raise 'Invalid Response' if response.code != 204
  end

  def options_for_add_request
    {
      headers: {
        'Prefer'        => 'return=representation',
        'Authorization' => "Bearer #{NAPOLEON_JWT}",
        'Accept'        => 'application/json',
        'Content-Type'  => 'application/json'
      }
    }
  end

  def options_for_delete_request(id)
    {
      query: {
        id: "eq.#{id}"
      },
      headers: {
        'Authorization' => "Bearer #{NAPOLEON_JWT}",
        'Content-Type'  => 'application/json'
      }
    }
  end

  def build_template_by_folder(dir)
    params      = Hash.new
    pipeline_path = relative_path dir, 'pipeline.yml'
    if File.file?(pipeline_path)
      params = YAML.load_file pipeline_path
    end
    params.deep_symbolize_keys!

    params[:pipes].each do |pipe|
      if pipe.has_key?(:script)
        pipe[:script] = script_by_extension dir, pipe[:script]
      end
    end

    params.merge! parse_callback_script( :bootstrap, dir )
    params.merge! parse_callback_script( :success,   dir )
    params.merge! parse_callback_script( :fail,      dir )
    params.merge! parse_callback_script( :waiting,   dir )

    params
  end

  def parse_callback_script(name, dir)
    scripts = [
      File.file?(relative_path(dir, "#{name}.rb")),
      File.file?(relative_path(dir, "#{name}.sql"))
    ]

    case scripts
    when [true, true]
      raise "More than one #{name} callback per pipeline is not allowed"
    when [true, false]
      {
        :"#{name}_script_type" => 'ruby',
        :"#{name}_script"      => ruby_source_code(dir, "#{name}.rb")
      }
    when [false, true]
      {
        :"#{name}_script_type" => 'sql',
        :"#{name}_script"      => sql_source_code(dir, "#{name}.sql")
      }
    when [false, false]
      Hash.new
    end
  end

  def script_by_extension(dir, path)
    case File.extname(path)
    when '.rb'
      {
        type:        'ruby',
        source_code: ruby_source_code(dir, path)
      }
    when '.sql'
      {
        type:        'sql',
        source_code: sql_source_code(dir, path)
      }
    else
      raise "Invalid script file #{path}"
    end
  end

  def ruby_source_code(*paths)
    source = File.read relative_path(*paths)
    Unparser.parse source # Should raise an exception if source has invalid syntax
    source
  end

  def sql_source_code(*paths)
    source = File.read relative_path(*paths)
    PgQuery.parse source # Should raise an exception if source has invalid syntax
    source
  end

  def relative_path(*paths)
    File.join File.dirname(__FILE__), @version.to_s, *paths
  end
end
