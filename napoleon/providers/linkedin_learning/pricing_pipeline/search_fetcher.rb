call

status_code = pipe_process.accumulator[:status_code]
raise "Something wrong happened, got status code #{status_code}" if status_code != 200

cookie_data = pipe_process.accumulator[:cookie_jar]
cookie_jar = HTTP::CookieJar.new
cookie_data.each do |cookie|
  cookie = HTTP::Cookie.new cookie.deep_symbolize_keys
  cookie_jar.add cookie
end

session_id = cookie_jar.find{ |c| c.name == 'JSESSIONID' }.value

pipeline.data[:jsessionid] = session_id
pipeline.data[:cookie_jar] = cookie_data

pipeline.save!

pipe_process.accumulator = [
  {
    initial_accumulator: {
      facets: [ ['entityType', 'COURSE'] ]
    }
  }
]
