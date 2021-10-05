# frozen_string_literal: true

RSpec.describe Groute::StraitDistanceCalculator do
  describe 'distance' do
    let!(:shibuya) do
      Groute::LatLng.new(35.658034, 139.701636)
    end

    let!(:roppongi) do
      Groute::LatLng.new(35.662725, 139.731216)
    end

    it 'Groute::Meterのインスタンスを返す' do
      result = Groute::StraitDistanceCalculator.new.distance(
        from: shibuya,
        to: roppongi
      )
      expect(result).to be_an_instance_of(Groute::Meter)
    end

    it 'Groute::Meterの距離をメートル単位で返す' do
      result = Groute::StraitDistanceCalculator.new.distance(
        from: shibuya,
        to: roppongi
      )
      expect(result).to satisfy do |d|
        d.value >= 2000 && d.value <= 3000
      end
    end
  end
end
