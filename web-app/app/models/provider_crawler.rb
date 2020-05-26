class ProviderCrawler < ApplicationRecord
  belongs_to :provider

  has_many :crawler_domains

  serialize :sitemaps, SitemapsSerializer
  serialize :settings, DeepSymbolizeSerializer
end
