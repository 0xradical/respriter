# frozen_string_literal: true

module Respriter
  class DependencyResolver
    # entries: lookup hash to look for any entity
    # resolver: closure that turns entity into array of ids
    def initialize(entries, resolver)
      @entries = entries
      @resolver = resolver
    end

    def resolve(entity)
      @resolver.call(entity).flatten.compact.map do |id|
        dependencies(id, [id])
      end.flatten.compact
    end

    def dependencies(id, result = [])
      if @entries[id]
        @resolver.call(@entries[id]).flatten.compact.each do |inner_id|
          result << inner_id

          if @entries[inner_id]
            result = result.concat(dependencies(inner_id, result))
          end
        end
      end

      result
    end
  end
end
