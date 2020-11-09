# frozen_string_literal: true

RSpec.feature 'assertions', test_helpers: [:form_page] do
  describe 'have_value' do
    before do
      form_page.visit_page
    end

    given(:form) { form_page.get_form }

    it 'should assert on the current input value' do
      middle_name = form.find_field('Middle Name')
        .should.have_value('Darren')
        .should_not.have_value('Jim')
      expect { middle_name.should.have_value('Jim') }
        .to raise_error(RSpec::Expectations::ExpectationNotMetError, /expected: "Jim"/)

      form.fill_in('Middle Name', with: 'Jim')
        .should_no_longer.have_value('Darren')
        .should_now.have_value('Jim')
      expect { middle_name.should.have_value('Darren') }
        .to raise_error(RSpec::Expectations::ExpectationNotMetError, /got: "Jim"/)
    end

    it 'should wait asynchronously for the specified time', driver: :chrome_headless do
      form.find_field('Middle Name')
        .set_with_delay('Jim', delay: 1)
        .should.have_value('Jim', wait: 2)

      expect {
        form.find_field('Middle Name')
          .set_with_delay('Tim', delay: 2)
          .should.have_value('Tim', wait: 1)
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError, /got: "Jim"/)
    end
  end
end
