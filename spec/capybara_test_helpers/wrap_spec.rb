# frozen_string_literal: true

RSpec.feature 'Wrapping Test Helpers', test_helpers: [:html_page, :form_page] do
  it 'wraps elements as expected' do
    visit_page(:html)
    expect(html_page.first_paragraph).to be_a(HtmlPageTestHelper)
    expect(html_page.first_paragraph).to have_link('labore')

    # Should scope find operations based on the current context, without using within.
    expect { html_page.child.first_paragraph }.to raise_error(Capybara::ExpectationNotMet)
    expect { html_page.first_paragraph.first_paragraph }.to raise_error(Capybara::ExpectationNotMet)
  end
end
