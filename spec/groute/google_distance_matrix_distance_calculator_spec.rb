# frozen_string_literal: true

RSpec.describe Groute::GoogleDistanceMatrixRouteCalculator do
  describe 'new' do
    describe 'hexagonal:というオプションをわたせる' do
      it 'hexagonal: trueというオプションをわたせる' do
        expect(Groute::GoogleDistanceMatrixRouteCalculator.new(hexagonal: true)).not_to be nil
      end

      it 'hexagonal: falseというオプションをわたせる' do
        expect(Groute::GoogleDistanceMatrixRouteCalculator.new(hexagonal: false)).not_to be nil
      end

      it 'hexagonalを指定しなくても良い' do
        expect(Groute::GoogleDistanceMatrixRouteCalculator.new).not_to be nil
      end
    end
  end

  describe '#route' do
    let!(:shibuya_latlng) { Groute::LatLng.new(35.658034, 139.701636) }
    let!(:roppongi_latlng) { Groute::LatLng.new(35.662725, 139.731216) }

    before do
      Groute.configure do |conf|
        conf.google_map_api_key = ENV['GOOGLE_MAP_API_KEY']
      end
    end

    it 'LatLngを二つ取る' do
      expect(Groute::GoogleDistanceMatrixRouteCalculator.new.route(shibuya_latlng, roppongi_latlng)).not_to be nil
    end

    it 'Groute::Routeのインスタンスを返す' do
      result = Groute::GoogleDistanceMatrixRouteCalculator.new.route(shibuya_latlng, roppongi_latlng)
      expect(result).to be_an_instance_of(Groute::Route)
    end

    it 'Groute::Routeの距離をメートル単位で返す' do
      expect(Groute::GoogleDistanceMatrixRouteCalculator.new.route(shibuya_latlng, roppongi_latlng)).to satisfy do |r|
        r.distance.value >= 2000 && r.distance.value <= 3000
      end
    end

    describe 'hexagonalオプション' do
      it 'hexagonal: trueになっていた時には、6点に展開される' do
        instance = Groute::GoogleDistanceMatrixRouteCalculator.new(hexagonal: true)
        allow(instance).to receive(:origin_hexagonal_positions).and_return([])
        instance.route(shibuya_latlng, roppongi_latlng)
        expect(instance).to have_received(:origin_hexagonal_positions).once
      end

      it 'hexagonal: falseになっていた時には、6点に展開されない' do
        instance = Groute::GoogleDistanceMatrixRouteCalculator.new(hexagonal: false)
        allow(instance).to receive(:origin_hexagonal_positions).and_return([])
        instance.route(shibuya_latlng, roppongi_latlng)
        expect(instance).not_to have_received(:origin_hexagonal_positions)
      end

      it 'hexagonalオプションを指定しなかった時は、6点に展開されない' do
        instance = Groute::GoogleDistanceMatrixRouteCalculator.new
        allow(instance).to receive(:origin_hexagonal_positions).and_return([])
        instance.route(shibuya_latlng, roppongi_latlng)
        expect(instance).not_to have_received(:origin_hexagonal_positions)
      end
    end
  end
end
