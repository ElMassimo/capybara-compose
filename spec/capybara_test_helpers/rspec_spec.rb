# frozen_string_literal: true

RSpec.describe 'Capybara::Compose in RSpec' do
  context 'Type: Other', type: :other do
    it 'should not include Capybara Test Helpers', helpers: [:navigation] do
      expect { navigation }.to raise_error(NameError)
      expect { current_page }.to raise_error(NameError)
      expect { get_test_helper(:current_page) }.to raise_error(NoMethodError)
    end
  end

  context 'Type: Feature', type: :feature do
    it 'should require a helper successfully' do
      visit_page(:foo)
      current_page.body.should.have_content('Another World')
    end

    describe '#all', helpers: [:html_page] do
      it 'can find all elements as expected' do
        visit_page(:html)
        found = html_page.subtitles
        expect(found.size).to eq(5)
      end
    end

    describe '#within', helpers: [:html_page] do
      before do
        Capybara.enable_aria_label = true
      end

      it 'scopes elements as expected' do
        visit_page(:html)

        expect do
          html_page.within('#does_not_exist') { click_link 'Go to simple' }
        end.to raise_error(Capybara::ElementNotFound)

        html_page.first_paragraph.within { click_link 'Go to simple' }
      end
    end
  end
end
