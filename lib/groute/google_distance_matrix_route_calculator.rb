# frozen_string_literal: true
require 'google_distance_matrix'

module Groute
  # 2地点間の距離をGoogle Distance Matrix APIを利用して計算する
  class GoogleDistanceMatrixRouteCalculator
    EARTH_RADIUS_KILO_METER = 6378
    private_constant :EARTH_RADIUS_KILO_METER

    # @param [Boolean] hexagonal 周辺6点に展開するかどうか
    def initialize(hexagonal: false)
      @hexagonal = hexagonal
    end

    # Google Distance Matrix APIを利用してルートを計算
    # @param [Groute::LatLng] from
    # @param [Groute::LatLng] to
    # @return [Groute::Route]
    def route(from:, to:)
      @from = from
      @to = to

      fill_distance_matrix_origins
      fill_distance_matrix_destinations

      google_distance_matrix.configure do |config|
        config.protocol = 'https'
        config.mode = 'driving'
        config.avoid = 'tolls'
        config.google_api_key = google_map_api_key
      end

      minimum_distance_route = google_distance_matrix.data.flatten.min do |r1, r2|
        r1.distance_in_meters <=> r2.distance_in_meters
      end

      Groute::Route.new(
        duration: Groute::Minutes.new(minimum_distance_route.duration_in_seconds / 60.0),
        distance: Groute::Meter.new(minimum_distance_route.distance_in_meters)
      )
    end

    private

    attr_reader :hexagonal, :from, :to

    # @return [GoogleDistanceMatrix::Matrix]
    def google_distance_matrix
      @google_distance_matrix ||= ::GoogleDistanceMatrix::Matrix.new
    end

    # @return [GoogleDistanceMatrix::Place]
    def from_matrix_place
      GoogleDistanceMatrix::Place.new lng: from.longitude, lat: from.latitude
    end

    # @return [GoogleDistanceMatrix::Place]
    def to_matrix_place
      GoogleDistanceMatrix::Place.new lng: to.longitude, lat: to.latitude
    end

    def fill_distance_matrix_origins
      google_distance_matrix.origins << from_matrix_place
      return unless hexagonal

      from_hexagonal_positions.each do |p|
        google_distance_matrix.origins << p
      end
    end

    def fill_distance_matrix_destinations
      google_distance_matrix.destinations << to_matrix_place
      return unless hexagonal

      to_hexagonal_positions.each do |p|
        google_distance_matrix.destinations << p
      end
    end

    # @return [String]
    def google_map_api_key
      Groute.config.google_map_api_key
    end

    # 出発地の周辺6点
    # @return [Array<GoogleDistanceMatrix::Place>]
    def from_hexagonal_positions
      @from_hexagonal_positions ||= hexagonal_positions(from)
    end

    # 目的地の周辺6点
    # @return [Array<GoogleDistanceMatrix::Place>]
    def to_hexagonal_positions
      @to_hexagonal_positions ||= hexagonal_positions(to)
    end

    # 与えられた地点の周辺6箇所の地点を返す
    # @param [Groute::LatLng]
    # @return [Array<GoogleDistanceMatrix::Place>]
    def hexagonal_positions(latlng)
      HexagonalExpander.new(latlng).expand
    end
  end
end
