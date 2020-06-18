# frozen_string_literal: true

RSpec.describe 'Respriter::Utils' do
  describe '.unglob' do
    context 'when there is glob' do
      it 'unglobs brace-based globs' do
        expect(Respriter::Utils.unglob('a{b,c}{d,e,f}')).to eq(%w[abd abe abf acd ace acf])
      end
    end

    context 'when there is no glob' do
      it 'does nothing' do
        expect(Respriter::Utils.unglob('abd')).to eq(['abd'])
      end
    end
  end
end
