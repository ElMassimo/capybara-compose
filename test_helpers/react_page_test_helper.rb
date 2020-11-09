# frozen_string_literal: true

class ReactPageTestHelper < BaseTestHelper
# Selectors: Semantic aliases for elements, a very useful abstraction.
  SELECTORS = {
    name_input: 'Name:',
  }.freeze

# Getters: A convenient way to get related data or nested elements.

# Actions: Encapsulate complex actions to provide a cleaner interface.
  def submit_name(name)
    fill_in(:name_input, with: name)
    accept_prompt(/A name was submitted: #{ name }$/) do
      click_button('Submit')
    end
  end

# Assertions: Allow to check on element properties while keeping it DRY.

# Background: Helpers to add/modify/delete data in the database or session.
end
