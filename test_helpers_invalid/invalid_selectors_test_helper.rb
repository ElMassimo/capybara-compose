# frozen_string_literal: true

class InvalidSelectorsTestHelper < Capybara::TestHelper
  SELECTORS = {
    button: '.button',
    link: '.link',
  }.freeze
end
