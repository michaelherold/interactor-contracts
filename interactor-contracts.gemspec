# frozen_string_literal: true

require File.expand_path('lib/interactor/contracts/version', __dir__)

Gem::Specification.new do |spec|
  spec.name    = 'interactor-contracts'
  spec.version = Interactor::Contracts::VERSION
  spec.authors = ['Michael Herold']
  spec.email   = ['opensource@michaeljherold.com']

  spec.summary     = 'Add contracts to your interactors'
  spec.description = <<~DESC
    Interactors are a pattern for structuring your business logic into units.
    They have a flexible context that they pass between them, which makes them
    easy-to-write, but hard-to-understand after you've written them. Much of
    this confusion comes from not knowing what the interactor is supposed to
    take as input and what it's expected to produce.

    Enter contracts. Contracts allow you define, up front, a contract both for
    the input of an interactor, known as expectations, and the output of it,
    known as promises. Additionally, you can define a handler for what happens
    when an interactor violates its contracts, known as a breach.

    Declaring these contracts can help define your interface and make it easier
    to understand how to use an interactor. They form both documentation and
    validation for your business logic.
  DESC
  spec.homepage    = 'https://github.com/michaelherold/interactor-contracts'
  spec.license     = 'MIT'

  spec.files = %w[CHANGELOG.md CONTRIBUTING.md LICENSE.md README.md]
  spec.files += %w[interactor-contracts.gemspec]
  spec.files += Dir['lib/**/*.rb']
  spec.require_paths = ['lib']

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/michaelherold/interactor-contracts/issues',
    'changelog_uri' => 'https://github.com/michaelherold/interactor-contracts/blob/master/CHANGELOG.md',
    'documentation_uri' => 'https://www.rubydoc.info/gems/interactor-contracts',
    'source_code_uri' => 'https://github.com/michaelherold/interactor-contracts'
  }

  spec.add_dependency 'dry-validation', '~> 1.0'
  spec.add_dependency 'interactor', '~> 3'

  spec.add_development_dependency 'bundler', '> 1.11'
end
