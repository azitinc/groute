# frozen_string_literal: true

require_relative 'lib/groute/version'

Gem::Specification.new do |spec|
  spec.name          = 'groute'
  spec.version       = Groute::VERSION
  spec.authors       = ['Pocket7878']
  spec.email         = ['poketo7878@gmail.com']

  spec.summary       = 'Google Directions および Google Distance Matrix APIを利用して二つの地点の間のルートや距離の計算をするためのライブラリ'
  spec.description   = 'Google Directions および Google Distance Matrix APIを利用して二つの地点の間のルートや距離の計算をするためのライブラリ'
  spec.homepage      = 'https://github.com/azitinc/groute'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/azitinc/groute'
  spec.metadata['changelog_uri'] = 'https://github.com/azitinc/groute'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Dependencies
  spec.add_dependency 'google_directions'
  spec.add_dependency 'google_distance_matrix', '~> 0.2.0'
end
