# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in capybara_test_helpers.gemspec
gemspec

gem 'rake', '~> 12.0'

group :development do
  gem 'pry-byebug'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
  gem 'rubocop'
end

group :test do
  gem 'rspec', '~> 3.0'
  gem 'selenium-webdriver', '~> 3'
  gem 'cuprite'
  gem 'simplecov', '< 0.18'
  gem 'webdrivers'

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
