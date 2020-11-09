# frozen_string_literal: true

# Public: Contains useful methods for debugging test failures.
class DebugTestHelper < BaseTestHelper
# Selectors: Semantic aliases for elements, a very useful abstraction.
  SELECTORS = {}.freeze

# Getters: A convenient way to get related data or nested elements.
  # Public: Returns the inner HTML of the specified element.
  def inner_html(element)
    element = element.to_capybara_node if element.respond_to?(:to_capybara_node)
    (element.respond_to?(:native) ? element.native.inner_html : element.text) if element
  end

# Actions: Encapsulate complex actions to provide a cleaner interface.
  def screenshot
    Rails.env.ci? ? Capybara.save_screenshot : Capybara.save_and_open_screenshot
  end

  def puts_page
    puts_and_return page.body
  end

  def puts_html(element)
    puts_and_return inner_html(element)
  end

  # Internal: Only used for debuging in development.
  def puts_element(*args, **options)
    puts_and_return with_js_element(*args, evaluate: '.outerHTML', **options)
  end

  # Internal: Only used for debuging in development.
  def puts_inner_html(*args, **options)
    puts_and_return with_js_element(*args, evaluate: '.innerHTML', **options)
  end

  # Internal: Only used for debuging in development.
  def puts_and_return(value)
    value.tap { Kernel.puts(value.is_a?(String) ? value.yellow : value.inspect) }
  end

  # Public: Try to refocus the current window when not running headless.
  # NOTE: This is useful when you are doing something else while running the
  # test and the browser can't find a `visible` element.
  def refocus_window
    page.driver.switch_to_window(page.current_window.handle)
  end

# Assertions: Allow to check on element properties while keeping it DRY.

# Background: Helpers to add/modify/delete data in the database or session.
end
