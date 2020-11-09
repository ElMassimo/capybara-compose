# frozen_string_literal: true

RSpec.feature '#have_selector', test_helpers: [:html_page] do
  before do
    visit_page(:html)
    Capybara.default_selector = :xpath
  end

  after do
    Capybara.default_selector = :css
  end

  it 'should be true if the given selector is on the page' do
    html_page.should.have_selector(:xpath, '//p')
    html_page.should.have_selector(:css, 'p a#foo')
    html_page.should.have_selector("//p[contains(.,'est')]")
  end

  it 'should be false if the given selector is not on the page' do
    html_page.should_not.have_selector(:xpath, '//abbr')
    html_page.should_not.have_selector(:css, 'p a#doesnotexist')
    html_page.should_not.have_selector("//p[contains(.,'thisstringisnotonpage')]")
  end

  it 'should use default selector' do
    Capybara.default_selector = :css
    html_page.should_not.have_selector('p a#doesnotexist')
    html_page.should.have_selector('p a#foo')
  end

  it 'should respect scopes' do
    html_page.within(:first_paragraph_in_xpath) do
      html_page.should.have_selector(".//a[@id='foo']")
      html_page.should_not.have_selector(".//a[@id='red']")
    end
  end

  it 'should accept a filter block' do
    html_page.should.have_selector(:css, 'a', count: 1) { |el|
      expect(el).to be_a(HtmlPageTestHelper)
      el.id == 'foo'
    }
  end

  context 'with count' do
    it 'should be true if the content is on the page the given number of times' do
      html_page.should.have_selector(:paragraph, count: 3)
      html_page.should.have_selector(:paragraph_link, count: 1)
      html_page.should.have_selector("//p[contains(.,'est')]", count: 1)
    end

    it 'should be false if the content is on the page the given number of times' do
      html_page.should_not.have_selector(:paragraph, count: 6)
      html_page.should_not.have_selector(:paragraph_link, count: 2)
      html_page.should_not.have_selector("//p[contains(.,'est')]", count: 5)
    end

    it "should be false if the content isn't on the page at all" do
      html_page.should_not.have_selector('//abbr', count: 2)
      html_page.should_not.have_selector("//p//a[@id='doesnotexist']", count: 1)
    end
  end

  context 'with text' do
    it 'should discard all matches where the given string is not contained' do
      html_page.should.have_selector('//p//a', text: 'Redirect', count: 1)
      html_page.should.have_selector(:css, 'p a', text: 'Redirect', count: 1)
      html_page.should_not.have_selector(:paragraph, text: 'Doesnotexist')
    end

    it 'should respect visibility setting' do
      html_page.should.have_selector(:id, 'hidden-text', text: 'Some of this text is hidden!', visible: :all)
      html_page.should_not.have_selector(:id, 'hidden-text', text: 'Some of this text is hidden!', visible: :visible)
      Capybara.ignore_hidden_elements = false
      html_page.should.have_selector(:id, 'hidden-text', text: 'Some of this text is hidden!', visible: :all)
      Capybara.visible_text_only = true
      html_page.should_not.have_selector(:id, 'hidden-text', text: 'Some of this text is hidden!', visible: :visible)
    end

    it 'should discard all matches where the given regexp is not matched' do
      html_page.should.have_selector('//p//a', text: /re[dab]i/i, count: 1)
      html_page.should_not.have_selector('//p//a', text: /Red$/)
    end

    it 'should raise when extra parameters passed' do
      expect do
        html_page.should.have_selector(:css, 'p a#foo', 'extra')
      end.to raise_error ArgumentError, /extra/
    end

    context 'with whitespace normalization' do
      context 'Capybara.default_normalize_ws = false' do
        it 'should support normalize_ws option' do
          Capybara.default_normalize_ws = false
          html_page.should_not.have_selector(:id, 'second', text: 'text with whitespace')
          html_page.should.have_selector(:id, 'second', text: 'text with whitespace', normalize_ws: true)
        end
      end

      context 'Capybara.default_normalize_ws = true' do
        it 'should support normalize_ws option' do
          Capybara.default_normalize_ws = true
          html_page.should.have_selector(:id, 'second', text: 'text with whitespace')
          html_page.should_not.have_selector(:id, 'second', text: 'text with whitespace', normalize_ws: false)
        end
      end
    end
  end

  context 'with exact_text' do
    context 'string' do
      it 'should only match elements that match exactly' do
        html_page.should.have_selector(:first_subtitle, exact_text: 'Header Class Test One')
        html_page.should.have_no_selector(:first_subtitle, exact_text: 'Header Class Test')
      end
    end

    context 'boolean' do
      it 'should only match elements that match exactly when true' do
        html_page.should.have_selector(:first_subtitle, text: 'Header Class Test One', exact_text: true)
        html_page.should.have_no_selector(:first_subtitle, text: 'Header Class Test', exact_text: true)
      end

      it 'should match substrings when false' do
        html_page.should.have_selector(:first_subtitle, text: 'Header Class Test One', exact_text: false)
        html_page.should.have_selector(:first_subtitle, text: 'Header Class Test', exact_text: false)
      end
    end
  end

  context 'datalist' do
    it 'should match options', test_helpers: [:form_page] do
      visit_page(:form)
      form_page.should.have_selector(:datalist_input, with_options: %w[Jaguar Audi Mercedes])
      form_page.should_not.have_selector(:datalist_input, with_options: %w[Ford Chevy])
    end
  end
end

RSpec.feature '#have_no_selector', test_helpers: [:html_page] do
  before do
    visit_page(:html)
    Capybara.default_selector = :xpath
  end

  it 'should be false if the given selector is on the page' do
    html_page.should_not.have_no_selector(:xpath, '//p')
    html_page.should_not.have_no_selector(:css, 'p a#foo')
    html_page.should_not.have_no_selector("//p[contains(.,'est')]")
  end

  it 'should be true if the given selector is not on the page' do
    html_page.should.have_no_selector(:xpath, '//abbr')
    html_page.should.have_no_selector(:css, 'p a#doesnotexist')
    html_page.should.have_no_selector("//p[contains(.,'thisstringisnotonpage')]")
  end

  it 'should use default selector' do
    Capybara.default_selector = :css
    html_page.should.have_no_selector('p a#doesnotexist')
    html_page.should_not.have_no_selector('p a#foo')
  end

  it 'should respect scopes' do
    html_page.first_paragraph_in_xpath.within do
      html_page.should_not.have_no_selector(".//a[@id='foo']")
      html_page.should.have_no_selector(".//a[@id='red']")
    end
  end

  it 'should accept a filter block' do
    html_page.should.have_no_selector(:css, 'a#foo') { |el|
      expect(el).to be_a(HtmlPageTestHelper)
      el.id != 'foo'
    }
  end

  context 'with count' do
    it 'should be false if the content is on the page the given number of times' do
      html_page.should_not.have_no_selector('//p', count: 3)
      html_page.should_not.have_no_selector(:paragraph_link, count: 1)
      html_page.should_not.have_no_selector("//p[contains(.,'est')]", count: 1)
    end

    it 'should be true if the content is on the page the wrong number of times' do
      html_page.should.have_no_selector('//p', count: 6)
      html_page.should.have_no_selector(:paragraph_link, count: 2)
      html_page.should.have_no_selector("//p[contains(.,'est')]", count: 5)
    end

    it "should be true if the content isn't on the page at all" do
      html_page.should.have_no_selector('//abbr', count: 2)
      html_page.should.have_no_selector("//p//a[@id='doesnotexist']", count: 1)
    end
  end

  context 'with text' do
    it 'should discard all matches where the given string is contained' do
      html_page.should_not.have_no_selector('//p//a', text: 'Redirect', count: 1)
      html_page.should.have_no_selector('//p', text: 'Doesnotexist')
    end

    it 'should discard all matches where the given regexp is matched' do
      html_page.should_not.have_no_selector('//p//a', text: /re[dab]i/i, count: 1)
      html_page.should.have_no_selector('//p//a', text: /Red$/)
    end

    it 'should error when matching element exists' do
      expect do
        html_page.should.have_no_selector('//h2', text: 'Header Class Test Five')
      end.to raise_error RSpec::Expectations::ExpectationNotMetError
    end
  end
end
