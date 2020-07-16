# frozen_string_literal: true

require 'addressable'

class SearchTracker
  attr_reader :session_tracker, :search, :action

  def initialize(session_tracker, search, action: nil)
    @session_tracker = session_tracker
    @search = search
    @action = action
  end

  def id
    @id ||= SecureRandom.uuid
  end

  def store!
    TrackedSearch.create! tracked_action
    self
  end

  def tracked_results
    tracked_results = @search.results.deep_dup
    query_param = "?sid=#{id}"
    tracked_results[:data] = tracked_results[:data].map do |result|
      gateway_path = result[:gateway_path].presence
      if gateway_path
        parsed_path = Addressable::URI.parse(gateway_path)
        parsed_path.query_values = (parsed_path.query_values || {}).merge({ sid: id })
        result[:gateway_path] = parsed_path.to_s
      end
      result
    end
    tracked_results
  end

  private

  def tracked_action
    {
      id:           id,
      version:      Search::CourseSearch::VERSION,
      request:      {
        query:    @search.query,
        filter:   @search.filter,
        page:     @search.page,
        per_page: @search.per_page,
        order:    @search.order,
        boost:    @search.boost
      },
      results:      {
        ids:   @search.results[:data].map(&:id),
        total: @search.results[:meta][:total]
      },
      tracked_data: {
        session: @session_tracker.session_payload,
        cookies: @session_tracker.cookies_payload
      },
      action:       @action
    }
  end
end
