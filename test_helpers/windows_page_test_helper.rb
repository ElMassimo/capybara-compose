# frozen_string_literal: true

class WindowsPageTestHelper < BaseTestHelper
# Aliases: Semantic aliases for locators, can be used in most DSL methods.
  aliases(
    open_button: '#openWindow',
    open_with_delay_button: '#openWindowWithTimeout',
  )

# Finders: A convenient way to get related data or nested elements.

# Actions: Encapsulate complex actions to provide a cleaner interface.
  def open_window(delay: false)
    (delay ? open_with_delay_button : open_button).click
  end

  def close_with_delay(millis)
    execute_script("setTimeout(function(){ window.close(); }, #{ millis });")
  end

# Assertions: Allow to check on element properties while keeping it DRY.
# Background: Helpers to add/modify/delete data in the database or session.
end
