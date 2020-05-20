class CrawlingEvent < ApplicationRecord
  belongs_to :provider_crawler

  def process
    "Napoleon::CrawlingEventProcessor::#{type.camelize}".constantize.new(self).process
  end

  def self.current_sequence
    maximum(:sequence) || 0
  end

  def self.inheritance_column
    'dont_have_it'
  end
end
