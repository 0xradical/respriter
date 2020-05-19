selected_facets = pipe_process.accumulator.delete :facets

url     = "#{pipeline.data[:base_api_url]}&selectedFacets=List(#{ selected_facets.map{ |key,value| "#{key}%3D#{value.gsub('#', '%23')}" }.join ',' })"
referer = [pipeline.data[:base_referer_api_url], *selected_facets.map{ |key,value| "#{key}=#{value.gsub('#', '%23')}" } ].join('&')

pipe_process.accumulator[:url]  = url
pipe_process.accumulator[:http] = {
  cookies:            pipeline.data[:cookie_jar],
  dont_encode_params: true,
  headers: {
    'Referer'    => referer,
    'Csrf-Token' => pipeline.data[:jsessionid]
  }
}

call

status_code = pipe_process.accumulator[:status_code]
raise "Something wrong happened, got status code #{status_code}" if status_code != 200

payload = Oj.load(pipe_process.accumulator[:payload]).deep_symbolize_keys

facets = payload[:data][:metadata][:facetContainer][:facets]
facet = facets.find do |facet|
  facet[:trackingName] == pipeline.data[:facet_tracking_name]
end

key          = facet[:facetName][:key]
facet_values = facet[:values].map do |value|
  [
    value[:facetValueName][:key],
    value[:count]
  ]
end.to_h

facet_values.delete 'ALL'

pipe_process.accumulator = facet_values.flat_map do |value, count|
  new_facets = [ *selected_facets, [key, value] ]

  if count <= 500 || pipeline.data[:facet_tracking_name] == 'SOFTWARE'
    entries = (count/10.0).ceil.times.map do |n|
      entry = {
        pipeline_id: pipeline.data[:search_pipeline_id],
        initial_accumulator: {
          http: {
            headers: {
              referer: [pipeline.data[:base_referer_api_url], *new_facets.map{ |key,value| "#{key}=#{value.gsub('#', '%23')}" } ].join('&')
            }
          }
        }
      }
      entry[:initial_accumulator][:url] = "#{pipeline.data[:base_api_url]}&selectedFacets=List(#{ new_facets.map{ |key,value| "#{key}%3D#{value.gsub('#', '%23')}" }.join ',' })"
      unless n == 0
        entry[:initial_accumulator][:url] += "&start=#{n}0"
      end
      entry
    end

    if pipeline.data[:facet_tracking_name] == 'SOFTWARE' || pipeline.data[:facet_tracking_name] == 'TOPICS'
      entries << {
        pipeline_id: pipeline.data[:search_pipeline_id],
        initial_accumulator: {
          url: url,
          http: {
            headers: {
              referer: referer
            }
          }
        }
      }
    end

    entries
  else
    [
      {
        initial_accumulator: {
          facets: new_facets
        }
      }
    ]
  end
end
