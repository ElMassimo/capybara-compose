# frozen_string_literal: true

require 'capybara_test_helpers/benchmark_helpers'
require 'pry-rescue/rspec' unless ENV['CI']

class BaseTestHelper < Capybara::TestHelper
  include CapybaraTestHelpers::BenchmarkHelpers

  # Internal: These are used on most test helpers.
  use_test_helpers(:current_page, :navigation)

# Aliases: Semantic aliases for locators, can be used in most DSL methods.
  # Avoid defining :el here since it will be inherited by all helpers.

# Finders: A convenient way to get related data or nested elements.

# Actions: Encapsulate complex actions to provide a cleaner interface.
  # Public: Allows to visit the page that matches the test helper name, as
  # defined in the navigation helper.
  #
  # NOTE: This is just an example to show how you may organize routes, and
  # create simple conventions to streamline your tests.
  def visit_page
    navigation.visit_page(friendly_name.to_sym)
  end

  def delayed_value(delay: 0.1)
    # Since we are passing only one argument (delay), the second argument will
    # be the callback that will capture the value.
    evaluate_async_script(<<~JS, delay)
      const delay = arguments[0]
      const callback = arguments[1]
      setTimeout(() => callback(this.value), delay)
    JS
  end

# Assertions: Check on element properties, used with `should` and `should_not`.

# Background: Helpers to add/modify/delete data in the database or session.
end
