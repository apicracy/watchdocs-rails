# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'watchdocs/rails/version'

Gem::Specification.new do |spec|
  spec.name          = 'watchdocs-rails'
  spec.version       = Watchdocs::Rails::VERSION
  spec.authors       = ['mazikwyry']
  spec.email         = ['a.mazur@exlabs.co.uk']
  spec.licenses      = ['MIT']

  spec.summary       = 'Rails Rack-Middleware for capturing JSON requests
                        and responses details'
  spec.description   = 'It captures every JSON response, stores request and
                        response details in temporary storage.
                        Provides methods to send recorded calls to Watchdocs
                        which checks them against the documentation or create
                        docs for new calls.'
  spec.homepage      = 'http://watchdocs.io'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_runtime_dependency 'httparty', '~> 0.14.0'
  spec.add_runtime_dependency 'configurations', '~> 2.2', '>= 2.2.0'
  spec.add_runtime_dependency 'activesupport', '~> 4.2', '>= 4.2.8'
  spec.add_runtime_dependency 'recurrent', '~> 0.4', '>= 0.4.3'
end
