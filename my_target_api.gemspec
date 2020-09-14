# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'my_target_api/version'

Gem::Specification.new do |spec|
  spec.name          = 'my_target_api'
  spec.version       = MyTargetApi::VERSION
  spec.authors       = ['OneRetarget.com']
  spec.email         = ['help@oneretarget.com']
  spec.summary       = 'Ruby client for myTarget API'
  spec.description   = <<~DESC
    Ruby client for myTarget API.
    It takes care of JSON parsing, file parameters, nested resources, api versions.
    OneRetarget.com - advertising automation service
  DESC
  spec.homepage      = 'https://github.com/resivalex/my_target_api'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.4.0'

  spec.files         = Dir['**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'json', '~> 2.0', '>= 2.0.0'
  spec.add_runtime_dependency 'rest-client', '~> 2.0', '>= 2.0.0'

  spec.add_development_dependency 'bundler', '~> 2.1', '>= 2.1.4'
  spec.add_development_dependency 'rake', '~> 12.3.0', '>= 12.3.0'
  spec.add_development_dependency 'rspec', '~> 3.7.0', '>= 3.7.0'
  spec.add_development_dependency 'rubocop', '~> 0.89.1'
  spec.add_development_dependency 'webmock', '~> 2.3.2', '>= 2.3.2'
end
