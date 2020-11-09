# frozen_string_literal: true

class JsPageTestHelper < BaseTestHelper
  use_test_helpers(:headings)

# Selectors: Semantic aliases for elements, a very useful abstraction.
  SELECTORS = {
    el: '#with_js',
    change: '#change',
    alert_toggle: 'Open alert',
    draggable_element: '#drag',
    drop_target: '#drop_html5',
    editable_content_child: '#existing_content_editable_child',
    first_editable_content: '#existing_content_editable',
    input_with_change_listener: [:fillable_field, 'with_change_event'],
    change_event: '.change_event_triggered',
    input_event: [:xpath, '//p[@class="input_event_triggered"]'],
    input_with_focus_listener: '#with_focus_event',
  }.freeze

# Getters: A convenient way to get related data or nested elements.

# Actions: Encapsulate complex actions to provide a cleaner interface.
  def open_and_accept_alert
    click_link(:alert_toggle)
    accept_alert
  end

  def clear_field
    fill_in(:input_with_change_listener, with: '')
  end

  def click_another_input
    input_with_focus_listener.click
  end

  def click_a_heading
    headings.title(text: 'FooBar').click
  end

  def drop_file(*files)
    files = files.map { |file| support_file_path(file) }
    drop(*files)
  end

# Assertions: Allow to check on element properties while keeping it DRY.
  def be_content_editable
    expect(base.content_editable?).to_or not_to, eq(true)
  end

  def have_triggered_change(**options)
    have_selector(:change_event, **options)
  end

  def have_triggered_input_events(**options)
    have_xpath(:input_event, **options)
  end

  def have_dropped_element(*keys)
    have_xpath(%{//div[contains(., "Dropped!#{ keys.map { |key| "-#{ key }" }.join }")]})
  end

  def have_dropped(str)
    have_content("HTML5 Dropped #{ str }")
  end

# Background: Helpers to add/modify/delete data in the database or session.
end
