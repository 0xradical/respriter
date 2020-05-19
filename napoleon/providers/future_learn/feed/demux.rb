courses_data = JSON.parse pipe_process.accumulator[:payload]

pipe_process.accumulator = courses_data.map do |course|
  {
    initial_accumulator: {
      url: course['url'].gsub(/\?.*/, ''),
      course: course
    }
  }
end

call
