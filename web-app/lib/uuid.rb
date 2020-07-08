# frozen_string_literal: true

module UUID
  module_function

  def uuid?(value)
    value.match?(/^[0-9A-F]{8}-[0-9A-F]{4}-[1-5][0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$/i)
  rescue StandardError
    false
  end
end
