Pry.config.prompt = [ proc{ "\033[34m>> \033[0m" }, proc{ "\033[34m   \033[0m" } ]
Pry.config.print = proc { |output, value| output.puts "\033[34m \#\033[0m #{value.inspect}" }
Pry.pager = false
