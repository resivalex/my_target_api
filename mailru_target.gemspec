# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mailru_target/version'

Gem::Specification.new do |spec|
  spec.name          = 'mailru_target'
  spec.version       = MailruTarget::VERSION
  spec.authors       = ['Eugeniy Belyaev']
  spec.email         = ['eugeniy.b@garin-studio.ru']
  spec.summary       = 'Target.Mail.ru api via oauth2'
  spec.description   = 'Target.Mail.ru api via oauth2'
  spec.homepage      = 'https://github.com/zhekanax/mailru_target'
  spec.license       = 'MIT'

  spec.files         = Dir['**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rest-client'
  spec.add_dependency 'json'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
end
