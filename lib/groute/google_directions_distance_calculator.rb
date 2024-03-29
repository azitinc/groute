# frozen_string_literal: true
require 'cgi'
require 'net/http'
require 'open-uri'
require 'json'

module Groute
  # 2地点間の距離をGoogleDirections APIを利用して計算する
  # https://developers.google.com/maps/documentation/directions/overview
  class GoogleDirectionsDistanceCalculator
    ENDPOINT_URL_STRING = "https://maps.googleapis.com/maps/api/directions/json"
    SUCCESS_API_RESPONSE_STATUS = "OK"
    private_constant :ENDPOINT_URL_STRING, :SUCCESS_API_RESPONSE_STATUS

    # Google Directions APIを利用してルートを計算
    # @param [Groute::LatLng] origin
    # @param [Groute::LatLng] destination
    # @raise [Groute::GoogleDirectionsDistanceCalculator::ApiStatusNotOkError]
    # @return [Groute::Route]
    def route(origin, destination)
      @origin = origin
      @destination = destination
      raise ApiStatusNotOkError, api_response_status if api_response_status != SUCCESS_API_RESPONSE_STATUS

      Groute::Route.new(
        api_response_duration_minutes,
        Groute::Distance.new(api_response_distance_meter)
      )
    end

    private

    attr_reader :origin, :destination

    # @return [JSON] APIレスポンスをパースしたJSON
    def api_response_json
      @api_response_json = JSON.parse(raw_response.body)
    end

    def api_response_status
      api_response_json["status"]
    end

    # @return [Integer, nil] メートル単位の距離
    def api_response_distance_meter
      api_response_json.dig("routes", 0, "legs")&.last&.dig("distance", "value")
    end

    # @return [Float, nil] 移動時間の分
    def api_response_duration_minutes
      return nil if api_response_duration_seconds.nil?

      api_response_duration_seconds / 60.0
    end

    # @return [Float, nil] 移動時間の秒
    def api_response_duration_seconds
      api_response_json.dig("routes", 0, "legs")&.last&.dig("duration", "value")
    end

    def raw_response
      @raw_response ||= Net::HTTP.get_response(request_uri)
    end

    # APIリクエストに使うURI
    # @return [URI]
    def request_uri
      parameters = {
        origin: encode_latlng_to_query_string(origin),
        destination: encode_latlng_to_query_string(destination),
        mode: travel_mode,
        alternative: request_alternative,
        language: language_code,
        key: google_map_api_key,
        avoid: avoids.join("|"),
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
