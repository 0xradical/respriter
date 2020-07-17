# frozen_string_literal: true

call

payload = pipe_process.accumulator[:payload]
headers = pipe_process.accumulator[:response_headers]

url     = pipe_process.initial_accumulator[:url]

document = Nokogiri::HTML(payload)

json = JSON.load(document.css('.react-root').first.attributes['data-react-props'].value)
prices = pipeline.data[:prices]
languages = ['en']
last_fecthed_at = DateTime.parse(headers[:date]).strftime '%Y/%m/%d'

course_name = document.css('h1').text
instructors = [] 

creators = document.css('h4:contains("Course Creators")').first
names = creators.next.next.children.map{|k| k.text}.map{|k| k[/(?<=Curriculum: )([\w ]+)/]}.reject { |k| k.to_s.empty? } if creators
names.each{|k| instructors << {name: k}} if names

description = document.css('.markdown__1eeYJ4WPKUcvX_LDDGJR12').text

course_uuid = json['reduxData']['entities']['courses'].values.first.values.first['uuid']

syllabus = json['reduxData']['entities']['syllabuses']['byUuid'].values.first['collections']['units'].map{|k| k['meta']['title'] + ': ' + k['meta']['description']}

lessons     = syllabus.count
syllabus    = syllabus.join("\n")
duration    = {value: lessons.to_i, unit: 'lessons' } 
effort      = document.css('.timeToComplete__1KDCsG4r1sfAL3D4AGDCvC').text[/[\d+]/].to_f
workload    = {value: (effort*60.0/lessons.to_f).round, unit: 'minutes' }

content = {
  id:                Digest::SHA1.hexdigest(course_uuid),

  provider_id:       '9ad1e5c8-759c-4f73-b214-fbbbaf2e10c5',
  provider_name:     'Codecademy',
  course_name:       course_name,
  description:       description,
  version:           '1.1.0',
  status:            'available',
  url:               url,
  instructors:       instructors,
  syllabus:          syllabus,

  prices:            prices,
  paid_content:      true,
  free_content:      false,
  
  pace:              'self_paced',
  duration:          duration,
  workload:          workload, 
  effort:            effort,

  language:          languages,
  audio:             languages,
  subtitles:         languages,
  published:         true,
  
  stale:             false,
  last_fecthed_at:   last_fecthed_at,

  extra: {
    sitemap:         pipe_process.data,
  }
}

content[:slug] = [
  I18n.transliterate(content[:course_name]).downcase,
  Resource.digest(Zlib.crc32(content[:course_uuid]))
].join('-')
  .gsub(/[\s\_\-]+/, '-')
  .gsub(/[^0-9a-z\-]/i, '')
  .gsub(/(^\-)|(\-$)/, '')

pipe_process.accumulator = {
  kind: :course,
  schema_version: '2.0.0',
  unique_id: Digest::SHA1.hexdigest(course_uuid),
  content: content,
  relations: Hash.new
}
