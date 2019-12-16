module Integration
  module Napoleon
    class CourseService
      attr_reader :napoleon

      def initialize(napoleon)
        @napoleon = napoleon
      end

      def run(dataset_sequence = nil)
        dataset_sequence = dataset_sequence || Course.current_dataset_sequence
        self.napoleon.resources(dataset_sequence) do |resource|
          Course.upsert(resource.to_course)
        end
      end

      class << self
        def run(dataset_sequence = nil)
          self.new(::Napoleon.client).run(dataset_sequence)
        end
      end
    end
  end
end
