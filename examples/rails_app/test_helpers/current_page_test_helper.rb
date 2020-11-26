# frozen_string_literal: true

class CurrentPageTestHelper < BaseTestHelper
  use_test_helpers(:navigation)

  SCREEN_SIZES = {
    phone: { width: 375, height: 667 },
    tablet: { width: 600, height: 960 },
    desktop: { width: 1280, height: 1024 },
  }.freeze

  # Override: Provide a clearer message on this anti-pattern.
  def to_capybara_node
    return current_context if current_element?

    raise ArgumentError, 'The current page should not be used as an element. Do not make assertions in the whole page, check inside a more specific element instead.'
  end

# Actions: Encapsulate complex actions to provide a cleaner interface.
  # Public: Resizes the current window to the specified size.
  def resize_to(screen_size)
    size = SCREEN_SIZES.fetch(screen_size)
    current_window.resize_to(size[:width], size[:height])
  end

# Assertions: Allow to check on element properties while keeping it DRY.
  # Syntax Sugar: Asserts that the current page is the specified one.
  def be(*args)
    navigation.be_in_page(*args)
  end

# Background: Helpers to add/modify/delete data in the database or session.
end
