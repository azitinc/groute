# frozen_string_literal: true

require 'groute/version'
require 'groute/lat_lng'
require 'groute/distance'
require 'groute/strait_distance_calculator'
require 'groute/route'
require 'groute/config'

module Groute
  def self.config
    @config ||= Groute::Config.new
  end

  def self.configure(&_block)
    yield(config) if block_given?
  end
end
