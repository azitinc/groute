# frozen_string_literal: true
require 'cgi'
require 'net/http'
require 'open-uri'
require 'json'

module Groute
  # 2地点間の距離をGoogleDirections APIを利用して計算する
  # https://developers.google.com/maps/documentation/directions/overview
  class GoogleDirectionsRouteCalculator
    ENDPOINT_URL_STRING = "https://maps.googleapis.com/maps/api/directions/json"
    SUCCESS_API_RESPONSE_STATUS = "OK"
    private_constant :ENDPOINT_URL_STRING, :SUCCESS_API_RESPONSE_STATUS

    # Google Directions APIを利用してルートを計算
    # @param [Groute::LatLng] from
    # @param [Groute::LatLng] to
    # @param [Array<Groute::LatLng>] waypoints 中継地点
    # @raise [Groute::GoogleDirectionsRouteCalculator::ApiStatusNotOkError]
    # @return [Groute::Route]
    def route(from:, to:, waypoints: [])
      @from = from
      @to = to
      @waypoints = waypoints
      raise ApiStatusNotOkError, api_response_status if api_response_status != SUCCESS_API_RESPONSE_STATUS

      Groute::Route.new(
        duration: Groute::Minutes.new(total_duration_minutes),
        distance: Groute::Meter.new(total_distance_meter),
        sub_routes: sub_routes
      )
    end

    private

    attr_reader :from, :to, :waypoints

    def api_response_status
      api_response_json["status"]
    end

    def total_distance_meter
      legs_distance_meters.sum
    end

    # @return [Float, nil] 移動時間の分
    def total_duration_minutes
      legs_duration_minutes.sum
    end

    # @return [Array<Route>] 各経由地の間のルート
    def sub_routes
      legs_duration_minutes.zip(legs_distance_meters).collect do |minutes, meter|
        SubRoute.new(duration: Groute::Minutes.new(minutes), distance: Groute::Meter.new(meter))
      end
    end

    # @return [Array<Float>] 各区間の移動時間の分
    def legs_duration_minutes
      legs_duration_seconds.collect do |s|
        s / 60.0
      end
    end

    # @return [Array<Int>] 各区間の移動距離のメートル
    def legs_distance_meters
      api_response_legs.collect do |l|
        l.dig("distance", "value")
      end
    end

    # @return [Array<Float>] 各区間の移動時間の秒
    def legs_duration_seconds
      api_response_legs.collect do |l|
        l.dig("duration", "value")
      end
    end

    # @return [Array<JSON>] 各経路のパーツ
    def api_response_legs
      api_response_route&.dig("legs") || []
    end

    def api_response_route
      @api_response_route ||= api_response_json.dig("routes", 0)
    end

    # @return [JSON] APIレスポンスをパースしたJSON
    def api_response_json
      @api_response_json = JSON.parse(raw_response.body)
    end

    def raw_response
      @raw_response ||= Net::HTTP.get_response(request_uri)
    end

    # APIリクエストに使うURI
    # @return [URI]
    def request_uri
      parameters = {
        origin: encode_latlng_to_query_string(from),
        destination: encode_latlng_to_query_string(to),
        mode: travel_mode,
        alternative: request_alternative,
        language: language_code,
        key: google_map_api_key,
        avoid: avoids.join("|"),
        waypoints: waypoints.map { |w| encode_latlng_to_query_string(w) }.join("|"),
      }
      query_params = parameters.collect { |k, v| "#{k}=#{CGI.escape(v.to_s)}" }.join("&")

      URI.parse("#{ENDPOINT_URL_STRING}?#{query_params}")
    end

    # APIの結果をどの言語で返すか
    # @return [Symbol]
    def language_code
      :ja
    end

    # 結果を複数取得するかどうか
    # @return [Boolean]
    def request_alternative
      false
    end

    # 交通手段、クルマとする
    # @return [Symbol]
    def travel_mode
      :driving
    end

    # 利用をさける物
    # - tolls 有料道路
    # - highways 高速道路
    # - ferries フェリー
    # @return [Array<String>]
    def avoids
      %w[tolls highways ferries]
    end

    # Google MapのAPIキー
    # @return [String, nil]
    def google_map_api_key
      Groute.config.google_map_api_key
    end

    # @param [Groute::LatLng] latlng
    # @return [String]
    def encode_latlng_to_query_string(latlng)
      "#{latlng.latitude},#{latlng.longitude}"
    end
  end
end
