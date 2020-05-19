module CustomScriptRunner
  extend ActiveSupport::Concern

  def run_script(type, script, **options)
    options[:filename] ||= 'custom_code'

    case type.to_sym
    when :ruby
      run_ruby_code script, options
    when :js
      run_javascript_code script, options
    when :defered_sql
      run_sql_code script, options
    else
      raise 'Invalid format'
    end
  end

  protected
  def run_ruby_code(script, **options)
    instance_eval script, "#{virtual_source_folder}/#{options[:filename]}.rb", 1
  rescue
    # TODO: Clean internal backtrace
    raise CustomScriptRunner::ScriptError.new(:ruby, $!)
  end

  def run_javascript_code(script, **options)
    result = nil

    full_script = %{(
      function(){
        var result = null;
        try{
          #{script}
        } catch(error) {
          error.wrapped_error = true;
          error.sbacktrace = error.backtrace;
          result = error;
        } finally {
          return result;
        }
      }
    )()}

    filename = "#{virtual_source_folder}/#{options[:filename]}.js"
    V8::Context.new(with: self) do |ctx|
      begin
        result = ctx.eval(full_script, filename)
      rescue V8::Error
        raise js_error_to_ruby($!, filename)
      end
      if result.respond_to?(:wrapped_error) && result.wrapped_error
        raise js_error_to_ruby(result, filename)
      end
      result = result.to_h
    end
    result
  end

  def js_error_to_ruby(error, filename)
    backtrace = error.respond_to?(:stack) ? error.stack.lines.map(&:chomp).map(&:strip) : []
    regexp = Regexp.new("#{filename}:(?<line>\\d+):(?<char>\\d+)")
    backtrace = backtrace[0..-2].map do |line|
      line.gsub(regexp) do |str|
        match = str.match regexp
        "#{filename}:#{match[:line].to_i - 4}:#{match[:char].to_i - 10}"
      end
    end
    CustomScriptRunner::ScriptError.new(:js, error, backtrace)
  end

  def run_sql_code(script, options)
    raise NotImplementedError
  end

  class ScriptError < StandardError
    attr_reader :error

    def initialize(type, error, backtrace = nil)
      @type, @error, @backtrace = type, error, backtrace
    end

    def backtrace
      @backtrace || @error.backtrace
    end

    def message
      "ScriptError with #{@type}: #{@error.to_s}"
    end
  end
end