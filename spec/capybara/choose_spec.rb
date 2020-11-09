# frozen_string_literal: true

RSpec.feature '#choose', helpers: [:form_page] do
  before do
    form_page.visit_page
  end

  it 'should choose a radio button by id' do
    form_page.choose('gender_female')
    form_page.click_button('awesome')
    form_page.should.have_results('gender', 'female')
  end

  it 'should choose a radio button by label' do
    form_page.choose('Both')
    form_page.click_button('awesome')
    form_page.should.have_results('gender', 'both')
  end

  it 'should work without a locator string' do
    form_page.choose(id: 'gender_male')
    form_page.click_button('awesome')
    form_page.should.have_results('gender', 'male')
  end

  it 'should be able to choose self when no locator string specified' do
    form_page.find(:id, 'gender_female').choose
    form_page.click_button('awesome')
    form_page.should.have_results('gender', 'female')
  end

  it 'casts to string' do
    form_page.choose('Both')
    form_page.click_button(:awesome)
    form_page.should.have_results('gender', 'both')
  end

  context "with a locator that doesn't exist" do
    it 'should raise an error' do
      msg = /Unable to find radio button "does not exist"/
      expect do
        form_page.choose('does not exist')
      end.to raise_error(Capybara::ElementNotFound, msg)
    end
  end

  context 'with a disabled radio button' do
    it 'should raise an error' do
      expect do
        form_page.choose('Disabled Radio')
      end.to raise_error(Capybara::ElementNotFound)
    end
  end

  context 'with :exact option' do
    it 'should accept partial matches when false' do
      form_page.choose('Mal', exact: false)
      form_page.click_button('awesome')
      form_page.should.have_results('gender', 'male')
    end

    it 'should not accept partial matches when true' do
      expect do
        form_page.choose('Mal', exact: true)
      end.to raise_error(Capybara::ElementNotFound)
    end
  end

  context 'with `option` option' do
    it 'can check radio buttons by their value' do
      form_page.choose(:gender, option: 'female')
      form_page.click_button('awesome')
      form_page.should.have_results('gender', 'female')
    end

    it 'should alias `:with` option' do
      form_page.choose('form[gender]', with: 'male')
      form_page.click_button('awesome')
      form_page.should.have_results('gender', 'male')
    end

    it 'should raise an error if option not found' do
      expect do
        form_page.choose('form[gender]', option: 'english')
      end.to raise_error(Capybara::ElementNotFound)
    end
  end

  it 'should return the chosen radio button' do
    el = form_page.find(:radio_button, 'gender_female')
    expect(form_page.choose('gender_female')).to eq el
  end
end
