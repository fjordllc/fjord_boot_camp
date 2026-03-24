# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fjord_boot_camp/version'

Gem::Specification.new do |spec|
  spec.name          = 'fjord_boot_camp'
  spec.version       = FjordBootCamp::VERSION
  spec.authors       = ['komagata']
  spec.email         = ['komagata@gmail.com']

  spec.summary       = 'Ruby client for FJORD BOOT CAMP API'
  spec.description   = 'A Ruby gem to interact with the FJORD BOOT CAMP API. Provides both a library and CLI for accessing reports, users, practices, and trainee progress data.'
  spec.homepage      = 'https://github.com/fjordllc/fjord_boot_camp'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/fjordllc/fjord_boot_camp'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = ['fjord_boot_camp']
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '>= 1.0', '< 3.0'
  spec.add_dependency 'thor', '~> 1.0'

  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rubocop', '~> 1.0'
  spec.add_development_dependency 'rubocop-minitest', '~> 0.36'
  spec.add_development_dependency 'webmock', '~> 3.0'
end
