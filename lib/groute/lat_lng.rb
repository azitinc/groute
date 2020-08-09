module Groute
  # 緯度経度で表現される位置情報を表すValue Object
  class LatLng
    # @return [Float] 緯度
    attr_reader :latitude
    # @return [Float] 経度
    attr_reader :longitude

    # @param [Float] latitude 緯度
    # @param [Float] longitude 経度
    def initialize(latitude, longitude)
      @latitude = latitude
      @longitude = longitude
    end

    def ==(other)
      self.class == other.class && latitude == other.latitude && longitude == other.longitude
    end

    alias eql? ==
  end
end