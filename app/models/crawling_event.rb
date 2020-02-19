class CrawlingEvent < ApplicationRecord
  belongs_to :provider_crawler

  def process
    puts 'Not done yet'
  end
end
