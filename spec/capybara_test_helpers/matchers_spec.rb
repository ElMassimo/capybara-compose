# frozen_string_literal: true

RSpec.feature 'matchers', test_helpers: [:form_page] do
  describe 'has? and have' do
    before do
      form_page.visit_page
    end

    given(:form) { form_page.get_form }

    it 'should not fail when using matchers' do
      expect(form.has?(:middle_name_input)).to eq true
      expect(form.has?(:middle_name_input, disabled: true)).to eq false
    end

    it 'should allow using have instead of have_selector' do
      form.should.have(:middle_name_input)
      expect {
        form.should.have(:middle_name_input, disabled: true)
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError, /Expected disabled true but it wasn't/)
    end

    it 'should be able to use the RSpec matcher' do
      expect { expect([1,2,3]).to form.have(3).items }.to raise_error(NameError)

      require 'rspec/collection_matchers'
      expect([1,2,3]).to form.have(3).items
      expect([1,2,3]).not_to form.have(2).items
    end
  end
end
