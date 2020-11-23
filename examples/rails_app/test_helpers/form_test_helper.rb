# frozen_string_literal: true

class FormTestHelper < BaseTestHelper
# Aliases: Semantic aliases for locators, can be used in most DSL methods.
  aliases(
    el: 'form[action]',
    submit_button: [:button, type: 'submit'],
    error_summary: '#error_explanation',
  )

# Finders: A convenient way to get related data or nested elements.

# Actions: Encapsulate complex actions to provide a cleaner interface.
  # Public: Submits the form.
  def save
    submit_button.click
  end

# Assertions: Check on element properties, used with `should` and `should_not`.
  def have_error(message)
    have(:error_summary, text: message)
  end

# Background: Helpers to add/modify/delete data in the database or session.
end
