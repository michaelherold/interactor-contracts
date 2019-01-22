# frozen_string_literal: true

require File.expand_path('../lib/interactor/contracts/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name    = 'interactor-contracts'
  spec.version = Interactor::Contracts::VERSION
  spec.authors = ['Michael Herold']
  spec.email   = ['michael.j.herold@gmail.com']

  spec.summary     = 'Add contacts to your interactors'
  spec.description = 'Add contacts to your interactors'
  spec.homepage    = 'https://github.com/michaelherold/interactor-contracts'
  spec.license     = 'MIT'

  spec.files = %w[CHANGELOG.md CONTRIBUTING.md LICENSE.md README.md]
  spec.files += %w[interactor-contracts.gemspec]
  spec.files += Dir['lib/**/*.rb']
  spec.require_paths = ['lib']

  spec.add_dependency 'dry-validation', '~> 0.10'
  spec.add_dependency 'interactor', '~> 3'

  spec.add_development_dependency 'bundler', '> 1.11'
end
