module Developers
  class BaseJob < Que::Job
    CLASSPERT_BOT_UA = -> (token) { "ClasspertBot (token: #{token})" }
    LOGGER = Logger.new(STDOUT).tap do |logger|
      logger.formatter  = proc do |severity, datetime, progname, msg|
        "#{msg}\n"
      end
    end

    self.priority = 100
    class << self
      attr_accessor :session_id,
                    :service_name,
                    :user_agent_token
    end

    def get_response(url, redirections = 0)
      Net::HTTP.start(
        url.host,
        url.port,
        use_ssl: url.scheme == 'https', open_timeout: 10, read_timeout: 10
      ) do |http|
        request = Net::HTTP::Get.new(url)
        if self.class.respond_to?(:user_agent_token) && self.class.user_agent_token
          request['User-Agent'] = CLASSPERT_BOT_UA.(self.class.user_agent_token)
        end
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

    def self.log(message, level = :info)
      LOGGER.public_send(
        level,
        {
          id: SecureRandom.uuid,
          ps: {
            id: self.session_id,
            name: self.service_name
          },
          payload: message
        }.to_json
      )
    end

    def log(message, level = :info)
      self.class.log(message, level)
    end
  end
end