# frozen_string_literal: true

RSpec.feature 'all', test_helpers: [:html_page, :js_page, :form_page] do
  before do
    html_page.visit_page
  end

  it 'should find all elements using the given locator' do
    expect(html_page.all('//p').size).to eq(3)
    expect(html_page.all('//h1').first.text).to eq('This is a test')
    expect(html_page.all("//input[@id='test_field']").first.value).to eq('monkey')
  end

  it 'should return an empty array when nothing was found' do
    expect(html_page.all('//div[@id="nosuchthing"]')).to be_empty
  end

  it 'should wait for matching elements to appear', driver: :chrome_headless do
    Capybara.default_max_wait_time = 2
    js_page.visit_page
    js_page.click_link('Click me')
    expect(js_page.all(:css, 'a#has-been-clicked')).not_to be_empty
  end

  it 'should not wait if `minimum: 0` option is specified', driver: :chrome_headless do
    js_page.visit_page
    js_page.click_link('Click me')
    expect(js_page.all(:css, 'a#has-been-clicked', minimum: 0)).to be_empty
  end

  it 'should accept an XPath instance', driver: :chrome_headless do
    form_page.visit_page
    selector = Capybara::Selector.new(:fillable_field, config: {}, format: :xpath).call('Name')
    expect(selector).to be_a(::XPath::Union)
    result = html_page.all(:xpath, selector).map(&:value)
    expect(result).to include('Smith', 'John', 'John Smith')
  end

  it 'should allow reversing the order' do
    form_page.visit_page
    fields = form_page.all(:name_input, exact: false).to_a
    reverse_fields = form_page.all(:name_input, order: :reverse, exact: false).to_a
    expect(fields).to eq(reverse_fields.reverse)
  end

  it 'should raise an error when given invalid options' do
    expect { html_page.all('//p', schmoo: 'foo') }.to raise_error(ArgumentError)
  end

  it 'should not reload by default', driver: :chrome_headless do
    paras = html_page.all(:css, 'p', minimum: 3)
    expect { paras[0].text }.not_to raise_error
    html_page.refresh
    expect { paras[0].text }.to raise_error do |err|
      expect(err).to be_an_invalid_element_error
    end
  end

  context 'with allow_reload' do
    it 'should reload if true' do
      paras = html_page.all(:css, 'p', allow_reload: true, minimum: 3)
      expect { paras[0].text }.not_to raise_error
      html_page.refresh
      sleep 1 # Ensure page has started to reload
      paras[0].should.have_text('Lorem ipsum dolor').and_not.have_text('Lorem ipsum dolor', exact: true)
      paras[1].should.have_text('Duis aute irure dolor').and_also.have_text(/dolor/)

      html_page.should.have_text(:all, /dolor/, between: 2..4)
    end

    it 'should not reload if false', driver: :chrome_headless do
      paras = html_page.all(:css, 'p', allow_reload: false, minimum: 3)
      expect { paras[0].text }.not_to raise_error
      html_page.refresh
      sleep 1 # Ensure page has started to reload
      expect { paras[0].text }.to raise_error do |err|
        expect(err).to be_an_invalid_element_error
      end
      expect { paras[2].text }.to raise_error do |err|
        expect(err).to be_an_invalid_element_error
      end
    end
  end

  context 'with css selectors' do
    it 'should find all elements using the given selector' do
      expect(html_page.all(:css, 'h1').first.text).to eq('This is a test')
      expect(html_page.all(:css, "input[id='test_field']").first.value).to eq('monkey')
    end

    it 'should find all elements when given a list of selectors' do
      expect(html_page.all(:title_or_paragraph).size).to eq(4)
    end
  end

  context 'with xpath selectors' do
    it 'should find the first element using the given locator' do
      expect(html_page.all(:xpath, '//h1').first.text).to eq('This is a test')
      expect(html_page.all(:xpath, "//input[@id='test_field']").first.value).to eq('monkey')
    end

    it 'should use alternated regex for :id' do
      expect(html_page.all(:xpath, './/h2', id: /h2/).size).to eq 3
      expect(html_page.all(:xpath, './/h2', id: /h2(one|two)/).size).to eq 2
    end
  end

  context 'with css as default selector' do
    before { Capybara.default_selector = :css }

    it 'should find the first element using the given locator' do
      expect(html_page.all('h1').first.text).to eq('This is a test')
      expect(html_page.all("input[id='test_field']").first.value).to eq('monkey')
    end
  end

  context 'with visible filter' do
    it 'should only find visible nodes when true' do
      expect(html_page.all(:simple_link, visible: true).size).to eq(1)
    end

    it 'should find nodes regardless of whether they are invisible when false' do
      expect(html_page.all(:simple_link, visible: false).size).to eq(2)
    end

    it 'should default to Capybara.ignore_hidden_elements' do
      Capybara.ignore_hidden_elements = true
      expect(html_page.all(:simple_link).size).to eq(1)
      Capybara.ignore_hidden_elements = false
      expect(html_page.all(:simple_link).size).to eq(2)
    end
  end

  context 'with obscured filter', driver: :chrome_headless do
    it 'should only find nodes on top in the viewport when false' do
      expect(html_page.all(:simple_link, obscured: false).size).to eq(1)
    end

    it 'should not find nodes on top outside the viewport when false' do
      expect(html_page.all(:link, 'Download Me', obscured: false).size).to eq(0)
      html_page.scroll_to(html_page.find_link('Download Me'))
      expect(html_page.all(:link, 'Download Me', obscured: false).size).to eq(1)
    end

    it 'should find top nodes outside the viewport when true' do
      expect(html_page.all(:link, 'Download Me', obscured: true).size).to eq(1)
      html_page.scroll_to(html_page.find_link('Download Me'))
      expect(html_page.all(:link, 'Download Me', obscured: true).size).to eq(0)
    end

    it 'should only find non-top nodes when true' do
      # Also need visible: false so visibility is ignored
      expect(html_page.all(:simple_link, visible: false, obscured: true).size).to eq(1)
    end
  end

  context 'with element count filters' do
    context ':count' do
      it 'should succeed when the number of elements founds matches the expectation' do
        expect { html_page.all(:title_or_paragraph, count: 4) }.not_to raise_error
      end

      it 'should raise ExpectationNotMet when the number of elements founds does not match the expectation' do
        expect { html_page.all(:title_or_paragraph, count: 5) }.to raise_error(Capybara::ExpectationNotMet)
      end
    end

    context ':minimum' do
      it 'should succeed when the number of elements founds matches the expectation' do
        expect { html_page.all(:title_or_paragraph, minimum: 0) }.not_to raise_error
      end

      it 'should raise ExpectationNotMet when the number of elements founds does not match the expectation' do
        expect { html_page.all(:title_or_paragraph, minimum: 5) }.to raise_error(Capybara::ExpectationNotMet)
      end
    end

    context ':maximum' do
      it 'should succeed when the number of elements founds matches the expectation' do
        expect { html_page.all(:title_or_paragraph, maximum: 4) }.not_to raise_error
      end

      it 'should raise ExpectationNotMet when the number of elements founds does not match the expectation' do
        expect { html_page.all(:title_or_paragraph, maximum: 0) }.to raise_error(Capybara::ExpectationNotMet)
      end
    end

    context ':between' do
      it 'should succeed when the number of elements founds matches the expectation' do
        expect { html_page.all(:title_or_paragraph, between: 2..7) }.not_to raise_error
      end

      it 'should raise ExpectationNotMet when the number of elements founds does not match the expectation' do
        expect { html_page.all(:title_or_paragraph, between: 0..3) }.to raise_error(Capybara::ExpectationNotMet)
      end

      eval <<~TEST, binding, __FILE__, __LINE__ + 1 if RUBY_VERSION.to_f > 2.5
        it'treats an endless range as minimum' do
          expect { html_page.all(:title_or_paragraph, between: 2..) }.not_to raise_error
          expect { html_page.all(:title_or_paragraph, between: 5..) }.to raise_error(Capybara::ExpectationNotMet)
        end
      TEST

      eval <<~TEST, binding, __FILE__, __LINE__ + 1 if RUBY_VERSION.to_f > 2.6
        it'treats a beginless range as maximum' do
          expect { html_page.all(:title_or_paragraph, between: ..7) }.not_to raise_error
          expect { html_page.all(:title_or_paragraph, between: ..3) }.to raise_error(Capybara::ExpectationNotMet)
        end
      TEST
    end

    context 'with multiple count filters' do
      it 'ignores other filters when :count is specified' do
        o = { count: 4,
              minimum: 5,
              maximum: 0,
              between: 0..3 }
        expect { html_page.all(:title_or_paragraph, **o) }.not_to raise_error
      end

      context 'with no :count expectation' do
        it 'fails if :minimum is not met' do
          o = { minimum: 5,
                maximum: 4,
                between: 2..7 }
          expect { html_page.all(:title_or_paragraph, **o) }.to raise_error(Capybara::ExpectationNotMet)
        end

        it 'fails if :maximum is not met' do
          o = { minimum: 0,
                maximum: 0,
                between: 2..7 }
          expect { html_page.all(:title_or_paragraph, **o) }.to raise_error(Capybara::ExpectationNotMet)
        end

        it 'fails if :between is not met' do
          o = { minimum: 0,
                maximum: 4,
                between: 0..3 }
          expect { html_page.all(:title_or_paragraph, **o) }.to raise_error(Capybara::ExpectationNotMet)
        end

        it 'succeeds if all combineable expectations are met' do
          o = { minimum: 0,
                maximum: 4,
                between: 2..7 }
          expect { html_page.all(:title_or_paragraph, **o) }.not_to raise_error
        end
      end
    end
  end

  context 'within a scope' do
    before do
      html_page.visit('/with_scope')
    end

    it 'should find any element using the given locator' do
      html_page.within(:xpath, "//div[@id='for_bar']") do
        expect(html_page.all(:xpath, './/li').size).to eq(2)
      end
    end
  end

  it 'should have #find_all as an alias' do
    expect(Capybara::Node::Finders.instance_method(:all)).to eq Capybara::Node::Finders.instance_method(:find_all)
    expect(html_page.find_all('//p').size).to eq(3)
  end
end
