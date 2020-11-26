# frozen_string_literal: true

use_test_helpers(:navigation)

Given(/I visit the (.+) page$/) do |page|
  navigation.visit_page(page.to_sym)
end
