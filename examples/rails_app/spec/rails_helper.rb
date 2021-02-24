# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'

# Make test helpers available in system specs.
require 'capybara/compose/rspec'
require Rails.root.join('test_helpers/base_test_helper')

Dir[Rails.root.join('spec/system/support/**/*.rb')].sort.each { |f| require f }

RSpec.configure do |config|
  config.fixture_path = "#{ ::Rails.root }/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.before(:each, type: :system) {
    args = %w[headless disable-gpu disable-infobars no-sandbox disable-dev-shm-usage]
    driven_by :selenium, using: :chrome, options: { args: args }
  }

  # Make the default helpers available in all files.
  config.include(DefaultTestHelpers, type: :system)
end

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => error
  puts error.to_s.strip
  exit 1
end
