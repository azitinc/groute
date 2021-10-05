# frozen_string_literal: true

module Groute
  # 移動時間を表現するValue Object、単位は分とする
  class Minutes
    # @return [Float]
    attr_reader :value

    # @param [Float] value
    def initialize(value)
      @value = value
    end

    def ==(other)
      self.class == other.class && value == other.value
    end

    alias eql? ==
  end
end
