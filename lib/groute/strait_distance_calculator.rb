# frozen_string_literal: true

module Groute
  # 2地点間の地球上での直線距離を計算する
  class StraitDistanceCalculator
    # 地球の赤道半径
    EARTH_EQUATORIAL_RADIUS_METER = 6_378_137.0
    # 地球の極半径
    EARTH_POLAR_RADIUS_METER = 6_356_752.314140
    private_constant :EARTH_EQUATORIAL_RADIUS_METER, :EARTH_POLAR_RADIUS_METER

    class << self
      # @param [Groute::LatLng] origin
      # @param [Groute::LatLng] destination
      # @return [Groute::StraitDistance]
      def call(origin, destination)
        new(origin, destination).strait_distance
      end
    end

    private_class_method :new

    def initialize(origin, destination)
      @origin = origin
      @destination = destination
    end

    # ヒュベニの公式にもとづいて距離をもとめる
    # @return [Groute::Distance]
    def strait_distance
      meter = Math.sqrt(
        (latitude_radian_difference * meridian_radius_curvature)**2 +
          (longitude_radian_difference * prime_vertical_radius * Math.cos(latitude_radian_average))**2
      )
      Groute::Distance.new(meter)
    end

    private

    attr_reader :origin, :destination

    def latitude_radian_difference
      origin.latitude_radian - destination.latitude_radian
    end

    def longitude_radian_difference
      origin.longitude_radian - destination.longitude_radian
    end

    def latitude_radian_average
      (origin.latitude_radian + destination.latitude_radian) / 2.0
    end

    def earth_eccentricity
      Math.sqrt(
        (EARTH_EQUATORIAL_RADIUS_METER**2 - EARTH_POLAR_RADIUS_METER**2) / (EARTH_EQUATORIAL_RADIUS_METER**2).to_f
      )
    end

    # 卯酉線曲線半径
    def prime_vertical_radius
      EARTH_EQUATORIAL_RADIUS_METER / w
    end

    def w
      Math.sqrt(
        1.0 - earth_eccentricity**2 * Math.sin(latitude_radian_average)**2
      )
    end

    # 子午線曲率半径
    def meridian_radius_curvature
      (EARTH_EQUATORIAL_RADIUS_METER * (1.0 - earth_eccentricity**2)) / (w**3)
    end
  end
end
