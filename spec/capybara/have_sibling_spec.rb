# frozen_string_literal: true

RSpec.feature '#have_sibling', test_helpers: [:html_page] do
  before do
    visit_page(:html)
  end

  def mid_sibling
    html_page.mid_sibling
  end

  it 'should assert sibling elements using the given locators' do
    mid_sibling
      .should.have_sibling(:pre_sibling)
      .and_also.have_sibling('#post_sibling')
      .and_also.have_sibling('div', count: 2)

    expect do
      mid_sibling.should.have_sibling('div', count: 1)
    end.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  it 'should assert no matching sibling' do
    html_page.mid_sibling
      .should.have_no_sibling('#not_a_sibling')
      .should_not.have_sibling('#not_a_sibling')

    expect do
      mid_sibling.should.have_no_sibling(:pre_sibling)
    end.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end
end
