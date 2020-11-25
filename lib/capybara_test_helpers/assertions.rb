# frozen_string_literal: true

require 'capybara_test_helpers/to_or_expectation_handler'

# Internal: Wraps RSpec matchers to allow using them after calling `should` or
# `should_not` to perform the assertion.
module CapybaraTestHelpers::Assertions
  # Public: Returns a test helper with a positive assertion state.
  # Any assertions called after it will execute as `expect(...).to ...`.
  def should(negated = false)
    negated = !!negated # Coerce to boolean.
    return self if negated == @negated

    clone.tap { |test_helper| test_helper.instance_variable_set('@negated', negated) }
  end
  [:should_still, :should_now, :and, :and_instead, :and_also, :and_still].each { |should_alias| alias_method should_alias, :should }

  # Public: Returns a test helper with a negative assertion state.
  # Any assertions called after it will execute as `expect(...).not_to ...`.
  def should_not
    @negated ? self : should(true)
  end
  [:should_still_not, :should_no_longer, :nor, :and_not].each { |should_alias| alias_method should_alias, :should_not }

  # Public: Makes it more readable when in used in combination with to_or.
  def not_to
    raise(ArgumentError, 'You must call `should` or `should_not` before calling this method') if @negated.nil?

    @negated
  end
  alias or_should_not not_to

  # Public: Allows to write complex nested assertions.
  def invert_expectation
    should(!not_to)
  end

  %i[
    have_selector
    have_no_selector
    have_css
    have_no_css
    have_xpath
    have_no_xpath
    have_link
    have_no_link
    have_button
    have_no_button
    have_field
    have_no_field
    have_select
    have_no_select
    have_table
    have_no_table
    have_checked_field
    have_no_checked_field
    have_unchecked_field
    have_no_unchecked_field
    have_all_of_selectors
    have_none_of_selectors
    have_any_of_selectors
    have_title
    have_no_title
  ].each do |method_name|
    CapybaraTestHelpers.define_helper_method(self, method_name, assertion: true)
  end

  %i[
    have_ancestor
    have_no_ancestor
    have_sibling
    have_no_sibling
    match_selector
    not_match_selector
    match_css
    not_match_css
    match_xpath
    not_match_xpath
    have_text
    have_no_text
    have_content
    have_no_content
    match_style
    have_style
  ].each do |method_name|
    CapybaraTestHelpers.define_helper_method(self, method_name, target: :to_capybara_node, assertion: true)
  end

  %i[
    have_current_path
    have_no_current_path
  ].each do |method_name|
    CapybaraTestHelpers.define_helper_method(self, method_name, target: :page, assertion: true, inject_test_helper: false)
  end

  # Public: Allows to call have_selector with a shorter syntax.
  def have(*args, **kwargs, &filter)
    if args.first.is_a?(Integer)
      ::RSpec::CollectionMatchers::Have.new(*args, **kwargs)
    else
      have_selector(*args, **kwargs, &filter)
    end
  end

  alias have_no have_no_selector

  # Public: Allows to check on any input value asynchronously.
  def have_value(expected_value, **options)
    synchronize_expectation(**options) { expect(value).to_or not_to, eq(expected_value) }
    self
  end

private

  # Internal: Override the method_missing defined in RSpec::Matchers to avoid
  # accidentally calling a predicate or has matcher instead of an assertion.
  def method_missing(method, *args, **kwargs, &block)
    case method.to_s
    when CapybaraTestHelpers::TestHelper::DYNAMIC_MATCHER_REGEX
      raise NoMethodError, "undefined method `#{ method }' for #{ inspect }.\nUse `delegate_to_test_context(:#{ method })` in the test helper class if you plan to use it often, or `test_context.#{ method }` as needed in the instance."
    else
      super
    end
  end

  # Internal: Override the method_missing defined in RSpec::Matchers to avoid
  # accidentally calling a predicate or has matcher instead of an assertion.
  def respond_to_missing?(method, *)
    return false if method =~ CapybaraTestHelpers::TestHelper::DYNAMIC_MATCHER_REGEX

    super
  end
end
