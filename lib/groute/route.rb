# frozen_string_literal: true

module Groute
  # 移動時間と、移動距離で表現される経路
  class Route
    # @return [Groute::Minutes] 移動時間(分)
    attr_reader :duration
    # @return [Groute::Meter] 距離
    attr_reader :distance

    # @return [Array<Groute::SubRoute>] 各地点の間のルート
    attr_reader :sub_routes

    # @param [Groute::Minutes] duration 移動時間 (分)
    # @param [Groute::Meter] distance 距離
    def initialize(duration:, distance:, sub_routes: [])
      @duration = duration
      @distance = distance
      @sub_routes = sub_routes
    end

    def ==(other)
      self.class == other.class && \
        duration == other.duration && \
        distance == other.distance && \
        sub_routes == other.sub_routes
    end

    alias eql? ==
  end
end
