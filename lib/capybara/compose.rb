# frozen_string_literal: true

require 'capybara'

require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem
loader.tag = 'capybara-compose'
loader.ignore(
  File.expand_path("#{ __dir__ }/compose/rspec.rb"),
  File.expand_path("#{ __dir__ }/compose/cucumber.rb"),
  File.expand_path("#{ __dir__ }/compose/minitest.rb"),
)
loader.push_dir(__dir__, namespace: Capybara)
loader.setup

# Internal: Global configuration for the library.
module Capybara::Compose
  DEFAULT_CONFIGURATION = {
    helpers_paths: ['test_helpers'].freeze,
  }.freeze

  # Internal: Reserved methods for Capybara::TestHelper.
  test_helper_methods = [
    :page,
    :find_element,
    :should,
    :should_not,
    :not_to,
  ].freeze

  # Internal: Methods that are in the Capybara DSL but are so common that we
  # don't want to issue a warning if they are used as selectors.
  SKIPPED_DSL_METHODS = [
    :title,
    :body,
    :html,
  ].freeze

  # Internal: Methods that should not be overiden or used as locator aliases to
  # avoid confusion while working on test helpers.
  RESERVED_METHODS = (Capybara::Session::DSL_METHODS - SKIPPED_DSL_METHODS + test_helper_methods).to_set.freeze

  # Internal: Ruby 2.7 swallows keyword arguments, so for methods that take a
  # Hash as the first argument as well as keyword arguments, we need to manually
  # detect and move them to args if empty.
  METHODS_EXPECTING_A_HASH = %i[matches_style? has_style? match_style have_style].to_set.freeze

  # Internal: Struct for configuration.
  Config = Struct.new(*DEFAULT_CONFIGURATION.keys)

  # Public: Returns the current configuration for the test helpers.
  def self.config
    @config ||= Config.new(*DEFAULT_CONFIGURATION.values)
    yield @config if block_given?
    @config
  end

  # Internal: Allows to define methods that are a part of the Capybara DSL, as
  # well as RSpec matchers.
  def self.define_helper_method(klass, method_name, wrap: false, assertion: false, target: 'current_context', return_self: assertion, inject_test_helper: true)
    klass.class_eval <<~HELPER, __FILE__, __LINE__ + 1
      def #{ method_name }(*args, **kwargs, &filter)
        #{ 'args.push(kwargs) && (kwargs = {}) if args.empty?' if METHODS_EXPECTING_A_HASH.include?(method_name) }
        #{ 'kwargs[:test_helper] = self' if inject_test_helper }
        #{ 'wrap_element ' if wrap }#{ assertion ? "expect(#{ target }).to_or not_to, test_context" : target }.#{ method_name }(*args, **kwargs, &filter)
        #{ 'self' if return_self }
      end
    HELPER
  end
end

# NOTE: Simplify migration from Capybara Test Helpers.
CapybaraTestHelpers = Capybara::Compose unless defined?(CapybaraTestHelpers)
Capybara::TestHelper = Capybara::Compose::TestHelper unless defined?(Capybara::TestHelper)
