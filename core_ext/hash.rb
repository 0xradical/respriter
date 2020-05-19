class Hash
  def deep_cumulative_merge(h, *keys)
    self.deep_merge(h) do |key, old, new|
      if key.in?(keys)
        Array.wrap(old) + Array.wrap(new)
      else
        new
      end
    end
  end
end