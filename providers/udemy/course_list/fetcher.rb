accumulator = pipe_process.accumulator
subcategory = accumulator.delete :subcategory
page        = accumulator.delete :page
page_size   = 5

# accumulator[:url] = "https://www.udemy.com/api-2.0/courses?page=#{page || 1}&page_size=10&fields[course]=@all&fields[user]=@all&subcategory=#{CGI.escape subcategory}"
accumulator[:url] = "https://www.udemy.com/api-2.0/courses?page=#{page || 1}&page_size=#{page_size}&fields[course]=@all&subcategory=#{CGI.escape subcategory}"

call

if page.nil? && pipe_process.accumulator[:status_code] == 200
  count = pipe_process.accumulator[:payload][:count]
  pages = (count.to_f / page_size).ceil

  (2..pages).each do |n|
    new_process = PipeProcess.find_or_create_by initial_accumulator: { subcategory: subcategory, page: n }, pipeline_id: pipe_process.pipeline_id
    new_process.enqueue
  end
end
