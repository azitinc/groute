# frozen_string_literal: true

RSpec.describe Groute do
  let!(:google_map_api_key) { "api_key" }

  it 'has a version number' do
    expect(Groute::VERSION).not_to be nil
  end

  it 'configureをつかって設定ができる' do
    Groute.configure do |conf|
      conf.google_map_api_key = google_map_api_key
    end

    expect(Groute.config.google_map_api_key).to eq google_map_api_key
  end
end
