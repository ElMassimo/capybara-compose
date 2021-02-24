# frozen_string_literal: true

require 'capybara/compose'
require 'capybara/rspec'

# Public: Use in an RSpec describe block or in an included module to make
# helpers available on all specs.
def use_test_helpers(*names)
  names.each do |name|
    let(name) { get_test_helper(name) }
  end
end

RSpec.configure do |config|
  # Make it available only in certain types of tests.
  types = %i[feature system view]

  # Options that will register a test helper for the test to use.
  keys = %i[capybara/compose test_helpers helpers]

  # Inject test helpers by using a :helpers or :test_helpers option.
  inject_test_helpers = proc { |example|
    keys.flat_map { |key| example.metadata[key] }.compact.each do |name|
      example.example_group_instance.define_singleton_method(name) { get_test_helper(name) }
    end
  }

  # Allow injecting test helpers in a feature or scenario.
  types.each do |type|
    config.include(Capybara::Compose::DependencyInjection, type: type)
    config.before(:each, type: type, &inject_test_helpers)
  end
end
