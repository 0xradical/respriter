module Napoleon
  class ExtractedData
    attr_reader :keep_tokens, :index, :url, :raw_tokens

    def initialize(keep_tokens, index, url, raw_tokens)
      @keep_tokens, @index, @url, @raw_tokens = keep_tokens, index, url, raw_tokens
    end

    def self.all_data
      Dir[
        './diff_trees/alura/data_*.dump'
      ].map do |path|
        Marshal.load File.read path
      end
    end

    def self.debug_summary
      all_data.inject(Hash.new) do |acc, data|
        data.merge_summary acc
      end
    end

    def merge_summary(accumulator = Hash.new)
      @summary.each do |index, index_summary|
        acc = accumulator[index] ||= {
          count:      0,
          pages:      [],
          types:      Hash.new,
          type_count: Hash.new
        }

        acc[:count] += 1

        acc[:pages].push @index

        acc[:types][ index_summary[:types] ] ||= 0
        acc[:types][ index_summary[:types] ] += 1

        acc[:type_count][ index_summary[:type_count] ] ||= 0
        acc[:type_count][ index_summary[:type_count] ] += 1

        acc[:content] ||= index_summary[:content]
        raise 'Something went wrong here' if index_summary[:content] != acc[:content]

        if acc[:content] == :Nodes
          acc[:nodes] ||= Hash.new
          acc[:nodes][ index_summary[:nodes] ] ||= 0
          acc[:nodes][ index_summary[:nodes] ] += 1
        else
          acc[:attributes_names] ||= Hash.new
          acc[:attributes_names][ index_summary[:attributes_names] ] ||= 0
          acc[:attributes_names][ index_summary[:attributes_names] ] += 1

          acc[:attributes_values] ||= Hash.new
          acc[:attributes_values][ index_summary[:attributes_values] ] ||= 0
          acc[:attributes_values][ index_summary[:attributes_values] ] += 1

          acc[:unvalued_attributes] ||= Hash.new
          acc[:unvalued_attributes][ index_summary[:unvalued_attributes] ] ||= 0
          acc[:unvalued_attributes][ index_summary[:unvalued_attributes] ] += 1

          acc[:valued_attributes] ||= Hash.new
          acc[:valued_attributes][ index_summary[:valued_attributes] ] ||= 0
          acc[:valued_attributes][ index_summary[:valued_attributes] ] += 1
        end
      end
      accumulator
    end

    def summary
      return @summary if @summary
      parse_data
      @summary
    end

    def tokens
      return @tokens if @tokens
      parse_data
      @tokens
    end

    def insertions
      return @insertions if @insertions
      parse_data
      @insertions
    end

    def marshal_dump
      [ @index, @url, @raw_tokens, @keep_tokens, @tokens, @insertions, @summary ]
    end

    def marshal_load(values)
      @index, @url, @raw_tokens, @keep_tokens, @tokens, @insertions, @summary = values
    end

    def extract
      return true if @tokens
      parse_data
      !!@tokens
    end

    protected
    def token_search_path
      Napoleon::Graph::HTMLDiff.new @keep_tokens, @raw_tokens, ways: [ :add, :keep ]
    end

    def parse_data
      @tokens     = []
      @insertions = Hash.new
      token_search_path.last_path.ways_and_tokens do |way, token|
        case way
        when nil
        when :keep
          @tokens.push token
        when :add
          @insertions[@tokens.size] ||= []
          @insertions[@tokens.size].push token
        else
          raise 'Should not be here'
        end
      end

      @summary = @insertions.map do |index, add_tokens|
        types = add_tokens.map{ |token| descriptive_type token }

        params = {
          types:      types,
          type_count: types.group_by(&:itself).map{ |type,occurrences| [ type, occurrences.count ] }.sort
        }

        if add_tokens.first.type == :AttributeName || add_tokens.first.type == :AttributeValue
          params[:content]           = :Attributes
          params[:attributes_names]  = 0
          params[:attributes_values] = 0

          attributes        = Set.new
          valued_attributes = Set.new
          add_tokens.each do |token|
            if token.type == :AttributeName
              attributes.add token.value
              params[:attributes_names] += 1
            else
              valued_attributes.add token.value[0]
              params[:attributes_values] += 1
            end
          end
          params[:valued_attributes]   = valued_attributes.to_a.sort
          params[:unvalued_attributes] = ( attributes.to_a - params[:valued_attributes] ).sort
        else
          collection = HTMLTokenCollection[ HTMLToken.new(nil, :Document, :Document), *add_tokens ]
          node_strcuture = collection.root_node.children.map do |node|
            if node.class == HTMLDiffTree::Element
              :"Element(#{ node.name }#{ node.attributes.empty? ? nil : ':' + node.attributes.map(&:first).join(',') })"
            else
              node.name
            end
          end

          params[:content] = :Nodes
          params[:nodes] = node_strcuture
        end

        [ index, params ]
      end.to_h
    end

    def descriptive_type(token)
      case token.type
      when :Element
        :"Element(#{token.value})"
      when :ElementOpenClose
        :"ElementOpenClose(#{token.value})"
      when :ElementClose
        :"ElementClose(#{token.value})"
      when :AttributeName
        :"AttributeName(#{token.value})"
      else
        token.type.to_sym
      end
    end
  end
end
