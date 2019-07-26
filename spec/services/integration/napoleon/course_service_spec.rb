describe 'Integration::Napoleon::CourseService' do
  let(:service) do
    Integration::Napoleon::CourseService.new(napoleon)
  end

  let(:payload) do
    JSON.parse(File.read(Rails.root.join('spec/fixtures/napoleon/platzi.json')))
  end

  let(:course) do
    create(:course)
  end

  let(:napoleon) do
    (Class.new do
      attr_accessor :payload

      def initialize(course, payload)
        @course = course
        @payload = JSON.parse(payload.to_json).merge({'id' => @course.id})
      end

      def resources(_global_sequence, &blk)
        blk.call(@payload)
      end
    end).new(course, payload)
  end

  describe "#run" do
    context 'on upsert' do
      before do
        # assume we don't have slug info initially
        napoleon.payload['content'].delete('slug')
      end

      it 'fetches Napoleon resources and upsert on courses relations' do
        service.run
        course.reload
        expect(course.slug).to eq(nil)

        napoleon.payload['content']['slug'] = payload['content']['slug']

        service.run
        course.reload
        expect(course.slug).to eq(payload['content']['slug'])
      end
    end
  end
end
