class ElasticSearchIndexJob < ActiveJob::Base

  queue_as :elasticsearch

  def perform(klass, ids)
    klass.to_s.camelize.constantize.__elasticsearch__.import query: -> { where(id: ids, published: true) }
  end

end
