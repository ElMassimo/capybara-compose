# frozen_string_literal: true

require 'capybara/rspec'

# Internal: Used heavily in the RSpec matchers, makes it very easy to create
# a dual assertion (can be used as positive or negative).
#
# See https://maximomussini.com/posts/cucumber-to_or_not_to/
module CapybaraTestHelpers::ToOrExpectationHandler
  # Public: Allows a more convenient definition of should/should not Gherkin steps.
  #
  # Example:
  #
  #   Then(/^I should (not )?see "(.*)"$/) do |not_to, text|
  #     expect(page).to_or not_to, have_content(text)
  #   end
  #
  def to_or(not_to, matcher, message = nil, &block)
    if not_to
      not_to(matcher, message, &block)
    else
      to(matcher, message, &block)
    end
  end
end

RSpec::Expectations::ExpectationTarget.include(CapybaraTestHelpers::ToOrExpectationHandler)
