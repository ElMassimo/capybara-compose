# frozen_string_literal: true

class HtmlPageTestHelper < BaseTestHelper
  use_test_helpers(:headings)

# Aliases: Semantic aliases for locators, can be used in most DSL methods.
  aliases(
    # Ancestors Spec
    parent: '#ancestor3',
    child: '#ancestor2',
    grandchild: '#ancestor1',
    grand_grandchild: '#child',

    # Selenium Node Spec
    first_rect: 'div svg rect:first-of-type',
    linear_gradient: [:element, 'linearGradient'],
    draggable_element: '#drag',
    first_subtitle: [:id, 'h2one'],
    pre_sibling: '#pre_sibling',
    mid_sibling: '#mid_sibling',
    editable_content_child: '#existing_content_editable_child',
    first_editable_content: '#existing_content_editable',
    paragraph: [:xpath, '//p'],
    paragraph_link: [:paragraph, '//a[@id="foo"]'],
    link_for_paragraph: 'p a#foo',

    # Have Selector Spec
    first_paragraph_in_xpath: [:paragraph, '[@id="first"]'],
    input_with_spellcheck: [:xpath, '//input[@spellcheck="TRUE"]'],
    input_without_spellcheck: [:xpath, '//input[@spellcheck="FALSE"]'],
    inner_element: ['div *', { visible: :all }],

    # All Spec
    title_or_paragraph: 'h1, p',
    simple_link: 'a.simple',

    # Any of Selectors Spec
    missing_element: 'h2#blah',

    # Have Table Spec
    horizontal_table: [:table, 'Horizontal Headers'],
  )

# Finders: A convenient way to get related data or nested elements.
  delegate :subtitles, to: :headings

  # Public: Override to allow returning page.
  def to_capybara_node
    current_context
  end

  def first_paragraph
    wrap_element headings(self).first(:paragraph)
  end

# Actions: Encapsulate complex actions to provide a cleaner interface.

# Assertions: Allow to check on element properties while keeping it DRY.
  def be_content_editable
    expect(base.content_editable?).to_or not_to, eq(true)
  end

  def perform_spellcheck
    expect(self[:spellcheck]).to eq(not_to ? 'false' : 'true')
  end

  # Internal: Checks the xpath of the current element.
  def have_path(xpath)
    expect(path).to eq xpath
  end

  def be_able_to_find_by_path(element, **options)
    expect(find(:xpath, element.path, **options)).to_or not_to, eq(element)
  end

  def have_table_row(*args)
    have_selector(:table_row, *args)
  end

# Background: Helpers to add/modify/delete data in the database or session.
end
