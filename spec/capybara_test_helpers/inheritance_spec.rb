# frozen_string_literal: true

RSpec.feature 'Inheritance', test_helpers: [:person_form] do
  before do
    visit '/form'
  end

  it 'inherits locator aliases from parent class' do
    person_form.within {
      title = person_form.title
      title.should.have_value('Mrs')
      title.select('Mr')
      title.should.have_value('Mr')
    }
  end
end
