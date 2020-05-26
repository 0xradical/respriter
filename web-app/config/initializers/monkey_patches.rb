class String
  def ansi(color)
    case color
      when :blue
       return "\033[34m#{self}\033[0m"
      when :red
        return "\033[31;1m#{self}\033[0m"
      when :yellow
        return "\033[33m#{self}\033[0m"
      when :green
        return "\033[32m#{self}\033[0m"
    end
  end
end
