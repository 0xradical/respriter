# frozen_string_literal: true

module Respriter
  module Utils
    module_function

    def unglob(s)
      if match = s.match(/\{[^\}]+\}/)
        match[0].gsub(/[{}]/, '').split(',').flat_map do |sub|
          unglob(s.sub(match[0], sub))
        end
      else
        [s]
      end
    end
  end
end
