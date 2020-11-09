# frozen_string_literal: true

class CitiesTestHelper < BaseTestHelper
  use_test_helpers(:form, :table)

# Selectors: Semantic aliases for elements, a useful abstraction.
  SELECTORS = {
    el: 'table.cities',
  }

# Getters: A convenient way to get related data or nested elements.
  def row_for(city)
    within { table.row_for(city.is_a?(String) ? city : city.name) }
  end

# Actions: Encapsulate complex actions to provide a cleaner interface.
  def add(**args)
    click_on('New City')
    save_city(**args)
    block_given? ? yield(form) : click_on('Back')
  end

  def edit(city, with:)
    row_for(city).click_on('Edit')
    save_city(**with)
    click_on('Back')
  end

  def delete(city)
    row_for(city).click_on('Destroy')
    accept_confirm
  end

  private \
  def save_city(name:)
    form.within {
      fill_in 'Name', with: name
      form.save
    }
  end

# Assertions: Check on element properties, used with `should` and `should_not`.
  def have_city(name)
    have_content(name)
  end

# Background: Helpers to add/modify/delete data in the database or session.
  def given_there_is_a_city(name)
    City.create!(name: name)
  end
end
