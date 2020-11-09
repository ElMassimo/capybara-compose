# frozen_string_literal: true

RSpec.feature '#have_select', test_helpers: [:form_page] do
  before do
    visit_page(:form)
  end

  it 'should be true if the field is on the page' do
    form_page.should.have_select('Locale')
    form_page.should.have_select('form_region')
    form_page.should.have_select('Languages')
    form_page.should.have_select(:Languages)

    form_page.should.have_select(:locale_select)
    form_page.should.have_selector(:locale_select)
    expect { form_page.should_not.have_select(:locale_select) }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    expect { form_page.should_not.have_selector(:locale_select) }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  it 'should be false if the field is not on the page' do
    form_page.should_not.have_select('Monkey')
  end

  context 'with selected value' do
    it 'should be true if a field with the given value is on the page' do
      form_page.should.have_select('form_locale', selected: 'English')
      form_page.should.have_select('Region', selected: 'Norway')
      form_page.should.have_select('Underwear', selected: [
        'Boxerbriefs', 'Briefs', 'Commando', "Frenchman's Pantalons", 'Long Johns'
      ])
    end

    it 'should be false if the given field is not on the page' do
      form_page.should_not.have_select('Locale', selected: 'Swedish')
      form_page.should_not.have_select('Does not exist', selected: 'John')
      form_page.should_not.have_select('City', selected: 'Not there')
      form_page.should_not.have_select('Underwear', selected: [
        'Boxerbriefs', 'Briefs', 'Commando', "Frenchman's Pantalons", 'Long Johns', 'Nonexistent'
      ])
      form_page.should_not.have_select('Underwear', selected: [
        'Boxerbriefs', 'Briefs', 'Boxers', 'Commando', "Frenchman's Pantalons", 'Long Johns'
      ])
      form_page.should_not.have_select('Underwear', selected: [
        'Boxerbriefs', 'Briefs', 'Commando', "Frenchman's Pantalons"
      ])
    end

    it 'should be true after the given value is selected' do
      form_page.select('Swedish', from: :locale_select)
      form_page.should.have_selector(:locale_select, selected: 'Swedish')
    end

    it 'should be false after a different value is selected' do
      form_page.select('Swedish', from: 'Locale')
      form_page.should_not.have_select('Locale', selected: 'English')
    end

    it 'should be true after the given values are selected' do
      form_page.select('Boxers', from: 'Underwear')
      form_page.should.have_select('Underwear', selected: [
        'Boxerbriefs', 'Briefs', 'Boxers', 'Commando', "Frenchman's Pantalons", 'Long Johns'
      ])
    end

    it 'should be false after one of the values is unselected' do
      form_page.unselect('Briefs', from: :underwear_select)
      form_page.should_not.have_select('Underwear', selected: [
        'Boxerbriefs', 'Briefs', 'Commando', "Frenchman's Pantalons", 'Long Johns'
      ])
    end

    it "should be true even when the selected option invisible, regardless of the select's visibility" do
      form_page.should.have_select('Icecream', visible: :hidden, selected: 'Chocolate')
      form_page.should.have_select('Sorbet', selected: 'Vanilla')
    end
  end

  context 'with partial select' do
    it 'should be true if a field with the given partial values is on the page' do
      form_page.should.have_select('Underwear', with_selected: %w[Boxerbriefs Briefs])
    end

    it 'should be false if a field with the given partial values is not on the page' do
      form_page.should_not.have_select('Underwear', with_selected: %w[Boxerbriefs Boxers])
    end

    it 'should be true after the given partial value is selected' do
      form_page.select('Boxers', from: 'Underwear')
      form_page.should.have_select('Underwear', with_selected: %w[Boxerbriefs Boxers])
    end

    it 'should be false after one of the given partial values is unselected' do
      form_page.unselect('Briefs', from: 'Underwear')
      form_page.should_not.have_select('Underwear', with_selected: %w[Boxerbriefs Briefs])
    end

    it "should be true even when the selected values are invisible, regardless of the select's visibility" do
      form_page.should.have_select('Dessert', visible: :hidden, with_options: %w[Pudding Tiramisu])
      form_page.should.have_select('Cake', with_selected: ['Chocolate Cake', 'Sponge Cake'])
    end

    it 'should support non array partial values' do
      form_page.should.have_select('Underwear', with_selected: 'Briefs')
      form_page.should_not.have_select('Underwear', with_selected: 'Boxers')
    end
  end

  context 'with exact options' do
    it 'should be true if a field with the given options is on the page' do
      form_page.should.have_select('Region', options: %w[Norway Sweden Finland])
      form_page.should.have_select('Tendency', options: [])
    end

    it 'should be false if the given field is not on the page' do
      form_page.should_not.have_selector(:locale_select, options: ['Swedish'])
      form_page.should_not.have_select('Does not exist', options: ['John'])
      form_page.should_not.have_select('City', options: ['London', 'Made up city'])
      form_page.should_not.have_select('Region', options: %w[Norway Sweden])
      form_page.should_not.have_select('Region', options: %w[Norway Norway Norway])
    end

    it 'should be true even when the options are invisible, if the select itself is invisible' do
      form_page.should.have_select('Icecream', visible: :hidden, options: %w[Chocolate Vanilla Strawberry])
    end
  end

  context 'with enabled options' do
    it 'should be true if the listed options exist and are enabled' do
      form_page.should.have_select('form_title', enabled_options: %w[Mr Mrs Miss])
    end

    it 'should be false if the listed options do not exist' do
      form_page.should_not.have_select('form_title', enabled_options: ['Not there'])
    end

    it 'should be false if the listed option exists but is not enabled' do
      form_page.should_not.have_select('form_title', enabled_options: %w[Mr Mrs Miss Other])
    end
  end

  context 'with disabled options' do
    it 'should be true if the listed options exist and are disabled' do
      form_page.should.have_select('form_title', disabled_options: ['Other'])
    end

    it 'should be false if the listed options do not exist' do
      form_page.should_not.have_select('form_title', disabled_options: ['Not there'])
    end

    it 'should be false if the listed option exists but is not disabled' do
      form_page.should_not.have_select('form_title', disabled_options: %w[Other Mrs])
    end
  end

  context 'with partial options' do
    it 'should be true if a field with the given partial options is on the page' do
      form_page.should.have_select('Region', with_options: %w[Norway Sweden])
      form_page.should.have_select('City', with_options: ['London'])
    end

    it 'should be false if a field with the given partial options is not on the page' do
      form_page.should_not.have_select('Locale', with_options: ['Uruguayan'])
      form_page.should_not.have_select('Does not exist', with_options: ['John'])
      form_page.should_not.have_select('Region', with_options: %w[Norway Sweden Finland Latvia])
    end

    it 'should be true even when the options are invisible, if the select itself is invisible' do
      form_page.should.have_select('Icecream', visible: :hidden, with_options: %w[Vanilla Strawberry])
    end
  end

  context 'with multiple option' do
    it 'should find multiple selects if true' do
      form_page.should.have_select('form_languages', multiple: true)
      form_page.should_not.have_select('form_other_title', multiple: true)
    end

    it 'should not find multiple selects if false' do
      form_page.should_not.have_select('form_languages', multiple: false)
      form_page.should.have_select('form_other_title', multiple: false)
    end

    it 'should find both if not specified' do
      form_page.should.have_select('form_languages')
      form_page.should.have_select('form_other_title')
    end
  end

  it 'should support locator-less usage' do
    expect(form_page.has_select?(with_options: %w[Norway Sweden])).to eq true
    form_page.should.have_select(with_options: ['London'])
    expect(form_page.has_select?(with_selected: %w[Commando Boxerbriefs])).to eq true
    form_page.should.have_select(with_selected: ['Briefs'])
  end
end

RSpec.feature '#has_no_select?', test_helpers: [:form_page] do
  before { visit_page(:form) }

  it 'should be false if the field is on the page' do
    form_page.should_not.have_no_select('Locale')
    form_page.should_not.have_no_select('form_region')
    form_page.should_not.have_no_select('Languages')
  end

  it 'should be true if the field is not on the page' do
    form_page.should.have_no_select('Monkey')
  end

  context 'with selected value' do
    it 'should be false if a field with the given value is on the page' do
      form_page.should_not.have_no_select('form_locale', selected: 'English')
      form_page.should_not.have_no_select('Region', selected: 'Norway')
      form_page.should_not.have_no_select('Underwear', selected: [
        'Boxerbriefs', 'Briefs', 'Commando', "Frenchman's Pantalons", 'Long Johns'
      ])
    end

    it 'should be true if the given field is not on the page' do
      form_page.should.have_no_selector(:locale_select, selected: 'Swedish')
      form_page.should.have_no_select('Does not exist', selected: 'John')
      form_page.should.have_no_select('City', selected: 'Not there')
      form_page.should.have_no_select('Underwear', selected: [
        'Boxerbriefs', 'Briefs', 'Commando', "Frenchman's Pantalons", 'Long Johns', 'Nonexistent'
      ])
      form_page.should.have_no_select('Underwear', selected: [
        'Boxerbriefs', 'Briefs', 'Boxers', 'Commando', "Frenchman's Pantalons", 'Long Johns'
      ])
      form_page.should.have_no_select('Underwear', selected: [
        'Boxerbriefs', 'Briefs', 'Commando', "Frenchman's Pantalons"
      ])
    end

    it 'should be false after the given value is selected' do
      form_page.select('Swedish', from: 'Locale')
      form_page.should_not.have_no_select('Locale', selected: 'Swedish')
    end

    it 'should be true after a different value is selected' do
      form_page.select('Swedish', from: 'Locale')
      form_page.should.have_no_select('Locale', selected: 'English')
    end

    it 'should be false after the given values are selected' do
      form_page.select('Boxers', from: 'Underwear')
      form_page.should_not.have_no_select('Underwear', selected: [
        'Boxerbriefs', 'Briefs', 'Boxers', 'Commando', "Frenchman's Pantalons", 'Long Johns'
      ])
    end

    it 'should be true after one of the values is unselected' do
      form_page.unselect('Briefs', from: 'Underwear')
      form_page.should.have_no_select('Underwear', selected: [
        'Boxerbriefs', 'Briefs', 'Commando', "Frenchman's Pantalons", 'Long Johns'
      ])
    end
  end

  context 'with partial select' do
    it 'should be false if a field with the given partial values is on the page' do
      form_page.should_not.have_no_select('Underwear', with_selected: %w[Boxerbriefs Briefs])
    end

    it 'should be true if a field with the given partial values is not on the page' do
      form_page.should.have_no_select('Underwear', with_selected: %w[Boxerbriefs Boxers])
    end

    it 'should be false after the given partial value is selected' do
      form_page.select('Boxers', from: :underwear_select)
      form_page.should_not.have_no_select('Underwear', with_selected: %w[Boxerbriefs Boxers])
    end

    it 'should be true after one of the given partial values is unselected' do
      form_page.unselect('Briefs', from: 'Underwear')
      form_page.should.have_no_select('Underwear', with_selected: %w[Boxerbriefs Briefs])
    end

    it 'should support non array partial values' do
      form_page.should_not.have_no_select('Underwear', with_selected: 'Briefs')
      form_page.should.have_no_select('Underwear', with_selected: 'Boxers')
    end
  end

  context 'with exact options' do
    it 'should be false if a field with the given options is on the page' do
      form_page.should_not.have_no_select('Region', options: %w[Norway Sweden Finland])
    end

    it 'should be true if the given field is not on the page' do
      form_page.should.have_no_select(:locale_select, options: ['Swedish'])
      form_page.should.have_no_select('Does not exist', options: ['John'])
      form_page.should.have_no_select('City', options: ['London', 'Made up city'])
      form_page.should.have_no_select('Region', options: %w[Norway Sweden])
      form_page.should.have_no_select('Region', options: %w[Norway Norway Norway])
    end
  end

  context 'with partial options' do
    it 'should be false if a field with the given partial options is on the page' do
      form_page.should_not.have_no_select('Region', with_options: %w[Norway Sweden])
      form_page.should_not.have_no_select('City', with_options: ['London'])
    end

    it 'should be true if a field with the given partial options is not on the page' do
      form_page.should.have_no_select('Locale', with_options: ['Uruguayan'])
      form_page.should.have_no_select('Does not exist', with_options: ['John'])
      form_page.should.have_no_select('Region', with_options: %w[Norway Sweden Finland Latvia])
    end
  end

  it 'should support locator-less usage' do
    expect(form_page.has_no_select?(with_options: %w[Norway Sweden Finland Latvia])).to eq true
    form_page.should.have_no_select(with_options: ['New London'])
    expect(form_page.has_no_select?(id: 'form_underwear', with_selected: ['Boxers'])).to eq true
    form_page.should.have_no_select(id: 'form_underwear', with_selected: %w[Commando Boxers])
  end
end
