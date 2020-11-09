# frozen_string_literal: true

RSpec.feature '#have_ancestor', test_helpers: [:html_page] do
  before do
    html_page.visit_page
  end

  it 'should assert an ancestor using the given locator' do
    html_page.grandchild
      .should.have_ancestor(:child)
      .should.have_ancestor(:parent)
  end

  it 'should assert no matching ancestor' do
    html_page.grandchild
      .should.have_no_ancestor(:grand_grandchild)
      .should.have_no_ancestor('#ancestor1_sibiling')
      .should_not.have_ancestor(:grand_grandchild)
      .should_not.have_ancestor('#ancestor1_sibiling')
  end

  it 'should assert an ancestor even if not parent' do
    html_page.grand_grandchild
      .should.have_ancestor(:parent)
  end

  it 'should not raise an error if there are multiple matches' do
    html_page.grand_grandchild
      .should.have_ancestor('div')
  end

  it 'should allow counts to be specified' do
    el = html_page.grand_grandchild

    expect do
      el.should.have_ancestor('div', count: 1)
    end.to raise_error(RSpec::Expectations::ExpectationNotMetError)

    el.should.have_ancestor('div', count: 3)
  end
end
