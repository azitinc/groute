# frozen_string_literal: true

RSpec.describe Groute::GoogleDistanceMatrixDistanceCalculator do
  describe 'distance' do
    let!(:shibuya_latlng) { Groute::LatLng.new(35.658034, 139.701636) }
    let!(:roppongi_latlng) { Groute::LatLng.new(35.662725, 139.731216) }

    before do
      Groute.configure do |conf|
        conf.google_map_api_key = ENV['GOOGLE_MAP_API_KEY']
      end
    end

    it 'LatLngを二つ取る' do
      expect(Groute::GoogleDistanceMatrixDistanceCalculator.new.distance(shibuya_latlng, roppongi_latlng)).not_to be nil
    end

    it 'Groute::Distanceのインスタンスを返す' do
      expect(Groute::GoogleDistanceMatrixDistanceCalculator.new.distance(shibuya_latlng, roppongi_latlng)).to be_an_instance_of(Groute::Distance)
    end

    it 'Groute::Distanceの距離をメートル単位で返す' do
      expect(Groute::GoogleDistanceMatrixDistanceCalculator.new.distance(shibuya_latlng, roppongi_latlng)).to satisfy do |d|
        d.distance >= 2000 && d.distance <= 3000
      end
    end
  end
end
