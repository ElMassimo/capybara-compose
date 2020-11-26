# frozen_string_literal: true

require 'capybara/rspec'

require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/object/blank'

require 'capybara_test_helpers/selectors'
require 'capybara_test_helpers/synchronization'
require 'capybara_test_helpers/finders'
require 'capybara_test_helpers/actions'
require 'capybara_test_helpers/assertions'
require 'capybara_test_helpers/matchers'

# Public: Base class to create test helpers that have full access to the
# Capybara DSL, while easily defining custom assertions, getters, and actions.
#
# It also supports locator aliases to prevent duplication and keep tests easier
# to understand and to maintain.
class CapybaraTestHelpers::TestHelper
  include RSpec::Matchers
  include RSpec::Mocks::ExampleMethods
  include Capybara::DSL
  include CapybaraTestHelpers::Selectors
  include CapybaraTestHelpers::Synchronization
  include CapybaraTestHelpers::Finders
  include CapybaraTestHelpers::Actions
  include CapybaraTestHelpers::Assertions
  include CapybaraTestHelpers::Matchers

  undef_method(*CapybaraTestHelpers::SKIPPED_DSL_METHODS)

  attr_reader :query_context, :test_context

  def initialize(query_context, test_context: query_context, negated: nil)
    @query_context, @test_context, @negated = query_context, test_context, negated
  end

  # Public: To make the benchmark log less verbose.
  def inspect
    %(#<#{ self.class.name } #{ current_element? ? %(tag="#{ base.tag_name }") : object_id }>)
  rescue *page.driver.invalid_element_errors
    %(#<#{ self.class.name } #{ object_id }>)
  end

  # Public: Makes it easier to inspect the current element.
  def inspect_node
    to_capybara_node.inspect
  end

  # Public: Casts the current context as a Capybara::Node::Element.
  #
  # NOTE: Uses the :el convention, which means actions can be performed directly
  # on the test helper if an :el selector is defined.
  def to_capybara_node
    return current_context if current_element?
    return find_element(:el) if selectors.key?(:el)

    raise_missing_element_error
  end

  # Public: Wraps a Capybara::Node::Element or test helper with a test helper
  # object of this class.
  def wrap_element(element)
    if element.is_a?(Enumerable)
      element.map { |node| wrap_element(node) }
    else
      raise ArgumentError, "#{ element.inspect } must be a test helper or element." unless element.respond_to?(:to_capybara_node)

      self.class.new(element.to_capybara_node, test_context: test_context)
    end
  end

  # Public: Scopes the Capybara queries in the block to be inside the specified
  # selector.
  def within_element(*args, **kwargs, &block)
    locator = args.empty? ? [self] : args
    kwargs[:test_helper] = self
    page.within(*locator, **kwargs, &block)
  end

  # Public: Scopes the Capybara queries in the block to be inside the specified
  # selector.
  def within(*args, **kwargs, &block)
    return be_within(*args, **kwargs) unless block_given? # RSpec matcher.

    within_element(*args, **kwargs, &block)
  end

  # Public: Unscopes the inner block from any previous `within` calls.
  def within_document
    page.instance_exec { scopes << nil }
    yield wrap_element(page.document)
  ensure
    page.instance_exec { scopes.pop }
  end

  # Internal: Returns the name of the class without the suffix.
  #
  # Example: 'current_page' for CurrentPageTestHelper.
  def friendly_name
    self.class.name.chomp('TestHelper').underscore
  end

protected

  # Internal: Used to perform assertions and others.
  def current_context
    query_context.respond_to?(:to_capybara_node) ? query_context : page
  end

  # Internal: Returns true if the current context is an element.
  def current_element?
    current_context.is_a?(Capybara::Node::Element)
  end

private

  # Internal: Wraps the optional filter block to ensure we pass it a test helper
  # instead of a raw Capybara::Node::Element.
  def wrap_filter(filter)
    proc { |capybara_node_element| filter.call(wrap_element(capybara_node_element)) } if filter
  end

  # Internal: Helper to provide more information on the error.
  def raise_missing_element_error
    method_caller = caller.select { |x| x['test_helpers'] }[1]
    method_caller_name = method_caller&.match(/in `(\w+)'/)
    method_caller_name = method_caller_name ? method_caller_name[1] : method_caller
    raise ArgumentError, "You are calling the `#{ method_caller_name }' method on the test helper but :el is not defined nor there's a current element.\n"\
    'Define :el, or find an element before performing the action.'
  end

  class << self
    # Public: Make methods in the test context available in the helpers.
    def delegate_to_test_context(*method_names)
      delegate(*method_names, to: :test_context)
    end

    # Public: Allows to make other test helpers available.
    #
    # NOTE: When you call a helper the "negated" state is preserved for assertions.
    #
    # NOTE: You can also pass an element to a test helper to "wrap" a specified
    # element with the specified test helper class.
    #
    # Example:
    #   dropdown(element).toggle_menu
    def use_test_helpers(*helper_names)
      helper_names.each do |helper_name|
        private define_method(helper_name) { |element = nil|
          test_helper = test_context.get_test_helper(helper_name)
          test_helper = test_helper.wrap_element(element) if element
          @negated.nil? ? test_helper : test_helper.should(@negated)
        }
      end
    end

    # Internal: Allows to perform certain actions just before a test helper will
    # be loaded for the first time.
    def on_test_helper_load
      define_getters_for_selectors
    end

    # Internal: Fail early if a reserved method is redefined.
    def method_added(method_name)
      return unless CapybaraTestHelpers::RESERVED_METHODS.include?(method_name)

      raise "A method with the name #{ method_name.inspect } is part of the Capybara DSL," \
        ' overriding it could cause unexpected issues that could be very hard to debug.'
    end
  end
end

Capybara::TestHelper = CapybaraTestHelpers::TestHelper unless defined?(Capybara::TestHelper)
