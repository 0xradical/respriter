# frozen_string_literal: true

call

payload  = pipe_process.accumulator[:payload]
headers  = pipe_process.accumulator[:response_headers]
url      = pipe_process.initial_accumulator[:url]

document = Nokogiri::HTML(payload)

json = JSON.load(document.at_css("script#__NEXT_DATA__")&.children&.first&.content)
if !json
  raise Pipe::Error.new(:skipped, 'Course missing json data')
end

product_data = json&.[]('props')&.[]('pageProps')&.[]('profile')&.[]('product')
if !product_data
  raise Pipe::Error.new(:skipped, 'Course not available')
end

if product_data['format'] != 'category.online_services.name'
  raise Pipe::Error.new(:skipped, 'Not an Online Course')
end

offer_id = product_data['offer']

product_id = product_data['productId'].to_s

last_fecthed_at = DateTime.parse(headers[:date]).strftime '%Y/%m/%d'

course_name = document.css('.main-title').text
description = document.css('.section_description_together').text
if !description || description.blank?
  raise Pipe::Error.new(:skipped, 'No course description')
end

provided_tags = document.css('.tag-category').map{|k| k.text}

hotmarter = product_data['hotmarter']
instructor_name = hotmarter['name']

if !instructor_name || instructor_name.blank?
  raise Pipe::Error.new(:skipped, 'No instructor name')
end

instructor = {
  name:         instructor_name,
  id:           hotmarter['userId'],
  social_media: hotmarter['socialMedia'],
  long_bio:     hotmarter['biography']
}
instructor[:email] = hotmarter['email'] if hotmarter['email']
instructors = [ instructor ]

scraped_language = product_data['language']&.downcase
raise Pipe::Error.new(:skipped, 'No course language') if !scraped_language

# 'pt_br' -> 'pt-BR'
lang = scraped_language.split('_').first
country = scraped_language.split('_').second
languages = [ country ? lang + '-' + country.upcase : lang ]

content = {
  id:                Digest::SHA1.hexdigest(product_id),
  provider_id:       '89c37e62-e869-476f-8f67-d929d7afefee', 
  provider_name:     'Hotmart',

  course_name:       course_name,
  description:       description,
  provided_tags:     provided_tags,

  status:            'available',
  url:               url,
  instructors:       instructors,

  paid_content:      true,
  free_content:      false,
  
  pace:              'self_paced',
  language:          languages,
  audio:             languages,
  subtitles:         languages,
  published:         true,
  
  stale:             false,
  last_fecthed_at:   last_fecthed_at,
}

lessons     = product_data['dataSheet']['totalClasses'].to_i 
if lessons && lessons > 0
  content[:duration] = {value: lessons, unit: 'lessons' } 
end

modules = json['props']['pageProps']['profile']['productSummary']&.[]('modules')
content[:syllabus] = modules.to_s.gsub("\"title\"=>", "\n").gsub("\"content\"=>", "\n").delete("{}[]\"") if modules

rating = product_data['rating']
content[:rating] = { type: 'stars', value: rating, range: 5 } if rating

video_link = product_data['videoLink']
if video_link && video_link != ''  
  if video_link.include?('youtu.be') || video_link.include?('youtube.com/watch')
    id = video_link[/(?<=youtu.be\/)([-\w]+)/] || 
         video_link[/(?<=youtube.com\/watch\?v=)([-\w]+)/] ||
         video_link[/(?<=&v=)([-\w])+/] || 
         video_link[/(?<=youtube.com\/embed\/)([-\w]+)/]
    raise Pipe::Error.new(:skipped, 'No video id') if !id
    content[:video] = {
      type:          'youtube',
      id:            id
    } 
  elsif video_link.include?('vimeo.com')
    id = video_link[/(?<=vimeo.com\/)(\w+)/]
    raise Pipe::Error.new(:skipped, 'No video id') if !id
    content[:video] = {
      type:          'vimeo',
      id:            id
    }   
  end
end

content[:slug] = [
  I18n.transliterate(content[:course_name]).downcase,
  Resource.digest(Zlib.crc32(content[:id]))
].join('-')
  .gsub(/[\s\_\-]+/, '-')
  .gsub(/[^0-9a-z\-]/i, '')
  .gsub(/(^\-)|(\-$)/, '')

pipe_process.data = {
  content: content,
  product_id: product_id
}

price_api_url = "https://api-display.hotmart.com/back/rest/v3/product/#{product_id}/offer"
price_api_url += "?off=#{offer_id}" if offer_id
pipe_process.accumulator ={
  url: price_api_url
}
