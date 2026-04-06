# frozen_string_literal: true

require 'capybara/rspec'
require 'set'
require 'zeitwerk'

# Internal: Configuration for Provides the basic functionality to create simple test helpers.
module CapybaraTestHelpers
  DEFAULTS = {
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

  # Public: Returns the current configuration for the test helpers.
  def self.config
    @config ||= OpenStruct.new(DEFAULTS)
    yield @config if block_given?
    sync_helpers_loader!
    @config
  end


  def self.helpers_loader
    return @helpers_loader if defined?(@helpers_loader)

    @helpers_loader = Zeitwerk::Loader.new.tap do |loader|
      loader.inflector.inflect('test_helper' => 'TestHelper')
      loader.enable_reloading
      loader.on_load do |_cpath, value, _abspath|
        initialize_test_helper_class!(value)
      end
    end
  end

  def self.sync_helpers_loader!
    loader = helpers_loader
    desired_paths = config.helpers_paths.map { |path| File.expand_path(path) }.uniq

    current_paths = loader.dirs.to_a
    (current_paths - desired_paths).each { |path| loader.unregister(path) }
    (desired_paths - current_paths).each { |path| loader.push_dir(path) if Dir.exist?(path) }

    if @helpers_loader_setup
      loader.reload
    else
      loader.setup
      @helpers_loader_setup = true
    end
    true
  end

  def self.initialize_test_helper_class!(klass)
    return klass unless klass.is_a?(Class) && klass <= Capybara::TestHelper
    return klass if klass.instance_variable_defined?(:@capybara_test_helpers_initialized)

    klass.on_test_helper_load
    klass.instance_variable_set(:@capybara_test_helpers_initialized, true)
    klass
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
