# frozen_string_literal: true

module Groute
  class GoogleDistanceMatrixDistanceCalculator
    # 与えられた地点を周辺の6点に展開する
    class HexagonalExpander
      # @param [Groute::LatLng] latlng
      def initialize(latlng)
        @latlng = latlng
      end

      # @return [Array<GoogleDistanceMatrix::Place>]
      def expand
        results = []
        6.times do |i|
          results << GoogleDistanceMatrix::Place.new(
            lat: latlng.latitude + latitude_degree_diff_for_index(i),
            lng: latlng.longitude + longitude_degree_diff_for_index(i, latlng.latitude_radian)
          )
        end

        results
      end

      private

      attr_reader :latlng

      # 6角形に展開する半径
      # @return [Float]
      def hexagonal_radius_meter
        100
      end

      # degree を radian に変換する
      # @return [Float]
      def degree_to_radian(degree)
        degree * Math::PI / 180
      end

      # N番目の点の緯度方向の移動距離(km)
      # @return [Float]
      def latitude_distance_diff_for_index(idx)
        hexagonal_radius_meter * Math.sin(shift_radian_for_index(idx)) / 1000.0
      end

      # N番目の点の経度方向の移動距離(km)
      # @return [Float]
      def longitude_distance_diff_for_index(idx)
        hexagonal_radius_meter * Math.cos(shift_radian_for_index(idx)) / 1000.0
      end

      # N番目の点の緯度方向の移動距離 (度)
      # @return [Float]
      def latitude_degree_diff_for_index(idx)
        (latitude_distance_diff_for_index(idx) / EARTH_RADIUS_KILO_METER) * (180.0 / Math::PI)
      end

      # N番目の点の経度方向の移動距離 (度)
      # @param [Integer] idx
      # @param [Float] base_latlng_latitude_radian 中心点の緯度のラジアン
      # @return [Float]
      def longitude_degree_diff_for_index(idx, base_latlng_latitude_radian)
        (longitude_distance_diff_for_index(idx) / \
          EARTH_RADIUS_KILO_METER) * \
          (180.0 / Math::PI) * \
          Math.cos(base_latlng_latitude_radian)
      end

      # N番目の点のラジアン
      # @param [Integer] idx
      def shift_radian_for_index(idx)
        degree_to_radian(60 * idx)
      end
    end
  end
end
