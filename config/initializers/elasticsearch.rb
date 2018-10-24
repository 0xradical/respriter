Elasticsearch::Model.client = Elasticsearch::Client.new host: ENV['ELASTICSEARCH_URL'], log: Rails.env.development?

