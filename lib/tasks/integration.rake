namespace :integration do
  task import_courses: [:environment] do |t,args|
    categories = YAML::load_file(Rails.root.join('config', 'locales', 'en.yml'))['en']['categories'].invert
    supported_languages = %w(en pt pt-BR es ru it de fr)
    num_of_threads = 5; threads = []
    num_of_threads.times do |i|
      threads << Thread.new do
        pos = i; cycle = 0;
        next_page = pos * 50
        loop do
          puts "Thread #{pos} fetching page #{next_page}"
          uri = URI("https://napoleon-the-crawler.herokuapp.com/resources/updates/#{next_page}")

          req = Net::HTTP::Get.new(uri)
          req.basic_auth ENV['NAPOLEON_CRAWLER_BASIC_AUTH_USER'], ENV['NAPOLEON_CRAWLER_BASIC_AUTH_PASS']

          res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
            http.request(req)
          end

          collection = JSON.parse(res.body)

          collection.each do |record|

            slug = ActiveSupport::Inflector.transliterate(record['content']['provider_name'].downcase).gsub(/\W+/, '-').chomp('-')
            provider = Provider.find_by(slug: slug)

            if provider.nil?
              puts "#{record['content']['provider_name']} with slug #{slug} not found"
              next
            end

            next unless supported_languages.include?(record['content']['language'])

            begin
              provider.courses.find_or_create_by!(id: record['id']) do |course|
                course.global_sequence  = record['global_sequence']
                course.name             = record['content']['course_name']
                course.subtitles        = record['content']['subtitles']
                course.region           = record['content']['language']
                course.category         = categories[record['content']['category']]
                course.audio            = [record['content']['audio']].flatten
                course.slug             = record['content']['slug']
                course.url              = record['content']['url']
                course.video_url        = record['content']['video_url']
                course.description      = record['content']['description']
                course.price            = record['content']['price'].to_f
              end
            rescue
            end
          end

          cycle += 1; next_page = (pos + (cycle * num_of_threads)) * 50
          break if (collection.empty?)
        end
      end
    end

    threads.each { |thr| thr.join }

  end
end
