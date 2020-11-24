# frozen_string_literal: true

class CurrentPageTestHelper < BaseTestHelper
  use_test_helpers(:routes)

# Aliases: Semantic aliases for locators, can be used in most DSL methods.
  aliases(
    body: 'body',
    html: 'html',
  )

  SCREEN_SIZES = {
    phone: { width: 375, height: 667 },
    tablet: { width: 600, height: 960 },
    desktop: { width: 1280, height: 1024 },
  }.freeze

# Finders: A convenient way to get related data or nested elements.
  def to_capybara_node
    return current_context if current_element?

    raise ArgumentError, 'The current page should not be used as an element. Do not make assertions in the whole page, check inside a more specific element instead.'
  end

  # Public: Returns true if the page is fullscreen.
  def fullscreen?
    evaluate_script('!!(document.mozFullScreenElement || document.webkitFullscreenElement)')
  end

# Actions: Encapsulate complex actions to provide a cleaner interface.
  # Public: Allows to type keyboard shortcuts.
  def type_shortcut(*keys)
    body.fill_in(keys)
  end

  def click_outside
    body.click
  end

  def close_window
    current_window.close
  end

  def on_new_window(close_afterwards: true, &run_in_new_window)
    new_window = open_new_window
    within_window(new_window, &run_in_new_window)
  ensure
    new_window&.close if close_afterwards
  end

  # Public: Captures a new opened tab, switches to it, and executes the given
  # block in the new tab. Closes the tab afterwards.
  def after_opening_new_tab(fn_that_opens_tab, close_afterwards: true, &run_in_new_window)
    raise ArgumentError, 'The first argument must be a lambda that opens a new window while executed' unless fn_that_opens_tab.respond_to?(:call)

    new_window = window_opened_by { fn_that_opens_tab.call }
    within_window(new_window) { run_in_new_window.call(new_window) }
  ensure
    new_window&.close if close_afterwards
  end

  # Public: Resizes the current window to the specified size.
  def resize_to(screen_size)
    size = SCREEN_SIZES.fetch(screen_size)
    current_window.resize_to(size[:width], size[:height])
  end

# Assertions: Allow to check on element properties while keeping it DRY.
  # Syntax Sugar: Asserts that the current page is the specified one.
  def be(*args)
    routes.be_in_page(*args)
  end

  def be_external_url(website_url)
    assert_current_path(website_url)
  end

  def be_fullscreen
    synchronize_expectation {
      expect(fullscreen?).to_or not_to, eq(true)
    }
  end

# Background: Helpers to add/modify/delete data in the database or session.
end
