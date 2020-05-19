pipe_process.data = pipe_process.accumulator
payload = pipe_process.data[:payload]

pipe_process.accumulator = {
  url: "https://www.udemy.com/api-2.0/courses/#{payload[:id]}/public-curriculum-items/?page_size=1000&fields[asset]=download_urls,url_set,thumbnail_url"
}

call
