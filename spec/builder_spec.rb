# frozen_string_literal: true

RSpec.describe 'Respriter::DependencyResolver' do
  let(:resolver) do
    proc do |entity|
      case entity
      when :a
        [:b]
      when :b
        %i[c d]
      when :d
        %i[e f]
      else
        [:e]
      end
    end
  end

  let(:entries) do
    # id => id
    {
      a: :a, b: :b, c: :c, d: :d, e: :e, f: :f
    }
  end

  let(:builder) do
    Respriter::DependencyResolver.new(entries, resolver)
  end

  describe '#dependencies' do
    it 'returns an array of dependencies' do
      expect(builder.resolve(:a).sort).to eq(%i[b c d e f])
    end
  end
end
