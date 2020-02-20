class CrawlingEvent < ApplicationRecord
  belongs_to :provider_crawler

  def process
    puts 'Not done yet'
  end

  def self.current_sequence
    maximum(:sequence) || 0
  end
end
