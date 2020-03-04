module Napoleon
  class CrawlingEventProcessor::CourseSummary < CrawlingEventProcessor
    def process
      info "Course Import Summary: #{added_count} #{'course'.pluralize added_count} added, #{updated_count} #{'course'.pluralize updated_count} updated and #{removed_count} #{'course'.pluralize removed_count} removed."
    end

    protected
    def added_count
      crawling_event.data['added_count']
    end

    def updated_count
      crawling_event.data['updated_count']
    end

    def removed_count
      crawling_event.data['removed_count']
    end
  end
end
