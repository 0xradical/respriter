call

xml            = Nokogiri::XML(pipe_process.accumulator[:payload]).remove_namespaces!
sitemaps_nodes = xml.xpath("//sitemapindex/sitemap/loc/text()")

pipe_process.accumulator = sitemaps_nodes.map do |sitemap_node|
  { initial_accumulator: { url: sitemap_node.text() } }
end