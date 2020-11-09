# frozen_string_literal: true

require 'capybara_test_helpers/benchmark_helpers'
require 'pry-rescue/rspec' unless ENV['CI']

# Public: Provides the basic functionality to create simple test helpers.
class BaseTestHelper < Capybara::TestHelper
  include BenchmarkHelpers

  # Internal: These are used on most test helpers.
  use_test_helpers(:current_page, :routes)

  # Internal: Make debug available inside test helpers:
  use_test_helpers(:debug) unless ENV['CI']

  # Example: Accessing a method that is included in RSpec.
  delegate_to_test_context(:support_file_path)

# Selectors: Semantic aliases for elements, a very useful abstraction.
  SELECTORS = {
  }.freeze

# Getters: A convenient way to get related data or nested elements.
  # Public: A helper to retrieve the nth element that matches the selector.
  protected \
  def find_by_index(selector_alias, index:, **options)
    all(selector_alias, minimum: index + 1, **options)[index]
  end

  # Public: Returns the HTML id of the element.
  def id
    self[:id]
  end

# Actions: Encapsulate complex actions to provide a cleaner interface.
  # Public: Allows to visit the page that matches the test helper name, as
  # defined in routes helper.
  #
  # NOTE: This is just an example to show how you may organize routes, and
  # create simple conventions to streamline your tests.
  def visit_page
    routes.visit_page(friendly_name.to_sym)
  end

# Assertions: Allow to check on element properties while keeping it DRY.
  def be_visible
    synchronize_expectation { expect(visible?).to eq(!not_to), "expected #{ inspect_node } #{ 'not ' if not_to }to be visible" }
    self
  end

  def be_obscured
    synchronize_expectation { expect(obscured?).to eq(!not_to), "expected #{ inspect_node } #{ 'not ' if not_to }to be obscured" }
    self
  end

  # Public: Allows to verify the id for the current element.
  def have_id(id)
    synchronize_expectation { expect(self[:id]).to_or not_to, eq(id) }
    self
  end

# Background: Helpers to add/modify/delete data in the database or session.
end
