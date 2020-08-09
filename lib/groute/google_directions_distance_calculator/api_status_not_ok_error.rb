# frozen_string_literal: true

module Groute
  class GoogleDirectionsDistanceCalculator
    # Google Directions APIをたたいた結果の `status` が `OK` ではなかった時に発生するエラー
    class ApiStatusNotOkError < StandardError
      # @return [String] Google Direction APIから返ってきたステータスの文字列
      attr_reader :status

      # @param [String] status
      def initialize(status)
        @status = status
        super("Google Directions API Response Status: #{status}")
      end
    end
  end
end
