module Groute
  # 距離を表現するValue Object、単位は常にキロメートルとする
  class Distance
    # @return [Float]
    attr_reader :distance

    # @param [Float] distance
    def initialize(distance)
      @distance = distance
    end

    def ==(other)
      self.class == other.class && distance == other.distance
    end

    alias eql? ==
  end
end