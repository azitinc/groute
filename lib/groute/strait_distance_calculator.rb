# frozen_string_literal: true

module Groute
  # 2地点間の地球上での直線距離を計算する
  class StraitDistanceCalculator
    # 地球の赤道半径
    EARTH_EQUATORIAL_RADIUS_METER = 6_378_137.0
    # 地球の極半径
    EARTH_POLAR_RADIUS_METER = 6_356_752.314140
    private_constant :EARTH_EQUATORIAL_RADIUS_METER, :EARTH_POLAR_RADIUS_METER

    # ヒュベニの公式にもとづいて距離をもとめる
    # @param [Groute::LatLng] from
    # @param [Groute::LatLng] to
    # @return [Groute::Distance]
    def distance(from:, to:)
      @from = from
      @to = to
      meter = Math.sqrt(
        (latitude_radian_difference * meridian_radius_curvature)**2 +
          (longitude_radian_difference * prime_vertical_radius * Math.cos(latitude_radian_average))**2
      )
      Groute::Distance.new(meter)
    end

    private

    attr_reader :from, :to

    def latitude_radian_difference
      from.latitude_radian - to.latitude_radian
    end

    def longitude_radian_difference
      from.longitude_radian - to.longitude_radian
    end

    def latitude_radian_average
      (from.latitude_radian + to.latitude_radian) / 2.0
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
