# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in capybara-compose.gemspec
gemspec

gem 'rake', '~> 12.0'

group :development, :test do
  gem 'pry-byebug'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
  gem 'rubocop'
end

group :test do
  gem 'cuprite'
  gem 'rspec', '~> 3.0'
  gem 'selenium-webdriver', '~> 3'
  gem 'simplecov', '< 0.18'
  gem 'webdrivers'

  # Test delegation to built-in matchers
  gem 'rspec-collection_matchers'

  # Generator
  gem 'generator_spec', require: false
  gem 'rails', require: false
  gem 'rspec-rails', require: false

  # Sample App
  gem 'launchy'
  gem 'puma'
  gem 'sinatra'
  gem 'tilt'
  gem 'yaml'

  # Benchmarks
  gem 'amazing_print'
  gem 'rainbow'
end
