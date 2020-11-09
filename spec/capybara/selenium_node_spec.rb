# frozen_string_literal: true

RSpec.describe 'Capybara::Node', driver: :chrome_headless, type: :feature do
  describe '#content_editable?', helpers: [:js_page] do
    it 'returns true when the element is content editable' do
      visit_page(:js)
      js_page.first_editable_content.should.be_content_editable
      js_page.editable_content_child.should.be_content_editable
    end

    it 'returns false when the element is not content editable' do
      visit_page(:js)
      js_page.draggable_element.should_not.be_content_editable
    end
  end

  describe '#send_keys' do
    it 'should process space', helpers: [:form_page] do
      visit_page(:form)
      form_page.address_city_input
        .should.have_value('')
        .type_in('ocean').type_in(:shift, :space, 'side')
        .should_now.have_value('ocean SIDE')
    end
  end

  describe '#[]', helpers: [:html_page] do
    it 'should work for spellcheck' do
      visit_page(:html)
      html_page.input_with_spellcheck.should.perform_spellcheck
      html_page.input_without_spellcheck.should_not.perform_spellcheck
    end
  end

  describe '#set' do
    let(:sample_text) { (0...50).map { |i| ((i % 26) + 65).chr }.join }

    it 'respects maxlength when using rapid set', helpers: [:form_page] do
      visit_page(:form)
      form_page.long_input
        .type_in(sample_text, rapid: true)
        .should.have_value(sample_text[0...35])
    end
  end

  describe '#visible?' do
    it 'can use the visible option', helpers: [:form_page] do
      visit_page(:form)
      form_page.address_city_input(visible: true)
      expect { form_page.address_city_input(text: 'NY') }.to raise_error(Capybara::ElementNotFound)
    end
  end
end
