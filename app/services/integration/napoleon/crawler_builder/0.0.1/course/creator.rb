payload, json_ld, headers = pipe_process.accumulator.values_at :payload, :json_ld, :response_headers

document = Nokogiri::HTML.fragment payload
contents = []

begin
  contents = document.css("script[type='application/vnd.classpert+json']").map{ |node| Oj.load(node.text).deep_symbolize_keys }
rescue
  raise Pipe::Error.new(:skipped, 'Invalid classpert metadata')
end

if contents.blank?
  raise Pipe::Error.new(:skipped, 'Not a course page')
end

if contents.size > 1
  # TODO: Think about handle this case
  raise Pipe::Error.new(:failed, 'More than a course per page')
end

content = contents.first

content[:last_fecthed_at] = DateTime.parse(headers[:date]).strftime '%Y/%m/%d'
content[:json_ld]         = json_ld
content[:provider_id]     = pipeline.data[:provider_id]
content[:stale]           = false
content[:published]       = true
content[:execution_id]    = pipeline.pipeline_execution_id

content[:slug] = [
  I18n.transliterate( content[:course_name].to_s ).downcase,
  Resource.digest( Zlib.crc32(content[:id].to_s) )
].join('-')
  .gsub(/[\s\_\-]+/, '-')
  .gsub(/[^0-9a-z\-]/i, '')
  .gsub(/[\s\_\-]+/, '-')
  .gsub(/(^\-)|(\-$)/, '')

pipe_process.accumulator = {
  kind:           'course',
  schema_version: '1.0.0',
  unique_id:      Digest::SHA1.hexdigest("#{pipeline.data[:crawler_id]}-#{content[:id]}"),
  content:        content,
  relations:      Hash.new
}

call
