# frozen_string_literal: true

require 'capybara/rspec'
require 'active_support/core_ext/array/wrap'

# Internal: Avoid warnings in assert_valid_keys for passing the `test_helper` option.
Capybara::Queries::BaseQuery.prepend(Module.new {
  attr_reader :test_helper

  def initialize(options)
    @test_helper = options.delete(:test_helper)
  end
})

# Internal: Handle locator aliases provided in the test helper to finders,
# matchers, assertions, and actions.
Capybara::Queries::SelectorQuery.prepend(Module.new {
  def initialize(*args, **options, &filter_block)
    # Resolve any locator aliases defined in the test helper where this query
    # originated from (through a finder, assertion, or matcher).
    if test_helper = options[:test_helper]
      args, options, filter_block = test_helper.resolve_alias_for_selector_query(args, options, filter_block)
    end

    # Unwrap any test helpers that were provided to the :label selector, since
    # it's making an explicit check by class.
    options[:for] = options[:for].to_capybara_node if options[:for].is_a?(CapybaraTestHelpers::TestHelper)

    super(*args, **options, &filter_block)
  end
})

# Public: Adds aliasing for element selectors to make it easier to encapsulate
# how to find a particular kind of element in the UI.
module CapybaraTestHelpers::Selectors
  SELECTOR_SEPARATOR = ','

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    # Public: Light wrapper as syntax sugar for defining SELECTORS.
    def aliases(selectors = {})
      const_set('SELECTORS', selectors)
    end

    # Public: Returns the available selectors for the test helper, or an empty
    # Hash if selectors are not defined.
    def selectors
      unless defined?(@selectors)
        parent_selectors = superclass.respond_to?(:selectors) ? superclass.selectors : {}
        child_selectors = (defined?(self::SELECTORS) && self::SELECTORS || {})
          .tap { |new_selectors| validate_selectors(new_selectors) }
        @selectors = parent_selectors.merge(child_selectors).transform_values(&:freeze).freeze
      end
      @selectors
    end

    # Internal: Allows to "call" selectors, as a shortcut for find.
    #
    # Example: table.header == table.find(:header)
    def define_getters_for_selectors
      selectors.each_key do |selector_name|
        define_method(selector_name) { |*args, **kwargs, &block|
          find(selector_name, *args, **kwargs, &block)
        }
      end
    end

    # Internal: Validates that all the selectors defined in the class won't
    # cause confusion or misbehavior.
    def validate_selectors(selectors)
      selectors.each_key do |name|
        if Capybara::Selector.all.key?(name)
          raise "A selector with the name #{ name.inspect } is already registered in Capybara," \
          " consider renaming the #{ name.inspect } alias in #{ self.class.name } to avoid confusion."
        end
        if CapybaraTestHelpers::RESERVED_METHODS.include?(name)
          raise "A method with the name #{ name.inspect } is part of the Capybara DSL," \
          " consider renaming the #{ name.inspect } alias in #{ self.class.name } to avoid confusion."
        end
      end
    end
  end

  # Public: Returns the available selectors for the test helper, or an empty
  # Hash if selectors are not defined.
  def selectors
    self.class.selectors
  end

  # Internal: Inspects the arguments for a SelectorQuery, and resolves a
  # selector alias if provided.
  #
  # Returns a pair of arguments and keywords to initialize a SelectorQuery.
  def resolve_alias_for_selector_query(args, kwargs, filter_block)
    # Extract the explicitly provided selector, if any. Example: `find_button`.
    explicit_type = args.shift if selectors.key?(args[1])

    if selectors.key?(args[0])
      args, kwargs = locator_for(*args, **kwargs)

      # Remove the type provided by the alias, and add back the explicit one.
      if explicit_type
        args.shift if args[0].is_a?(Symbol)
        args.unshift(explicit_type)
      end
    end

    [args, kwargs, wrap_filter(filter_block)]
  end

private

  # Internal: Checks if there's a Capybara selector defined by that name.
  def registered_selector?(name)
    Capybara::Selector.all.key?(name)
  end

  # Internal: Returns the query locator defined under the specified alias.
  #
  # NOTE: In most cases, the query locator is a simple CSS selector, but it also
  # supports any of the built-in Capybara selectors.
  #
  # Returns an Array with the Capybara locator arguments, and options if any.
  def locator_for(*args, **kwargs)
    if args.size == 1
      args = [*Array.wrap(resolve_locator_alias(args.first))]
      kwargs = args.pop.deep_merge(kwargs) if args.last.is_a?(Hash)
    end
    [args, kwargs]
  rescue KeyError => error
    raise NotImplementedError, "A selector in #{ self.class.name } is not defined, #{ error.message }"
  end

  # Internal: Resolves one of the segments of a locator alias.
  def resolve_locator_alias(fragment)
    return fragment unless fragment.is_a?(Symbol) && (selectors.key?(fragment) || !registered_selector?(fragment))

    locator = selectors.fetch(fragment)

    locator.is_a?(Array) ? combine_locator_fragments(locator) : locator
  end

  # Internal: Resolves a complex locator alias, which might reference other
  # locator aliases as well.
  def combine_locator_fragments(fragments)
    return fragments unless fragments.any? { |fragment| fragment.is_a?(Symbol) }

    fragments = fragments.map { |fragment| resolve_locator_alias(fragment) }
    flat_fragments = fragments.flatten(1)
    type = flat_fragments.shift if flat_fragments.first.is_a?(Symbol)

    # Only flatten fragments if it's CSS or XPath
    if type.nil? || type == :css || type == :xpath
      fragments = flat_fragments
    else
      type = nil
    end

    options = fragments.pop if fragments.last.is_a?(Hash)

    [type, *combine_css_selectors(fragments), options].compact
  end

  # Internal: Combines parent and child classes to preserve the order.
  def combine_css_selectors(selectors)
    return selectors unless selectors.size > 1 && selectors.all? { |selector| selector.is_a?(String) }

    selectors.reduce { |parent_selectors, children_selectors|
      parent_selectors.split(SELECTOR_SEPARATOR).flat_map { |parent_selector|
        children_selectors.split(SELECTOR_SEPARATOR).map { |children_selector|
          "#{ parent_selector }#{ children_selector }"
        }
      }.join(SELECTOR_SEPARATOR)
    }
  end
end
