module Pipes
  class Spider < Pipe
    def execute(pipe_process, accumulator)
      return [ :skipped, accumulator.slice(:status_code) ] unless accepted_status?(accumulator[:status_code])

      urls           = extract_urls accumulator
      new_urls       = remove_already_crawled pipe_process, urls
      pipe_processes = PipeProcess.create pipe_processes_params(pipe_process, new_urls)

      pipe_processes.each do |pipe_process|
        pipe_process.enqueue
      end

      results = { count: urls.count, urls: urls }
      [ :pending, accumulator.merge(spider: results) ]
    end

    protected
    def accepted_status?(status_code)
      options[:accepted_statuses].any? do |value_or_range|
        match_status_code? value_or_range, status_code
      end
    end

    def extract_urls(accumulator)
      document = Nokogiri::HTML.fragment accumulator[:payload]

      urls = options[:selectors].flat_map do |selector, attribute|
        document.css(selector).map do |element|
          value = element.attribute attribute
          next nil if value.blank?

          text_value = value.text.gsub(/\#.*/, '').strip
          next nil if text_value.blank?

          URI.join(
            accumulator[:url].gsub(/\#.*/, ''),
            URI.escape(text_value)
          ).to_s
        end.compact
      end.uniq

      host_whitelist = options[:host_whitelist].dup
      host_whitelist << URI(accumulator[:url]).host
      urls.find_all do |url|
        host_whitelist.include?(URI(url).host) && url_blacklist.none?{ |pattern| pattern.match url }
      end
    end

    def method_name
      
    end

    def remove_already_crawled(pipe_process, urls)
      repeated_urls = PipeProcess
        .where(pipeline_id: pipe_process.pipeline_id)
        .where("initial_accumulator->>'url' IN (?)", urls)
        .pluck Arel.sql("initial_accumulator->>'url'")

      urls - repeated_urls
    end

    def url_blacklist
      @url_blacklist ||= options[:url_blacklist].map{ |str| Regexp.new str }
    end

    def pipe_processes_params(pipe_process, urls)
      urls.map do |url|
        {
          initial_accumulator: {
            url: url
          },
          pipeline_id: pipe_process.pipeline_id
        }
      end
    end

    def default_options
      {
        accepted_statuses: [ [ 200, 299 ] ],
        selectors:         [ ['a', 'href'] ],
        host_whitelist:    [],
        url_blacklist:     [],
      }
    end

    def match_status_code?(value_or_range, status_code)
      if value_or_range.is_a?(Array)
        Range.new(*value_or_range).include? status_code
      else
        value_or_range.to_i == status_code.to_i
      end
    end
  end
end
