module Napoleon
  class JavaScript
    attr_reader :code, :ast

    def initialize(code = nil)
      self.code = code
    end

    def code=(value)
      @code = value
      parse
    end

    def has_variable?(varname)
      find_variable_by_name(varname.to_sym) do |declaration|
        return true
      end
    end

    def variable(varname)
      find_variable_by_name(varname.to_sym) do |declaration|
        return statement_to_data declaration[:init]
      end
    end
    alias :[] :variable

    def assignment(identifier)
      find_assignment_by_identifier identifier
    end

    def variables
      traverse_variables do |declaration|
        declaration[:id][:name].to_sym
      end.uniq
    end

    def to_s
      "#<JavaScript: @code: #{@code.truncate 50}>"
    end
    alias :inspect :to_s

    protected
    def parse
      @ast = Esprima::Parser.new.parse(@code) if @code.present?
    rescue V8::Error
      nil
    end

    def traverse_assignments(&block)
      return nil if @ast.blank?
      results = []
      @ast.tree[:body].each do |statement|
        next unless statement[:type] == 'ExpressionStatement' && statement[:expression][:type] == 'AssignmentExpression'

        expression = statement[:expression]
        result = yield expression
        results << expression
      end
      results
    end

    def find_assignment_by_identifier(identifier)
      traverse_assignments do |expression|
        data = statement_to_data expression[:left] rescue binding.pry
        if data == identifier
          return statement_to_data expression[:right]
        end
      end
      nil
    end

    def traverse_variables(&block)
      return nil if @ast.blank?
      results = []
      @ast.tree[:body].each do |statement|
        next unless statement[:type] == 'VariableDeclaration'
        statement[:declarations].each do |declaration|
          if declaration[:type] == 'VariableDeclarator'
            result = yield declaration
            results << result unless results.nil?
          end
        end
      end
      results
    end

    def find_variable_by_name(varname, &block)
      return nil if @ast.blank?
      @ast.tree[:body].each do |statement|
        next unless statement[:type] == 'VariableDeclaration'
        statement[:declarations].each do |declaration|
          if declaration[:type] == 'VariableDeclarator' && declaration[:id][:name].to_sym == varname
            yield declaration
            return
          end
        end
      end
      nil
    end

    def statement_to_data(node)
      case node[:type]
      when 'MemberExpression'
        "#{ statement_to_data node[:object] }.#{ statement_to_data node[:property] }"
      when 'ObjectExpression'
        object = Hash.new
        node[:properties].each do |property|
          object[ statement_to_data(property[:key]).to_sym ] = statement_to_data(property[:value])
        end
        return object
      when 'ArrayExpression'
        return node[:elements].map{ |e| statement_to_data e }
      when 'Literal'
        return node[:value]
      when 'Identifier'
        return node[:name]
      else
        raise "Invalid statement of type #{@node[:type]}"
      end
    end
  end
end
