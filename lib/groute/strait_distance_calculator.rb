module Groute
  class StraitDistanceCalculator
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

    # @return [Groute::Distance]
    def strait_distance
      Distance.new(0)
    end

    private

    attr_reader :origin, :destination
  end
end