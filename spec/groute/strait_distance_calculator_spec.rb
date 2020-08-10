# frozen_string_literal: true

RSpec.describe Groute::StraitDistanceCalculator do
  describe 'distance' do
    let!(:shibuya) do
      Groute::LatLng.new(35.658034, 139.701636)
    end

    let!(:roppongi) do
      Groute::LatLng.new(35.662725, 139.731216)
    end

    it 'Groute::Distanceのインスタンスを返す' do
      expect(Groute::StraitDistanceCalculator.new.distance(shibuya, roppongi)).to be_an_instance_of(Groute::Distance)
    end

    it 'Groute::Distanceの距離をメートル単位で返す' do
      expect(Groute::StraitDistanceCalculator.new.distance(shibuya, roppongi)).to satisfy do |d|
        d.value >= 2000 && d.value <= 3000
      end
    end
  end
end
