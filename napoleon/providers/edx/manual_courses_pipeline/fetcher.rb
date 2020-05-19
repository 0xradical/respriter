call

payload          = pipe_process.accumulator[:payload]
document         = Nokogiri::HTML(payload)
course_data_path = document.css("link[as='fetch'][rel='preload']").first&.attribute('href')&.value

if course_data_path
  pipe_process.accumulator = { url: URI.parse(pipe_process.initial_accumulator[:url]).tap{|uri| uri.path = course_data_path}.to_s }
else
  raise Pipe::Error.new(:skipped, "No course data to be parsed")
end