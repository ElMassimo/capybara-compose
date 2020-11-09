# frozen_string_literal: true

class ScopesPageTestHelper < BaseTestHelper
  use_test_helpers(:results)

# Selectors: Semantic aliases for elements, a very useful abstraction.
  SELECTORS = {
    first_section: '#for_foo',
    main_section: '#for_bar',
    list_item: [:main_section, ' li'],
    first_item: [:list_item, ':first-child'],
  }.freeze

# Getters: A convenient way to get related data or nested elements.
  # Internal: Test exceptions when :el is not defined, and fallback to `page` so
  # that it can leverage `have_content`.
  def to_capybara_node
    super
  rescue StandardError
    page
  end

# Actions: Encapsulate complex actions to provide a cleaner interface.

# Assertions: Allow to check on element properties while keeping it DRY.
  delegate :have_results, to: :results

# Background: Helpers to add/modify/delete data in the database or session.
end
