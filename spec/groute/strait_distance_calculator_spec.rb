# frozen_string_literal: true

RSpec.describe Groute::StraitDistanceCalculator do
  describe 'call' do
    it 'LatLngを二つ取る' do
      origin = Groute::LatLng.new(35.0, 135.0)
      destination = Groute::LatLng.new(30.0, 135.0)
      expect(Groute::StraitDistanceCalculator.call(origin, destination)).not_to be nil
    end

    it 'Groute::Distanceのインスタンスを返す' do
      origin = Groute::LatLng.new(35.0, 135.0)
      destination = Groute::LatLng.new(30.0, 135.0)
      expect(Groute::StraitDistanceCalculator.call(origin, destination)).to be_an_instance_of(Groute::Distance)
    end

    it 'Groute::Distanceの距離をメートル単位で返す' do
      shibuya = Groute::LatLng.new(35.658034, 139.701636)
      roppoingi = Groute::LatLng.new(35.662725, 139.731216)
      expect(Groute::StraitDistanceCalculator.call(shibuya, roppoingi)).to satisfy do |d|
        d.distance >= 2000 && d.distance <= 3000
      end
    end
  end
end
