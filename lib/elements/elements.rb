require_relative './settings'
require_relative './asset_helper'
require_relative './railtie'

module Elements

  def self.configure(&settings)
    @@settings = Settings.new
    @@settings.instance_eval(&settings)
    @@settings
  end

  def self.settings
    @@settings
  end

  def self.asset_version
    @@settings.asset_version
  end

  def self.asset_host
    @@settings.asset_host
  end

end
