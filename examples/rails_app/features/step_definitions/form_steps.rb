# frozen_string_literal: true

use_test_helpers(:form)

Then('I should see a {string} error in the form') do |message|
  form.should.have_error(message)
end
