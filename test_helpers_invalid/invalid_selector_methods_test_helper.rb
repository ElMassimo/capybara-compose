# frozen_string_literal: true

class InvalidSelectorMethodsTestHelper < Capybara::TestHelper
  SELECTORS = {
    source: '.main',
  }.freeze
end
