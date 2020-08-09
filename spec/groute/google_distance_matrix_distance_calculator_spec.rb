# frozen_string_literal: true

RSpec.describe Groute::GoogleDistanceMatrixDistanceCalculator do
  describe 'new' do
    describe 'hexagonal:というオプションをわたせる' do
      it 'hexagonal: trueというオプションをわたせる' do
        expect(Groute::GoogleDistanceMatrixDistanceCalculator.new(hexagonal: true)).not_to be nil
      end

      it 'hexagonal: falseというオプションをわたせる' do
        expect(Groute::GoogleDistanceMatrixDistanceCalculator.new(hexagonal: false)).not_to be nil
      end

      it 'hexagonalを指定しなくても良い' do
        expect(Groute::GoogleDistanceMatrixDistanceCalculator.new).not_to be nil
      end
    end
  end

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

    describe 'hexagonalオプション' do
      it 'hexagonal: trueになっていた時には、6点に展開される' do
        instance = Groute::GoogleDistanceMatrixDistanceCalculator.new(hexagonal: true)
        allow(instance).to receive(:origin_hexagonal_positions).and_return([])
        instance.distance(shibuya_latlng, roppongi_latlng)
        expect(instance).to have_received(:origin_hexagonal_positions).once
      end

      it 'hexagonal: falseになっていた時には、6点に展開されない' do
        instance = Groute::GoogleDistanceMatrixDistanceCalculator.new(hexagonal: false)
        allow(instance).to receive(:origin_hexagonal_positions).and_return([])
        instance.distance(shibuya_latlng, roppongi_latlng)
        expect(instance).not_to have_received(:origin_hexagonal_positions)
      end

      it 'hexagonalオプションを指定しなかった時は、6点に展開されない' do
        instance = Groute::GoogleDistanceMatrixDistanceCalculator.new
        allow(instance).to receive(:origin_hexagonal_positions).and_return([])
        instance.distance(shibuya_latlng, roppongi_latlng)
        expect(instance).not_to have_received(:origin_hexagonal_positions)
      end
    end
  end
end
