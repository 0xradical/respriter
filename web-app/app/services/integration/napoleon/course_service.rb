module Integration
  module Napoleon
    class CourseService
      STREAMER_PARAMS = {
        kind: 'course',
        locked_versions: [
          '0.0.0', '< 2.0.0'
        ],
        resource_class: ::Napoleon::CourseResource,
        fields: [
          'id',
          'resource_id',
          'last_execution_id',
          'sequence',
          'dataset_sequence',
          'content',
          'schema_version'
        ]
      }

      def initialize
        @language_idr = CourseLanguageIdentifier.new
        @bundle_tagger = CourseTagger.new
      end

      def run(dataset_sequence = nil)
        dataset_sequence = Course.current_dataset_sequence if dataset_sequence.blank? || dataset_sequence == 0
        ::Napoleon::ResourceStreamer.new(STREAMER_PARAMS).resources(dataset_sequence) do |resource|
          course = Course.upsert resource.to_course
          upsert_hooks course
        end
        update_index dataset_sequence
      end

      protected
      def upsert_hooks(course)
        @language_idr.identify!(course)
        course.add_robots_index_rule_from_language! if course.reload.locale_status == 'ok'
        course.set_canonical_subdomain_from_language!
        @bundle_tagger.tag!(course)
      end

      def update_index(dataset_sequence)
        if dataset_sequence < Course.current_dataset_sequence
          log :info, 'Indexing Recently Synced Courses'
          Course.remove_from_index_by_dataset_sequence dataset_sequence
          Course.index_by_dataset_sequence dataset_sequence
        else
          log :info, 'No New Synced Courses to index'
        end
      end

      def logger
        return @logger if @logger.present?

        logger = Logger.new STDOUT
        logger.formatter = Logger::Formatter.new
        @logger = ActiveSupport::TaggedLogging.new logger
      end

      def log(level, msg, tags = nil)
        logger.tagged('Napoleon', *tags){ @logger.send(level, msg) }
      end

      class << self
        def run(dataset_sequence = nil)
          self.new.run dataset_sequence
        end
      end
    end
  end
end
