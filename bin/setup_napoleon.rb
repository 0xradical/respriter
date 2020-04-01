#!/usr/bin/env ruby

ProviderCrawler.all.each do |crawler|
  service = Integration::Napoleon::ProviderCrawlerService.new crawler
  service.prepare
  service.start
end
