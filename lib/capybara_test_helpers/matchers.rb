# frozen_string_literal: true

# Internal: Wraps Capybara matchers to enable locator aliases, and to wrap the
# result with a test helper so that methods can be chained in a fluent style.
module CapybaraTestHelpers::Matchers
  %i[
    has_selector?
    has_no_selector?
    has_css?
    has_no_css?
    has_xpath?
    has_no_xpath?
    has_link?
    has_no_link?
    has_button?
    has_no_button?
    has_field?
    has_no_field?
    has_select?
    has_no_select?
    has_table?
    has_no_table?
    has_checked_field?
    has_no_checked_field?
    has_unchecked_field?
    has_no_unchecked_field?
    has_title?
    has_no_title?
    has_title?
    has_no_title?
  ].each do |method_name|
    CapybaraTestHelpers.define_helper_method(self, method_name)
  end

  %i[
    has_ancestor?
    has_no_ancestor?
    has_sibling?
    has_no_sibling?
    matches_selector?
    not_matches_selector?
    matches_css?
    not_matches_css?
    matches_xpath?
    not_matches_xpath?
    has_text?
    has_no_text?
    has_content?
    has_no_content?
    matches_style?
    has_style?
  ].each do |method_name|
    CapybaraTestHelpers.define_helper_method(self, method_name, target: :to_capybara_node)
  end

  %i[
    assert_selector
    assert_all_of_selectors
    assert_none_of_selectors
    assert_any_of_selectors
    assert_no_selector
  ].each do |method_name|
    CapybaraTestHelpers.define_helper_method(self, method_name)
  end

  %i[
    assert_matches_selector
    assert_not_matches_selector
    assert_ancestor
    assert_no_ancestor
    assert_sibling
    assert_no_sibling
  ].each do |method_name|
    CapybaraTestHelpers.define_helper_method(self, method_name, target: :to_capybara_node)
  end

  alias has? has_selector?
  alias has_no? has_no_selector?
end
