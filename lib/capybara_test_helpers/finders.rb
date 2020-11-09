# frozen_string_literal: true

# Internal: Wraps Capybara finders to be aware of the selector aliases, and to
# auto-wrap the returned elements with test helpers.
module CapybaraTestHelpers::Finders
  %i[
    find
    find_all
    find_field
    find_link
    find_button
    find_by_id
    first
    ancestor
    sibling
  ].each do |method_name|
    CapybaraTestHelpers.define_helper_method(self, method_name, wrap: true)
  end

  # Public: Returns all the Capybara nodes that match the specified selector.
  #
  # Returns an Array of Capybara::Element that match the query.
  def all(*args, **kwargs, &filter)
    if defined?(::RSpec::Matchers::BuiltIn::All) && args.first.respond_to?(:matches?)
      ::RSpec::Matchers::BuiltIn::All.new(*args, **kwargs)
    else
      find_all(*args, **kwargs, &filter)
    end
  end

private

  # Internal: Finds an element that matches the specified locator and options.
  #
  # Returns a Capybara::Node::Element that matches the conditions, or fails.
  def find_element(*args, **kwargs, &filter)
    kwargs[:test_helper] = self
    current_context.find(*args, **kwargs, &filter)
  end
end
