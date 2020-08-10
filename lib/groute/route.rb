# frozen_string_literal: true

module Groute
  # 移動時間と、移動距離で表現される経路
  class Route
    # @return [Float] 移動時間(分)
    attr_reader :minutes
    # @return [Groute::Distance] 距離
    attr_reader :distance

    # @param [Float] minutes 移動時間 (分)
    # @param [Groute::Distance] distance 距離
    def initialize(minutes, distance)
      @minutes = minutes
      @distance = distance
    end

    def ==(other)
      self.class == other.class && minutes == other.minutes && distance == other.distance
    end

    alias eql? ==
  end
end
