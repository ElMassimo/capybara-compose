# frozen_string_literal: true

class WindowsPageTestHelper < BaseTestHelper
# Selectors: Semantic aliases for elements, a very useful abstraction.
  SELECTORS = {
    open_button: '#openWindow',
    open_with_delay_button: '#openWindowWithTimeout',
  }.freeze

# Getters: A convenient way to get related data or nested elements.

# Actions: Encapsulate complex actions to provide a cleaner interface.
  def open_window(delay: false)
    (delay ? open_with_delay_button : open_button).click
  end

  def close_with_delay(millis)
    execute_script("setTimeout(function(){ window.close(); }, #{ millis });")
  end

# Assertions: Allow to check on element properties while keeping it DRY.
  # NOTE: This is similar to become_closed, using it just to test that it retries.
  def be_closed_after_delay(delay)
    synchronize_expectation(wait: delay) {
      expect(current_window.exists?).to_or not_to, eq(false)
    }
  end

# Background: Helpers to add/modify/delete data in the database or session.
end
