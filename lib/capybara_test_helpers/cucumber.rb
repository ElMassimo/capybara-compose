# frozen_string_literal: true

require 'capybara_test_helpers'

World(CapybaraTestHelpers::DependencyInjection)

# Public: Use outside of the steps to make it available on all steps.
def use_test_helpers(*names)
  names.each do |name|
    define_method(name) { get_test_helper(name) }
  end
end
