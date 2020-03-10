# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

group :development do
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-inch'
  gem 'guard-rspec', '~> 4.6'
  gem 'guard-rubocop'
  gem 'guard-yard'
  gem 'inch'
  gem 'mutant-rspec'
  gem 'redcarpet'
  gem 'rubocop', '0.52.1'
  gem 'yard', '~> 0.9'
  gem 'yardstick'
end

group :development, :test do
  gem 'i18n'
  gem 'pry'
  gem 'rake', '>= 12.3.3'
end

group :test do
  gem 'danger-changelog', require: false
  gem 'danger-commit_lint', require: false
  gem 'danger-rubocop', require: false
  gem 'rspec', '~> 3.4'
  gem 'simplecov'
end
