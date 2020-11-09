# frozen_string_literal: true

use_test_helpers(:cities)

Given('there is an {string} city') do |name|
  cities.given_there_is_a_city(name)
end

When('I add a city:') do |table|
  cities.add(**table.rows_hash.symbolize_keys) { }
end

When('I go back to the cities') do
  click_on('Back')
end

When('I edit the {string} city with:') do |name, table|
  cities.edit(name, with: table.rows_hash.symbolize_keys)
end

When('I delete the {string} city') do |name|
  cities.delete(name)
end

# https://maximomussini.com/posts/cucumber-to_or_not_to/
Then(/^there should( not)? be an? "(.+?)" city$/) do |or_should_not, name|
  cities.should(or_should_not).have_city(name)
end
