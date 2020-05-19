class Sinatra::Base
  def self.staging?
    Napoleon.config.environment == :staging
  end

  def self.development?
    Napoleon.config.environment == :development
  end
end
