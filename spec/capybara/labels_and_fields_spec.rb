# frozen_string_literal: true

RSpec.feature 'Label and Field Selectors', test_helpers: [:form_page] do
  before do
    form_page.visit_page
  end

  describe ':label selector' do
    it 'finds a label by text' do
      form_page.find_label('Customer Name').should.have_text('Customer Name')
    end

    it 'finds a label by for attribute string' do
      form_page.find_label(for: 'form_other_title').should.be_labeling('form_other_title')
    end

    it 'finds a label for for attribute regex' do
      form_page.find_label(for: /_other_title/).should.be_labeling('form_other_title')
    end

    it 'finds a label from nested input using :for filter with id string' do
      form_page.find_label(for: 'nested_label').should.have_text('Nested Label')
    end

    it 'finds a label from nested input using :for filter with id regexp' do
      form_page.find_label(for: /nested_lab/).should.have_text('Nested Label')
    end

    it 'finds a label from nested input using :for filter with element' do
      input = form_page.find_by_id('nested_label')
      form_page.find_label(for: input).should.have_text('Nested Label')
    end

    it 'finds a label from nested input using :for filter with element when no id on label' do
      input = form_page.find('#wrapper_label').find('input')
      form_page.find_label(for: input).should.have_text('Wrapper Label')
    end

    it 'finds the label for an non-nested element when using :for filter' do
      select = form_page.find_by_id('form_other_title')
      form_page.find_label(for: select).should.be_labeling('form_other_title')
    end

    context 'with exact option' do
      it 'matches substrings' do
        form_page.find_label('Customer Na', exact: false).should.have_text('Customer Name')
      end

      it "doesn't match substrings" do
        expect { form_page.find_label('Customer Na', exact: true) }.to raise_error(Capybara::ElementNotFound)
      end
    end
  end

  describe 'field selectors' do
    context 'with :id option' do
      it 'can find specifically by id' do
        form_page.find_field(id: 'customer_email').should.have_value('ben@ben.com')
      end

      it 'can find by regex' do
        form_page.find_field(id: /ustomer.emai/).should.have_value('ben@ben.com')
      end

      it 'can find by case-insensitive id' do
        form_page.find_field(id: /StOmer.emAI/i).should.have_value('ben@ben.com')
      end
    end

    it 'can find specifically by name string' do
      form_page.find_field(name: 'form[other_title]').should.have_id('form_other_title')
    end

    it 'can find specifically by name regex' do
      form_page.find_field(name: /form\[other_.*\]/).should.have_id('form_other_title')
    end

    it 'can find specifically by placeholder string' do
      form_page.find_field(placeholder: 'FirstName').should.have_id('form_first_name')
    end

    it 'can find specifically by placeholder regex' do
      form_page.find_field(placeholder: /FirstN.*/).should.have_id('form_first_name')
    end

    it 'can find by type' do
      form_page.find_field('Confusion', type: 'checkbox').should.have_id('confusion_checkbox')
      form_page.find_field('Confusion', type: 'text').should.have_id('confusion_text')
      form_page.find_field('Confusion', type: 'textarea').should.have_id('confusion_textarea')
    end

    it 'can find by class' do
      form_page.find_field(class: 'confusion-checkbox').should.have_id('confusion_checkbox')
      form_page.should.have_selector(:field, class: 'confusion', count: 3)
      form_page.find_field(class: %w[confusion confusion-textarea]).should.have_id('confusion_textarea')
    end
  end
end
