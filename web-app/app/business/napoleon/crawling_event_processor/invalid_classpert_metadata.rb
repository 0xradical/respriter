module Napoleon
  class CrawlingEventProcessor::InvalidClasspertMetadata < CrawlingEventProcessor
    def process
      warn "#070006: Invalid Classpert Metadata Error. Got invalid metadata at #{url}"
    end

    protected
    def url
      crawling_event.data['url']
    end
  end
end
