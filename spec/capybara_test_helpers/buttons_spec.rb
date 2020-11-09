# frozen_string_literal: true

RSpec.feature 'buttons', helpers: [:form_page] do
  before do
    form_page.visit_page
  end

  it 'should allow to find a button by type' do
    form_page.should.have_button(:submit_button)
    form_page.should.have_selector(:submit_button)

    form_page.submit_button(match: :first).should.match_selector(:submit_button)
    form_page.find('#click_me_123').should.match_selector(:submit_button)

    expect { form_page.should_not.have_selector(:submit_button) }
      .to raise_error(RSpec::Expectations::ExpectationNotMetError)

    expect { form_page.find('#click_me_123').should_not.match_selector(:submit_button) }
      .to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end
end
