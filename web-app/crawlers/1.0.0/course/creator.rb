# TODO: Check for redirects

payload, json_ld, headers =
  pipe_process.accumulator.values_at :payload, :json_ld, :response_headers

contents = []
begin
  document = Nokogiri::HTML.fragment payload
  contents =
    document.css("script[type='application/vnd.classpert+json']").map do |node|
      Oj.load(node.text).deep_symbolize_keys
    end
rescue
  pipe_process.accumulator[:crawling_event] = {
    pipe_process_id: pipe_process.id,
    pipeline_id:     pipeline.id,
    type:            'invalid_classpert_metadata',
    url:             pipe_process.initial_accumulator[:url],
    timestamp:       Time.now,
    crawler_id:      pipeline.data[:crawler_id]
  }
  raise Pipe::Error.new(:skipped, 'Invalid classpert metadata')
end

raise Pipe::Error.new(:skipped, 'Not a course page') if contents.blank?

if contents.size > 1
  pipe_process.accumulator[:crawling_event] = {
    pipe_process_id: pipe_process.id,
    pipeline_id:     pipeline.id,
    type:            'multiple_courses_on_page',
    url:             pipe_process.initial_accumulator[:url],
    timestamp:       Time.now,
    crawler_id:      pipeline.data[:crawler_id]
  }
  raise Pipe::Error.new(:skipped, 'More than a course per page')
end

content = contents.first

content[:last_fecthed_at] = DateTime.parse(headers[:date]).strftime '%Y/%m/%d'
content[:json_ld]         = json_ld if json_ld.present?
content[:provider_id]     = pipeline.data[:provider_id]
content[:stale]           = false
content[:execution_id]    = pipeline.pipeline_execution_id
content[:url]           ||= pipe_process.initial_accumulator[:url]

content[:id]          = content[:id]&.strip
content[:course_name] = content[:course_name]&.strip
content[:description] = content[:description]&.strip

content[:published] = content[:published].nil? ? true : content[:published]

validated_content = content.deep_dup.deep_stringify_keys
errors = public_validator('course', '1.0.0').validate validated_content

owned_domain = pipeline.data[:domains].any? do |domain|
  domain_without_www = domain.gsub(/^www\./, '')
  content[:url].match %r{^https?\:\/\/([a-zA-Z\-\_0-9]+\.)*#{domain_without_www}\/}
end

unless owned_domain
  pipe_process.accumulator[:crawling_event] = {
    pipe_process_id: pipe_process.id,
    pipeline_id:     pipeline.id,
    type:            'unverified_course_domain',
    url:             pipe_process.initial_accumulator[:url],
    given_url:       content[:url],
    timestamp:       Time.now,
    crawler_id:      pipeline.data[:crawler_id]
  }
  raise Pipe::Error.new(:skipped, 'Unverified URL Domain')
end

if errors.any?
  pipe_process.accumulator[:crawling_event] = {
    type:            'invalid_course',
    pipeline_id:     pipe_process.pipeline_id,
    pipe_process_id: pipe_process.id,
    errors:          errors.to_a,
    url:             pipe_process.initial_accumulator[:url],
    crawler_id:      pipeline.data[:crawler_id]
  }
  raise Pipe::Error.new(:skipped, 'Invalid Course')
end

unless Napoleon::SafeMarkdownRenderer.valid?(content[:description])
  pipe_process.accumulator[:crawling_event] = {
    pipe_process_id: pipe_process.id,
    type:            'invalid_course_description',
    pipeline_id:     pipe_process.pipeline_id,
    errors:          errors.to_a,
    url:             pipe_process.initial_accumulator[:url],
    crawler_id:      pipeline.data[:crawler_id],
    description:     content[:description]
  }
  raise Pipe::Error.new(:skipped, 'Invalid Course Description')
end

validated_content['slug'] = [
  I18n.transliterate((validated_content['slug'] || content[:course_name]).to_s).downcase,
  Resource.digest(Zlib.crc32("#{content[:provider_id]}-#{content[:id]}"))
].join('-')
  .gsub(/[\s\_\-]+/, '-')
  .gsub(/[^0-9a-z\-]/i, '')
  .gsub(/(^\-)|(\-$)/, '')
  .gsub(/[\s\_\-]+/, '-')

pipe_process.accumulator = {
  kind: 'course',
  schema_version: '1.0.0',
  unique_id:
    Digest::SHA1.hexdigest("#{pipeline.data[:crawler_id]}-#{content[:id]}"),
  content: validated_content,
  relations: Hash.new
}

call
