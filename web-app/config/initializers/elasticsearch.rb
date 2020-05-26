Elasticsearch::Model.client = Elasticsearch::Client.new host: ENV.fetch('ELASTICSEARCH_URL', 'localhost'), log: Rails.env.development?
