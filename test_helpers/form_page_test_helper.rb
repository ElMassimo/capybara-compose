# frozen_string_literal: true

class FormPageTestHelper < BaseTestHelper
  use_test_helpers(:headings, :results)

# Selectors: Semantic aliases for elements, a very useful abstraction.
  SELECTORS = {
    get_form: '#get-form',
    title: [:id, 'form_title'],
    clickable_button: [:button, 'Click me!'],
    city_select: '#form_city',
    address_city_input: '#address1_city',
    long_input: '#long_length',
    first_name_input: [:fillable_field, 'form_first_name'],
    date_input: '#form_date',
    single_upload_field: 'Single Document',
    single_upload_button: 'Upload Single',
    underwear_select: 'Underwear',
    locale_select: [:select, 'Locale'],
    gender: 'form[gender]',

    # All Spec
    name_input: [:fillable_field, 'Name'],

    # Buttons Spec
    submit_button: [:button, type: 'submit'],
  }.freeze

# Getters: A convenient way to get related data or nested elements.
  def city_options
    city_select.all('option')
  end

  def find_label(*args, **options, &filter_block)
    find(:label, *args, **options, &filter_block)
  end

# Actions: Encapsulate complex actions to provide a cleaner interface.
  def move_caret_to_the_beginning
    execute_script('this.setSelectionRange(0, 0)')
  end

  def upload_directory
    attach_file('Directory Upload', support_file_path)
    click_button('Upload Multiple')
  end

  def upload_file(file)
    attach_file(:single_upload_field, "spec/support/files/#{ file }")
    click_button(:single_upload_button)
  end

  def set_with_delay(value, delay:)
    execute_script('setTimeout(() => arguments[0].value = arguments[1], arguments[2])', self, value, delay * 1000)
  end

# Assertions: Allow to check on element properties while keeping it DRY.
  delegate :have_results, to: :results

  def be_checked
    synchronize_expectation { expect(checked?).to eq(!not_to) }
    self
  end

  def be_selected
    synchronize_expectation { expect(selected?).to eq(!not_to) }
    self
  end

  def be_disabled
    synchronize_expectation { expect(disabled?).to eq(!not_to) }
    self
  end

  def be_labeling(input_id)
    synchronize_expectation { expect(self[:for]).to_or not_to, eq(input_id) }
    self
  end

  def have_date_events(events)
    synchronize_expectation {
      expect(evaluate_script('window.capybara_formDateFiredEvents')).to eq events
    }
  end

  def be_focused
    synchronize_expectation {
      expect(evaluate_script('document.activeElement')).to_or not_to, eq(to_capybara_node)
    }
    self
  end

  def not_be_focused
    invert_expectation.be_focused
  end

# Background: Helpers to add/modify/delete data in the database or session.
  def given_the_date_input_has_listeners
    date_input.execute_script <<-JS
      window.capybara_formDateFiredEvents = [];
      var fd = this;
      ['focus', 'input', 'change'].forEach(function(eventType) {
        fd.addEventListener(eventType, function() { window.capybara_formDateFiredEvents.push(eventType); });
      });
    JS
    headings.title(text: 'Form').click
  end
end
