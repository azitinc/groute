# frozen_string_literal: true

module Groute
  # 設定を管理する
  class Config
    # @return [String] Google Map API Key
    attr_accessor :google_map_api_key

    def initialize
      @google_map_api_key = nil
    end
  end
end
