# frozen_string_literal: true

module Groute
  # 移動時間と、移動距離で表現される経路
  class Route
    # @return [Groute::Minutes] 移動時間(分)
    attr_reader :duration
    # @return [Groute::Meter] 距離
    attr_reader :distance

    # @param [Groute::Minutes] duration 移動時間 (分)
    # @param [Groute::Meter] distance 距離
    def initialize(duration:, distance:)
      @duration = duration
      @distance = distance
    end

    def ==(other)
      self.class == other.class && duration == other.duration && distance == other.distance
    end

    alias eql? ==
  end
end
