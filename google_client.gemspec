# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'google_client/version'

Gem::Specification.new do |spec|
  spec.name          = 'google_client'
  spec.version       = GoogleClient::VERSION
  spec.authors       = ['Alexander Bradner']
  spec.email         = ['alex@bradner.net']
  spec.summary       = 'Handles a persistent Google::ApiClient in rails'
  spec.description   = 'This is totally a work in progress. Ask me if you want to use it so I can explain the traps'
  spec.homepage      = 'http://github.com/abradner/google_client'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'

  spec.add_runtime_dependency 'google-api-client', '~> 0.8'
  spec.add_development_dependency 'rubocop'
end
