# frozen_string_literal: true

require_relative '../../lib/uuid'

RSpec.describe 'UUID' do
  let(:uuid) { 'd7fe7050-c364-4b97-8478-a084d8864085' }
  let(:not_uuid) { '42' }

  describe '.uuid?' do
    it 'returns true if argument is an uuid string' do
      expect(UUID.uuid?(uuid)).to be(true)
    end

    it 'returns false if argument is not an uuid string' do
      expect(UUID.uuid?(not_uuid)).to be(false)
    end
  end
end
