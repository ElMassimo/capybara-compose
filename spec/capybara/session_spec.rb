# frozen_string_literal: true

RSpec.describe 'Capybara::Session', driver: :chrome_headless, type: :feature, helpers: [:js_page, :form_page] do
  describe '#accept_alert', requires: [:modals] do
    it 'supports a blockless mode' do
      visit_page(:js)
      js_page.should.have_content('FooBar')
      js_page.open_and_accept_alert
      expect { page.driver.browser.switch_to.alert }.to raise_error(page.driver.send(:modal_error))
    end
  end

  describe '#fill_in_with empty string and no options' do
    it 'should trigger change when clearing a field' do
      visit_page(:js)
      js_page.clear_field

      # click outside the field to trigger the change event
      current_page.click_outside
      js_page.should.have_triggered_change(match: :one)
    end
  end

  describe '#fill_in with { :clear => :backspace } fill_option', requires: [:js] do
    it 'should fill in a field, replacing an existing value' do
      visit_page(:form)
      form_page.first_name_input
        .fill_in(with: 'Harry', fill_options: { clear: :backspace })
        .should_no_longer.have_value('John')
        .and_instead.have_value('Harry')
    end

    it 'should fill in a field, replacing an existing value, even with caret position' do
      visit_page(:form)
      form_page.first_name_input
        .focus
        .move_caret_to_the_beginning
        .should.have_value('John')
        .fill_in(with: 'Harry', fill_options: { clear: :backspace })
        .should.have_value('Harry')

      form_page.first_name_input
        .should.be_focused
        .blur
        .should_no_longer.be_focused
        .should.not_be_focused # inverted expectation
    end

    it 'should fill in if the option is set via global option' do
      Capybara.default_set_options = { clear: :backspace }
      visit_page(:form)
      form_page
        .fill_in(:first_name_input, with: 'Thomas')
        .should.have_value('Thomas')
    end

    it 'should only trigger onchange once' do
      visit_page(:js)
      js_page.fill_in(:input_with_change_listener, with: 'some value', fill_options: { clear: :backspace })

      # click outside the field to trigger the change event
      js_page.click_another_input
      js_page.change_event(match: :one, wait: 5).should.have_text('some value')
    end

    it 'should trigger change when clearing field' do
      visit_page(:js)
      js_page.fill_in(:input_with_change_listener, with: '', fill_options: { clear: :backspace })

      # click outside the field to trigger the change event
      js_page.click_another_input
      js_page.should.have_triggered_change(match: :one, wait: 5)
    end

    it 'should trigger input event field_value.length times' do
      visit_page(:js)
      js_page.fill_in(:input_with_change_listener, with: '', fill_options: { clear: :backspace })

      # click outside the field to trigger the change event
      js_page.click_a_heading
      js_page.should.have_triggered_input_events(count: 13)
    end
  end

  describe '#fill_in with { clear: :none } fill_options' do
    it 'should append to content in a field' do
      visit_page(:form)
      form_page.first_name_input
        .fill_in(with: 'Harry', fill_options: { clear: :none })
        .should.have_value('JohnHarry')
    end

    it 'works with rapid fill' do
      long_string = (0...60).map { |i| ((i % 26) + 65).chr }.join
      visit_page(:form)
      form_page
        .fill_in(:first_name_input, with: long_string, fill_options: { clear: :none })
        .should.have_value("John#{ long_string }")
    end
  end

  describe '#fill_in with Date' do
    before do
      visit_page(:form)
      form_page.given_the_date_input_has_listeners
    end

    it 'should generate standard events on changing value' do
      form_page.date_input.fill_in(with: Date.today)
      form_page.should.have_date_events(%w[focus input change])
    end

    it 'should not generate input and change events if the value is not changed' do
      form_page.date_input.fill_in(with: Date.today)
      form_page.date_input.fill_in(with: Date.today)
      # Chrome adds an extra focus for some reason - ok for now
      form_page.should.have_date_events(%w[focus input change])
    end
  end

  describe '#fill_in with { clear: Array } fill_options' do
    it 'should pass the array through to the element' do
      # this is mainly for use with [[:control, 'a'], :backspace] - however since that is platform dependant I'm testing with something less useful
      visit_page(:form)

      form_page
        .fill_in(:first_name_input, with: 'Harry', fill_options: { clear: [[:shift, 'abc'], :backspace] })
        .should.have_value('JohnABHarry')

      form_page
        .fill_in(currently_with: 'JohnABHarry', with: 'Harry')
        .should.have_value('Harry')
    end
  end

  describe '#path', helpers: [:html_page] do
    it 'returns xpath' do
      visit_page(:simple)
      html_page.find_link('Second Link').should.have_path('/HTML/BODY[1]/DIV[2]/A[1]')
    end

    it 'handles namespaces in xhtml' do
      visit_page(:namespaced)
      rect = html_page.first_rect
      rect.should.have_path("/HTML/BODY[1]/DIV[1]/*[local-name()='svg' and namespace-uri()='http://www.w3.org/2000/svg'][1]/*[local-name()='rect' and namespace-uri()='http://www.w3.org/2000/svg'][1]")
      html_page.should.be_able_to_find_by_path(rect)
    end

    it 'handles default namespaces in html5' do
      visit_page(:html5)
      rect = html_page.first_rect
      rect.should.have_path("/HTML/BODY[1]/DIV[1]/*[local-name()='svg' and namespace-uri()='http://www.w3.org/2000/svg'][1]/*[local-name()='rect' and namespace-uri()='http://www.w3.org/2000/svg'][1]")
      html_page.should.be_able_to_find_by_path(rect)
    end

    it 'handles case sensitive element names' do
      visit_page(:namespaced)
      expect { html_page.all(:inner_element).map { |el| el.send(:path) } }.not_to raise_error
      lg = html_page.find('div linearGradient', visible: :all)
      html_page.should.be_able_to_find_by_path(lg, visible: :all)
    end
  end

  describe 'all with disappearing elements' do
    it 'ignores stale elements in results' do
      visit_page(:simple)
      elements = current_page.all(:link) { |_node| raise Selenium::WebDriver::Error::StaleElementReferenceError }
      expect(elements.size).to eq 0
    end
  end

  describe '#evaluate_script' do
    it 'can return an element' do
      visit_page(:form)
      element = form_page.evaluate_script("document.getElementById('form_title')")
      expect(element).to eq form_page.title
    end

    it 'can return arrays of nested elements' do
      visit_page(:form)
      elements = form_page.evaluate_script('document.querySelectorAll("#form_city option")')
      expect(elements).to all(be_instance_of Capybara::Node::Element)
      expect(elements).to eq form_page.city_options.to_a
    end

    it 'can return hashes with elements' do
      visit_page(:form)
      result = page.evaluate_script("{ a: document.getElementById('form_title'), b: {c: document.querySelectorAll('#form_city option')}}")
      expect(result).to eq(
        'a' => form_page.title,
        'b' => {
          'c' => form_page.city_options,
        },
      )
    end

    describe '#evaluate_async_script' do
      it 'will timeout if the script takes too long' do
        visit_page(:js)
        expect do
          js_page.using_wait_time(1) do
            js_page.evaluate_async_script('var cb = arguments[0]; setTimeout(function(){ cb(null) }, 3000)')
          end
        end.to raise_error Selenium::WebDriver::Error::ScriptTimeoutError
      end
    end
  end

  describe 'Element#inspect' do
    it 'outputs obsolete elements' do
      visit_page(:form)
      form_page.should_not.have_no_button(:clickable_button) # Testing double negation.

      button = form_page.clickable_button.click
      form_page.should.have_no_button(:clickable_button)

      expect(button).not_to receive(:synchronize)
      expect(button.to_capybara_node.inspect).to eq 'Obsolete #<Capybara::Node::Element>'
      expect(button.inspect).not_to include('button')
    end
  end

  describe 'Element#click' do
    it 'should handle fixed headers/footers' do
      visit_page(:fixed_header_footer)
      page.using_wait_time(2) { current_page.find_link('Go to root').click }
      current_page.should.be(:home)
    end
  end

  describe 'Capybara#Node#attach_file', driver: :chrome_headless do
    it 'can attach a directory', driver: :chrome, skip: ENV['CI'] do
      visit_page(:form)
      form_page.upload_directory
      current_page.body.should.have_content('4 | ') # number of files
    end

    it 'can attach a relative file' do
      visit_page(:form)
      form_page.upload_file('capybara.csv')
      current_page.body.should.have_content('Content-type: text/csv')
    end
  end

  context 'Windows' do
    it "can't close the primary window" do
      expect do
        current_page.close_window
      end.to raise_error(ArgumentError, 'Not allowed to close the primary window')
    end
  end

  describe ':element selector' do
    it 'can find html5 svg elements', helpers: [:html_page] do
      visit_page(:html5)
      html_page.should.have_selector(:element, :svg)
      html_page.should.have_selector(:element, :rect, visible: :visible)
      html_page.should.have_selector(:element, :circle)
      html_page.should.have_selector(:linear_gradient, visible: :all)
    end

    it 'can query attributes with strange characters' do
      visit_page(:form)
      form_page.should.have_selector(:element, "{custom}": true)
      form_page.should.have_selector(:element, "{custom}": 'abcdef')
    end
  end

  describe 'with react', helpers: [:react_page] do
    context 'controlled components' do
      it 'can set and clear a text field' do
        visit_page(:react)
        react_page.submit_name('abc')
        react_page.submit_name('')
      end

      it 'works with rapid fill' do
        long_string = (0...60).map { |i| ((i % 26) + 65).chr }.join
        visit_page(:react)
        react_page.submit_name(long_string)
      end
    end
  end
end
