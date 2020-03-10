module Developers
  class BaseJob < Que::Job

    def get_response(url, redirections = 0)
      Net::HTTP.start(
        url.host,
        url.port,
        use_ssl: url.scheme == 'https', open_timeout: 10, read_timeout: 10
      ) do |http|
        request = Net::HTTP::Get.new(url)
        response = http.request(request)

        if !response.code.to_i.in?([301, 302])
          response
        else
          if redirections > 5
            raise "Too many redirections"
          else
            get_response(URI(response.header['location']), redirections + 1)
          end
        end
      end
    rescue Net::OpenTimeout
      raise "Timeout while trying to access #{url}"
    end
  end
end