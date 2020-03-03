class CrawlingEvent < ApplicationRecord
  belongs_to :provider_crawler

  def process
    puts 'Not done yet'
  end

  def self.inheritance_column
    'dont_have_it'
  end

  def self.current_sequence
    maximum(:sequence) || 0
  end
end
