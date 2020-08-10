# frozen_string_literal: true

module Groute
  # 距離を表現するValue Object、単位はメートルとする
  class Distance
    # @return [Float]
    attr_reader :value

    # @param [Float] value 距離(メートル)
    def initialize(value)
      @value = value
    end

    def ==(other)
      self.class == other.class && value == other.value
    end

    alias eql? ==
  end
end
