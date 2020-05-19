pipe_process.data = pipe_process.accumulator. delete :data

call

payload  = pipe_process.accumulator[:payload]
document = Nokogiri::XML(payload)

data = document.css('url').map do |url_node|
  data_objects = url_node.css('pagemap|DataObject', pagemap: 'http://www.google.com/schemas/sitemap-pagemap/1.0').map do |data_nodes|
    attributes = data_nodes.css('pagemap|Attribute', pagemap: 'http://www.google.com/schemas/sitemap-pagemap/1.0').map do |node|
      [ node.attribute('name').text.strip, node.text.strip ]
    end

    tags = data_nodes.css("pagemap|Attribute[name='tag']", pagemap: 'http://www.google.com/schemas/sitemap-pagemap/1.0').map{ |n| n.text.strip }

    {
      id:          data_nodes.attribute('id').text.strip,
      obj_type:    data_nodes.attribute('type').text.strip,
      title:       data_nodes.css("pagemap|Attribute[name='title']",       pagemap: 'http://www.google.com/schemas/sitemap-pagemap/1.0').text.strip,
      description: data_nodes.css("pagemap|Attribute[name='description']", pagemap: 'http://www.google.com/schemas/sitemap-pagemap/1.0').text.strip,
      type:        data_nodes.css("pagemap|Attribute[name='type']",        pagemap: 'http://www.google.com/schemas/sitemap-pagemap/1.0').text.strip,
      author:      data_nodes.css("pagemap|Attribute[name='author']",      pagemap: 'http://www.google.com/schemas/sitemap-pagemap/1.0').text.strip,
      tags:        tags
    }
  end

  video = nil
  if document.css('video|video').present?
    tags = url_node.css('video|tag').map{ |n| n.text.strip }

    video = {
      thumbnail_loc: url_node.css( 'video|thumbnail_loc' ).text.strip,
      title:         url_node.css( 'video|title'         ).text.strip,
      description:   url_node.css( 'video|description'   ).text.strip,
      player_loc:    url_node.css( 'video|player_loc'    ).text.strip,
      duration:      url_node.css( 'video|duration'      ).text.strip,
      category:      url_node.css( 'video|category'      ).text.strip,
      tags:          tags
    }
  end

  {
    loc:          url_node.css('loc').map(&:text).map(&:strip),
    langs:        url_node.css("xhtml|link[rel='alternate']").map{ |node| [node.attribute('hreflang').text.strip, node.attribute('href').text.strip] }.to_h,
    video:        video,
    data_objects: data_objects
  }
end

chapter_index = pipe_process.data[:chapters].map{ |chapter| chapter[:url] }.index pipe_process.accumulator[:url]
chapter       = pipe_process.data[:chapters][chapter_index]

pattern = /\/..?\/[^\/]+$/
url_grouped_data = data.group_by{ |datum| datum[:loc].first }.map do |url, datum|
  [url.match(pattern)[0], datum.first]
end.to_h

sub_chapters = chapter[:urls].map do |url|
  sub_chapter = url_grouped_data[ url.match(pattern)[0] ]
  next if sub_chapter.blank?
  {
    url:         url,
    sub_chapter: sub_chapter
  }
end.compact

pipe_process.data[:sub_chapters] = { chapter_index => sub_chapters }
