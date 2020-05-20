module Support
  module Elasticsearch
    def wait_for_indexing
      ::Elasticsearch::Model.client.indices.refresh
    end
  end
end
