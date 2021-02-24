# frozen_string_literal: true

RSpec.describe Capybara::Compose::Selectors, type: :feature do
  let(:test_helper) { Capybara::TestHelper.new(self) }
  let(:element) { page }
  let(:selectors) {
    {
      el: '.element',
      sibling_el: [:el, ' + ', :el],
      container: '.container',
      wide_container: [:container, '.wide'],
      wrapper: [:wide_container, ' .wrapper, #wrapper'],
      action: [{ name: 'Action' }],
      text_input: [:wrapper, ' input'],
      name_input: [:text_input, attrs: { field: 'name' }],
      bad_selector: [:name_input, '.bad'],

      # Should be able to use any Capybara selectors.
      save_button: [:button, 'Save'],
      parent: [:xpath, '../..'],
      grandpa: [:parent, '/..'],
      car_datalist: [:datalist_input, with_options: %w[Jaguar Audi Mercedes]],
      table_with_columns: [:table, 'Vertical Headers', with_cols: [{ 'First Name' => 'John', 'Last Name' => 'Doe', 'City' => 'Midnight' }]],
      row_with_cells: [:table_row, %w[John Doe]],
      row_with_cells_in_columns: [:table_row, 'First Name' => 'John', 'Last Name' => 'Doe'],
    }
  }

  before(:each) do
    allow(test_helper).to receive(:selectors).and_return(selectors)
  end

  describe 'locator_for' do
    before(:each) do
      allow(test_helper).to receive(:to_capybara_node).and_return(element)
    end

    def expect_locator(*args, **options)
      expect(test_helper.send(:locator_for, *args, **options))
    end

    it 'throws an error if the selector does not exist' do
      expect { test_helper.send(:locator_for, :random) }
        .to raise_error(NotImplementedError, /A selector in Capybara::Compose::TestHelper is not defined/)
    end

    it 'lets invalid structures go through and fail in Capybara' do
      expect_locator(:bad_selector).to eq [
        [
          '.container.wide .wrapper input,' \
          '.container.wide #wrapper input',
          { attrs: { field: 'name' } },
          '.bad',
        ],
        {},
      ]
    end

    it 'works for a simple alias' do
      expect_locator(:container).to eq [['.container'], {}]
    end

    it 'works when only attributes are used in the alias' do
      expect_locator(:action, example: 'Just Attrs').to eq [[], name: 'Action', example: 'Just Attrs']
    end

    it 'can add additional classes' do
      expect_locator(:wide_container, example: 'Appended Class').to eq [
        ['.container.wide'],
        { example: 'Appended Class' },
      ]
    end

    it 'resolves mixed combination' do
      expect_locator(:sibling_el, example: 'Siblings').to eq [['.element + .element'], example: 'Siblings']
    end

    it 'resolves nested selectors' do
      expect_locator(:wrapper, example: 'Multiple Children').to eq [
        [
          '.container.wide .wrapper,'\
          '.container.wide #wrapper',
        ],
        example: 'Multiple Children',
      ]
      expect_locator(:name_input, attrs: { model: 'user' }, example: 'Multiple Children and Grandchildren with Attrs').to eq [
        [
          '.container.wide .wrapper input,'\
          '.container.wide #wrapper input',
        ],
        attrs: { field: 'name', model: 'user' },
        example: 'Multiple Children and Grandchildren with Attrs',
      ]
    end

    it 'works when no alias is provided' do
      expect_locator('.hey').to eq [['.hey'], {}]
      expect_locator(:xpath, './/table/tr').to eq [[:xpath, './/table/tr'], {}]
      expect_locator(:id, 'h2one', text: 'Header Class Test One', exact_text: true).to eq [[:id, 'h2one'], text: 'Header Class Test One', exact_text: true]
      expect_locator(:datalist_input, with_options: %w[Jaguar Audi Mercedes]).to eq [[:datalist_input], with_options: %w[Jaguar Audi Mercedes]]
    end

    it 'works with built-in Capybar selectors' do
      expect_locator(:save_button).to eq [[:button, 'Save'], {}]
      expect_locator(:parent).to eq [[:xpath, '../..'], {}]
      expect_locator(:grandpa).to eq [[:xpath, '../../..'], {}]
      expect_locator(:car_datalist).to eq [[:datalist_input], with_options: %w[Jaguar Audi Mercedes]]
      expect_locator(:table_with_columns).to eq [[:table, 'Vertical Headers'], with_cols: [{ 'First Name' => 'John', 'Last Name' => 'Doe', 'City' => 'Midnight' }]]
      expect_locator(:row_with_cells).to eq [[:table_row, %w[John Doe]], {}]
    end

    it 'should work for table_rows' do
      expect(test_helper).not_to receive(:locator_for)
      expect {
        rows = { 'First Name' => 'John', 'Last Name' => 'Doe' }
        test_helper.should_not.have_selector(:table_row, rows)
      }.not_to raise_error
    end
  end
end
