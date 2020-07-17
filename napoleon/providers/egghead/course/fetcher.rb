# frozen_string_literal: true

call

payload  = pipe_process.accumulator[:payload]
headers  = pipe_process.accumulator[:response_headers]
url      = pipe_process.initial_accumulator[:url]
#jsonld is nil

document = Nokogiri::HTML(payload)

languages = ['en']
last_fecthed_at = DateTime.parse(headers[:date]).strftime '%Y/%m/%d'

course_name = document.css('h1').text
instructors = [{name: document.css('h2.f4.fw5.mv1').first.text}]
description = document.css('.css-12ekm6m').children.map{|k| k.text}.join(' ')

provided_tags = document.css('span.pl2').map{|k| k.text}

prices = pipeline.data[:prices]

syllabus = document.css('.ph4-ns .mb2 .mb1').children.map{|k| k.text}
lessons     = syllabus.count
syllabus    = syllabus.join("\n")
duration    = {value: lessons.to_i, unit: 'lessons' } 

time        = document.css('.ml2').first.text #"1h 4m "
hours       = time[/(\d+\s*)(?=h)/].to_f || 0.0
minutes     = time[/(\d+\s*)(?=m)/]&.concat(".0")&.to_f || 0.0

effort      = hours + (minutes/60.0)
workload    = {value: (effort*60.0/lessons.to_f).round, unit: 'minutes' }
effort      = effort.round

content = {
  id:                Digest::SHA1.hexdigest(url),
  provider_id:       '775259a6-b623-44dd-99f3-9020c70b799d', 
  provider_name:     'Egghead',
  course_name:       course_name,
  description:       description,
  version:           '1.1.0',
  status:            'available',
  url:               url,
  instructors:       instructors,
  syllabus:          syllabus,

  duration:          duration,
  workload:          workload,
  effort:            effort,

  prices:            prices,
  paid_content:      true,
  free_content:      false,

  provided_tags:     provided_tags,

  pace:              'self_paced',
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

rating = document.css('.css-1uy6b6y').first
content[:rating] = { type: 'stars', value: rating.text.to_f, range: 5 } if rating

content[:slug] = [
  I18n.transliterate(content[:url]).downcase,
  Resource.digest(Zlib.crc32(content[:url]))
].join('-')
  .gsub(/[\s\_\-]+/, '-')
  .gsub(/[^0-9a-z\-]/i, '')
  .gsub(/(^\-)|(\-$)/, '')

pipe_process.accumulator = {
  kind: :course,
  schema_version: '2.0.0',
  unique_id: Digest::SHA1.hexdigest(url),
  content: content,
  relations: Hash.new
}
