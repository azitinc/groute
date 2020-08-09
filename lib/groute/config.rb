module Groute
  class Config
    attr_accessor :google_map_api_key

    def initialize
      @google_map_api_key = nil
    end
  end
end
