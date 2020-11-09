# frozen_string_literal: true

require 'rails_helper'

# Based on an example in the following article, but using test helpers:
# https://www.codewithjason.com/rails-integration-tests-rspec-capybara/
RSpec.describe 'Cities', test_helpers: [:cities] do
  let!(:nyc) { cities.given_there_is_a_city('NYC') }

  before { cities.visit_page }

  scenario 'valid inputs' do
    cities.add(name: 'Minneapolis')
    cities.should.have_city('Minneapolis')
  end

  scenario 'invalid inputs' do
    cities.add(name: '') { |form|
      form.should.have_error("Name can't be blank")
    }
  end

  scenario 'editing a city' do
    cities.edit(nyc, with: { name: 'New York City' })
    cities.should_no_longer.have_city('NYC')
    cities.should_now.have_city('New York City')
  end

  scenario 'deleting a city', screen_size: :phone do
    cities.delete(nyc)
    cities.should_no_longer.have_city('NYC')
  end
end
