categories = YAML::load_file(Rails.root.join('config', 'locales', 'en.yml'))['en']['categories'].invert
data = JSON.parse(File.read(Rails.root.join('db', 'resources.json')))
data.each do |record|

  slug = ActiveSupport::Inflector.transliterate(record['provider_name'].downcase).gsub(/\W+/, '-').chomp('-')
  provider = Provider.find_by(slug: slug)

  if provider.nil?
    puts "#{record['provider_name']} with slug #{slug} not found"
    next
  end

  begin
    provider.courses.create({
      name: record['raw']['course_name'],
      subtitles: record['subtitles'],
      category: categories[record['category']],
      audio: record['audio'],
      slug: record['slug'],
      url: record['url'],
      raw: record['raw'],
      price: record['price'].to_f
    })
  rescue
  end

end
