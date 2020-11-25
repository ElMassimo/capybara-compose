# frozen_string_literal: true

Capybara.get_test_helper_class(:form_page)

class PersonFormTestHelper < FormPageTestHelper
  aliases(
    el: 'form[novalidate]',
  )
end
