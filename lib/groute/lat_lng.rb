# frozen_string_literal: true

module Groute
  # 緯度経度で表現される位置情報を表すValue Object
  class LatLng
    # @return [Float] 緯度のdegree
    attr_reader :latitude
    # @return [Float] 経度のdegree
    attr_reader :longitude

    # @param [Float] latitude 緯度のdegree
    # @param [Float] longitude 経度のdegree
    def initialize(latitude, longitude)
      @latitude = latitude
      @longitude = longitude
    end

    def ==(other)
      self.class == other.class && latitude == other.latitude && longitude == other.longitude
    end

    alias eql? ==

    # @return [Float] 緯度のradian
    def latitude_radian
      deg_to_rad(latitude)
    end

    # @return [Float] 経度のradian
    def longitude_radian
      deg_to_rad(longitude)
    end

    private

    # degree を radian に変換する
    def deg_to_rad(degree)
      degree * Math::PI / 180
    end
  end
end
