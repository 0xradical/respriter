content       = pipe_process.accumulator.delete :content
skip_video    = pipe_process.accumulator.delete :skip_video
thumbnail_url = pipe_process.accumulator.delete :thumbnail_url

unless skip_video
  call

  document = Nokogiri::HTML.fragment pipe_process.accumulator[:payload]

  script = document.css('script').find{ |tag| tag.text.match /window\.initialState\=/ }
  if script.present?
    source = Napoleon::JavaScript.new script.text
    player_initial_state = source.assignment 'window.initialState'

    if player_initial_state.present? # Invalid character at payload causing "V8::Error: Line 3: Unexpected token ILLEGAL"
      player_data = {
        raw:      player_initial_state,
        video_id: player_initial_state[:tableOfContents][:modules][0][:contentItems][0][:id]
      }

      content[:video] = {
        type:          'video_service',
        path:          "pluralsight/#{player_data[:video_id]}",
        thumbnail_url: thumbnail_url
      }

      content[:extra] ||= Hash.new
      content[:extra][:player_data] = player_data
    end
  end
end

pipe_process.accumulator = {
  kind:      :course,
  unique_id: Digest::SHA1.hexdigest(content[:url]),
  content:   content,
  relations: Hash.new
}
