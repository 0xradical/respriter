module Napoleon
  class CrawlingEventResource
    attr_reader :payload, :provider

    def initialize(payload)
      @payload = payload
    end

    def to_crawling_event
      {
        id:                  payload['resource_id'],
        execution_id:        payload['last_execution_id'],
        provider_crawler_id: payload['content']['provider_crawler_id'],
        created_at:          payload['created_at'],
        updated_at:          payload['updated_at'],
        sequence:            payload['dataset_sequence'],
        type:                payload['content']['type'],
        data:                payload['content']['data']
      }
    end
  end
end
