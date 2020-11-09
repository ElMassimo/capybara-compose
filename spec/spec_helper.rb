# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start {
  add_filter '/spec/'
  add_filter '/test_helpers/'
}

require 'bundler/setup'
require 'rspec/expectations'

require 'pry-byebug'

require 'rspec/expectations'
require 'capybara'
require 'capybara/rspec'
require 'capybara/spec/spec_helper'
require 'capybara_test_helpers/rspec'

Dir[File.expand_path('spec/support/**/*.rb')].sort.each { |f| require f }

require File.expand_path('test_helpers/base_test_helper.rb')

RSpec.configure do |config|
  Capybara::SpecHelper.configure(config)
  # Avoid the reset in Capybara::SpecHelper
  config.before(:each) { Capybara.default_selector = :css }
  config.after(:each) { Capybara.default_selector = :css }

  # Example: Include commonly used test helpers by default on every feature spec.
  config.include(DefaultTestHelpers, type: :feature)

  config.include(SupportFileHelpers)

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
