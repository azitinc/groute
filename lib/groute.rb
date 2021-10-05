# frozen_string_literal: true

require 'groute/version'
require 'groute/lat_lng'
require 'groute/meter'
require 'groute/strait_distance_calculator'
require 'groute/google_directions_distance_calculator'
require 'groute/google_directions_distance_calculator/api_status_not_ok_error'
require 'groute/route'
require 'groute/google_distance_matrix_distance_calculator'
require 'groute/google_distance_matrix_distance_calculator/hexagonal_expander'
require 'groute/config'

module Groute
  # @return [Groute::Config] 現在の設定値
  def self.config
    @config ||= Groute::Config.new
  end

  # @example ブロックをつかって設定値を更新する
  #   Groute.configure do |conf|
  #     conf.google_map_api_key = "<YOUR GOOGLE MAP API KEY HERE>"
  #   end
  def self.configure(&_block)
    yield(config) if block_given?
  end
end
