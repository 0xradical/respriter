call

accumulator = pipe_process.accumulator

pattern = /platzi.com\/cursos\/[^\?\/]+\/?$/
if accumulator[:status_code] == 404 && pattern.match(accumulator[:url])
  pipe_process.status = :pending
else
  unless pattern.match(accumulator[:url])
    pipe_process.status = :skipped
    pipe_process.accumulator = accumulator.slice :url
  end
end
