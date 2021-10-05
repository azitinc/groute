# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in groute.gemspec
gemspec

gem 'rake', '~> 12.0'
gem 'rspec', '~> 3.0'
gem 'rubocop', '~> 0.89.0', require: false

group :development do
  gem 'yard'
end

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem "debug", ">= 1.0.0"
end
