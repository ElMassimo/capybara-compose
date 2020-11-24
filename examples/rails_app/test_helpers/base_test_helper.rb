# frozen_string_literal: true

require 'capybara_test_helpers/benchmark_helpers'
require 'pry-rescue/rspec' unless ENV['CI']

class BaseTestHelper < Capybara::TestHelper
  include CapybaraTestHelpers::BenchmarkHelpers

  # Internal: These are used on most test helpers.
  use_test_helpers(:current_page, :routes)

# Aliases: Semantic aliases for locators, can be used in most DSL methods.
  # Avoid defining :el here since it will be inherited by all helpers.

# Finders: A convenient way to get related data or nested elements.

# Actions: Encapsulate complex actions to provide a cleaner interface.
  # Public: Allows to visit the page that matches the test helper name, as
  # defined in routes helper.
  #
  # NOTE: This is just an example to show how you may organize routes, and
  # create simple conventions to streamline your tests.
  def visit_page
    routes.visit_page(friendly_name.to_sym)
  end

# Assertions: Check on element properties, used with `should` and `should_not`.

# Background: Helpers to add/modify/delete data in the database or session.
end
