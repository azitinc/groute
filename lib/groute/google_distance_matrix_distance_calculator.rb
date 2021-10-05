# frozen_string_literal: true
require 'google_distance_matrix'

module Groute
  # 2地点間の距離をGoogle Distance Matrix APIを利用して計算する
  class GoogleDistanceMatrixDistanceCalculator
    EARTH_RADIUS_KILO_METER = 6378
    private_constant :EARTH_RADIUS_KILO_METER

    # @param [Boolean] hexagonal 周辺6点に展開するかどうか
    def initialize(hexagonal: false)
      @hexagonal = hexagonal
    end

    # Google Distance Matrix APIを利用してルートを計算
    # @param [Groute::LatLng] origin
    # @param [Groute::LatLng] destination
    # @return [Groute::Route]
    def route(origin, destination)
      @origin = origin
      @destination = destination

      fill_distance_matrix_origins
      fill_distance_matrix_destinations

      google_distance_matrix.configure do |config|
        config.protocol = 'https'
        config.mode = 'driving'
        config.avoid = 'tolls'
        config.google_api_key = google_map_api_key
      end

      minimum_distance_route = google_distance_matrix.data.flatten.min { |r1, r2| r1.distance_in_meters <=> r2.distance_in_meters }

      Groute::Route.new(
        minimum_distance_route.duration_in_seconds / 60.0,
        Groute::Meter.new(minimum_distance_route.distance_in_meters)
      )
    end

    private

    attr_reader :hexagonal, :origin, :destination

    # @return [GoogleDistanceMatrix::Matrix]
    def google_distance_matrix
      @google_distance_matrix ||= ::GoogleDistanceMatrix::Matrix.new
    end

    # @return [GoogleDistanceMatrix::Place]
    def origin_matrix_place
      GoogleDistanceMatrix::Place.new lng: origin.longitude, lat: origin.latitude
    end

    # @return [GoogleDistanceMatrix::Place]
    def destination_matrix_place
      GoogleDistanceMatrix::Place.new lng: destination.longitude, lat: destination.latitude
    end

    def fill_distance_matrix_origins
      google_distance_matrix.origins << origin_matrix_place
      return unless hexagonal

      origin_hexagonal_positions.each do |p|
        google_distance_matrix.origins << p
      end
    end

    def fill_distance_matrix_destinations
      google_distance_matrix.destinations << destination_matrix_place
      return unless hexagonal

      destination_hexagonal_positions.each do |p|
        google_distance_matrix.destinations << p
      end
    end

    # @return [String]
    def google_map_api_key
      Groute.config.google_map_api_key
    end

    # 出発地の周辺6点
    # @return [Array<GoogleDistanceMatrix::Place>]
    def origin_hexagonal_positions
      @origin_hexagonal_positions ||= hexagonal_positions(origin)
    end

    # 目的地の周辺6点
    # @return [Array<GoogleDistanceMatrix::Place>]
    def destination_hexagonal_positions
      @destination_hexagonal_positions ||= hexagonal_positions(destination)
    end

    # 与えられた地点の周辺6箇所の地点を返す
    # @param [Groute::LatLng]
    # @return [Array<GoogleDistanceMatrix::Place>]
    def hexagonal_positions(latlng)
      HexagonalExpander.new(latlng).expand
    end
  end
end
