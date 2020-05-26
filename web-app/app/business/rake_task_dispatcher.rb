class RakeTaskDispatcher

  def initialize(scope)
    @scope = scope
  end

  def tasks
    `bundle exec rake -T '#{@scope}'`
  end

  def dispatch!(input, async=true)
    inspect_input!(input)
    SystemCallJob.perform_later(input)
  end

  private

  def inspect_input!(input)
    sys_call = /^(?:bundle )?(?:exec )?rake (?:environment )?(?:#{@scope}){1}:[a-z0-9_:]+\[?[a-zA-Z0-9'-_,]*\]?$/.match(input)
    raise ArgumentError.new("Command '#{input}' invalid or not allowed") if sys_call.nil?
  end

end
