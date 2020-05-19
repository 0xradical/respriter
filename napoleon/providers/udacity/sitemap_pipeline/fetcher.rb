courses_through_api     = []
courses_through_sitemap = []

pipe_process.accumulator[:url] = pipe_process.initial_accumulator[:courses_api_url]

begin
  call

  payload = JSON.parse(pipe_process.accumulator[:payload])
  courses = payload['courses']

  api_courses_urls = []

  courses_through_api = courses.select do |course|
    course['available']
  end.map do |course|
    course_url = 'https://www.udacity.com/course/' + course['slug']

    api_courses_urls.push(course_url)

    {
      initial_accumulator: {
        url: course_url,
        api: true,
        api_payload: course
      }
    }
  end
rescue
  nil
end

begin
  pipe_process.accumulator[:url] = pipe_process.initial_accumulator[:sitemap_url]

  call

  document = Nokogiri::XML(pipe_process.accumulator[:payload])
  courses_through_sitemap = document.css('url loc')
    .map(&:text)
    .map(&:strip)
    .find_all{ |url| url.match(/https:\/\/www\.udacity\.com\/course\//) }
    .find_all{ |url| !url.in?(api_courses_urls) }
    .map{ |url| { initial_accumulator: { url: url, api: false } } }
rescue
  nil
end

if courses_through_api.empty? && courses_through_sitemap.empty?
  raise "Something went wrong during courses urls fetching"
else
  pipe_process.accumulator = courses_through_api + courses_through_sitemap
end