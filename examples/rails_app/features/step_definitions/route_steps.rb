# frozen_string_literal: true

use_test_helpers(:routes)

Given(/I visit the (.+) page$/) do |page|
  routes.visit_page(page.to_sym)
end
