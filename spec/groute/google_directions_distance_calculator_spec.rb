# frozen_string_literal: true

RSpec.describe Groute::GoogleDirectionsRouteCalculator do
  describe '#route' do
    let!(:shibuya_latlng) { Groute::LatLng.new(35.658034, 139.701636) }
    let!(:roppongi_latlng) { Groute::LatLng.new(35.662725, 139.731216) }

    before do
      Groute.configure do |conf|
        conf.google_map_api_key = ENV['GOOGLE_MAP_API_KEY']
      end
    end

    it 'LatLngを二つ取る' do
      expect(Groute::GoogleDirectionsRouteCalculator.new.route(from: shibuya_latlng, to: roppongi_latlng)).not_to be nil
    end

    it 'Groute::Routeのインスタンスを返す' do
      result = Groute::GoogleDirectionsRouteCalculator.new.route(from: shibuya_latlng, to: roppongi_latlng)
      expect(result).to be_an_instance_of(Groute::Route)
    end

    it '時間を分単位で返す' do
      inst = Groute::GoogleDirectionsRouteCalculator.new.route(
        from: shibuya_latlng,
        to: roppongi_latlng
      )
      expect(inst).to satisfy do |r|
        r.duration.value >= 10 && r.duration.value <= 20
      end
    end

    it '距離をメートル単位で返す' do
      inst = Groute::GoogleDirectionsRouteCalculator.new.route(
        from: shibuya_latlng,
        to: roppongi_latlng
      )
      expect(inst).to satisfy do |r|
        r.distance.value >= 2000 && r.distance.value <= 3000
      end
    end

    describe 'Google Directions APIのレスポンスステータスがOKじゃなかった時には、ApiStatusNotOkErrorが投げられる' do
      it 'statusがNOT_FOUNDの時は例外が投げられる' do
        allow_any_instance_of(
          Groute::GoogleDirectionsRouteCalculator
        ).to receive(:api_response_json).and_return({
                                                      "status" => "NOT_FOUND",
                                                    })
        expect do
          Groute::GoogleDirectionsRouteCalculator.new.route(from: shibuya_latlng, to: roppongi_latlng)
        end.to raise_error(
          an_instance_of(
            Groute::GoogleDirectionsRouteCalculator::ApiStatusNotOkError
          ).and(having_attributes(status: "NOT_FOUND"))
        )
      end

      it 'statusがOKの時には例外は投げられない' do
        allow_any_instance_of(
          Groute::GoogleDirectionsRouteCalculator
        ).to receive(:api_response_json).and_return({
                                                      "status" => "OK",
                                                    })
        expect do
          Groute::GoogleDirectionsRouteCalculator.new.route(from: shibuya_latlng, to: roppongi_latlng)
        end.not_to raise_error
      end
    end
  end
end
