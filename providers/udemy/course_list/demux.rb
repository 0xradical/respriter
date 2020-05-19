pipe_process.accumulator = pipe_process.accumulator[:payload][:results].map do |result|
  { initial_accumulator: { payload: result } }
end

call
