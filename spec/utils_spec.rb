# frozen_string_literal: true

RSpec.describe 'Respriter::Utils' do
  describe '.unglob' do
    it 'unglobs brace-based globs' do
      expect(Respriter::Utils.unglob('a{b,c}{d,e,f}')).to eq(%w[abd abe abf acd ace acf])
    end
  end
end
