# OLD, DEPRECATED CODE. WON'T WORK.
# providers_crawler_id = crawler.config[:providers_crawler_id]

# page_version.data[:providers].each do |data|
#   courses_count = data[:courses_count].to_i
#   page_count    = (courses_count/50) + ( courses_count % 50 == 0 ? 0 : 1 )

#   page_count.times do |i|
#     page_params = {
#       url:        "https://www.class-central.com/maestro#{data[:provider_path]}?sort=name-up&page=#{i+1}",
#       method:     :get,
#       crawler_id: providers_crawler_id
#     }

#     unless page = Page.find_by(page_params)
#       Page.create page_params.merge(data: { raw: data })
#     end
#   end
# end

# true
