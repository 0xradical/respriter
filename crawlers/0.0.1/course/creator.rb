# TODO: Check for redirects

payload, json_ld, headers =
  pipe_process.accumulator.values_at :payload, :json_ld, :response_headers

document = Nokogiri::HTML.fragment payload
contents = []

begin
  contents =
    document.css("script[type='application/vnd.classpert+json']").map do |node|
      Oj.load(node.text).deep_symbolize_keys
    end
rescue StandardError
  raise Pipe::Error.new(:skipped, 'Invalid classpert metadata')
end

raise Pipe::Error.new(:skipped, 'Not a course page') if contents.blank?

if contents.size > 1
  # TODO: Think about handle this case
  raise Pipe::Error.new(:failed, 'More than a course per page')
end

content = contents.first

content[:last_fecthed_at] = DateTime.parse(headers[:date]).strftime '%Y/%m/%d'
content[:json_ld]         = json_ld
content[:provider_id]     = pipeline.data[:provider_id]
content[:stale]           = false
content[:execution_id]    = pipeline.pipeline_execution_id

content[:published] = content[:published].nil? ? true : content[:published]

validated_content = content.deep_dup.deep_stringify_keys
errors = public_validator('course', '1.0.0').validate validated_content

if errors.any?
  pipe_process.accumulator = {
    kind:      'crawling_event',
    unique_id: Digest::SHA1.hexdigest("#{pipe_process.id}-invalid_course"),
    content: {
      type:        'invalid_course',
      pipeline_id: pipe_process.pipeline_id,
      errors:      errors.to_a,
      url:         pipe_process.initial_accumulator[:url],
      crawler_id:  pipeline.data[:crawler_id]
    },
    relations: Hash.new
  }
else
  pipe_process.accumulator = {
    kind: 'course',
    schema_version: '1.0.0',
    unique_id:
      Digest::SHA1.hexdigest("#{pipeline.data[:crawler_id]}-#{content[:id]}"),
    content: validated_content,
    relations: Hash.new
  }
end

call
