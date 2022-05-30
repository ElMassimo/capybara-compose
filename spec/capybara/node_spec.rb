# frozen_string_literal: true

RSpec.feature 'node', test_helpers: [:html_page, :form_page, :js_page] do
  before do
    html_page.visit_page
  end

  it 'should act like a session object' do
    form_page.visit_page
    form = form_page.get_form
      .should.have_field('Middle Name')
      .should.have_no_field('Languages')

    form.fill_in('Middle Name', with: 'Monkey')
    form.click_button('med')
    form.should.have_results('middle_name', 'Monkey')
  end

  it 'should scope CSS selectors' do
    html_page.should.have_css('h1')
    html_page.should.have_css('h1')

    html_page.find('#second').should.have_no_css('h1')
    expect(html_page.find('#second')).to have_no_css('h1')
  end

  describe '#query_scope' do
    it 'should have a reference to the element the query was evaluated on if there is one' do
      node = html_page.find('#first')
      expect(node.to_capybara_node.query_scope).to eq(node.page.document)
      expect(node.find('#foo').to_capybara_node.query_scope).to eq(node)
    end
  end

  describe '#text' do
    it 'should extract node texts' do
      expect(html_page.all('//a')[0].text).to eq('labore')
      expect(html_page.all('//a')[1].text).to eq('ullamco')
    end

    it 'should return document text on /html selector' do
      visit('/with_simple_html')
      expect(html_page.all('/html')[0].text).to eq('Bar')
    end
  end

  describe '#[]' do
    it 'should extract node attributes' do
      expect(html_page.all('//a')[0][:class]).to eq('simple')
      expect(html_page.all('//a')[1][:id]).to eq('foo')
      expect(html_page.all('//input')[0][:type]).to eq('text')
    end

    it 'should extract boolean node attributes' do
      expect(html_page.find(:xpath, '//input[@id="checked_field"]')[:checked]).to be_truthy
    end
  end

  describe '#style', driver: :chrome_headless do
    it 'should return the computed style value' do
      expect(html_page.find('#first').style('display')).to eq('display' => 'block')
      expect(html_page.find('#second').style(:display)).to eq('display' => 'inline')
    end

    it 'should return multiple style values' do
      expect(html_page.find('#first').style('display', :'line-height')).to eq('display' => 'block', 'line-height' => '25px')
      expect(html_page.find('#first').style(:color, 'font-size')).to eq('color' => 'rgba(0, 0, 0, 1)', 'font-size' => '16px')
    end
  end

  describe '#value' do
    it 'should allow retrieval of the value' do
      html_page.find(:xpath, '//textarea[@id="normal"]').should.have_value('banana')
    end

    it 'should not swallow extra newlines in textarea' do
      html_page.find(:xpath, '//textarea[@id="additional_newline"]').should.have_value("\nbanana")
    end

    it 'should not swallow leading newlines for set content in textarea' do
      html_page.find(:xpath, '//textarea[@id="normal"]')
        .set("\nbanana")
        .should.have_value("\nbanana")
    end

    it 'return any HTML content in textarea' do
      html_page.find(:xpath, '//textarea[1]')
        .set('some <em>html</em> here')
        .should.have_value('some <em>html</em> here')
    end

    it "defaults to 'on' for checkbox" do
      form_page.visit_page
      form_page.find(:xpath, '//input[@id="valueless_checkbox"]').should.have_value('on')
    end

    it "defaults to 'on' for radio buttons" do
      form_page.visit_page
      form_page.find(:xpath, '//input[@id="valueless_radio"]').should.have_value('on')
    end
  end

  describe '#set' do
    it 'should allow assignment of field value' do
      html_page.first(:xpath, '//input')
        .should.have_value('monkey')
        .set('gorilla')
        .should.have_value('gorilla')

      expect { html_page.first(:xpath, '//input').should.have_value('monkey') }
        .to raise_error(RSpec::Expectations::ExpectationNotMetError, /got: "gorilla"/)
    end

    it 'should fill the field even if the caret was not at the end', driver: :chrome_headless do
      form_page.find_by_id('test_field')
        .focus.move_caret_to_the_beginning
        .set('')
        .should.have_value('')
    end

    it 'should not change if the text field is readonly' do
      html_page.first(:xpath, '//input[@readonly]')
        .set('changed')
        .should_not.have_value('changed')
        .should.have_value('should not change')
    end

    it 'should not change if the textarea is readonly' do
      html_page.first(:xpath, '//textarea[@readonly]')
        .set('changed')
        .should_not.have_value('changed')
        .should.have_value('textarea should not change')
    end

    it 'should use global default options' do
      Capybara.default_set_options = { clear: :backspace }
      element = html_page.first(:fillable_field, type: 'text')
      allow(element.base).to receive(:set)
      element.set('gorilla')
      expect(element.base).to have_received(:set).with('gorilla', clear: :backspace)
    end

    context 'with a contenteditable element', driver: :chrome_headless do
      it 'should allow me to change the contents' do
        js_page.visit_page
        html_page.find('#existing_content_editable').set('WYSIWYG')
        expect(html_page.find('#existing_content_editable').text).to eq('WYSIWYG')
      end

      it 'should allow me to set the contents' do
        js_page.visit_page
        html_page.find('#blank_content_editable').set('WYSIWYG')
        expect(html_page.find('#blank_content_editable').text).to eq('WYSIWYG')
      end

      it 'should allow me to change the contents of a child element' do
        js_page.visit_page
        html_page.find('#existing_content_editable_child').set('WYSIWYG')
        expect(html_page.find('#existing_content_editable_child').text).to eq('WYSIWYG')
        expect(html_page.find('#existing_content_editable_child_parent').text).to eq("Some content\nWYSIWYG")
      end
    end
  end

  describe '#tag_name' do
    it 'should extract node tag name' do
      expect(html_page.all('//a')[0].tag_name).to eq('a')
      expect(html_page.all('//a')[1].tag_name).to eq('a')
      expect(html_page.all('//p')[1].tag_name).to eq('p')
    end
  end

  describe '#disabled?' do
    before do
      form_page.visit_page
    end

    it 'should extract disabled node' do
      form_page.find(:xpath, '//input[@id="customer_name"]')
        .should.be_disabled
        .should.match_css(':disabled')

      form_page.find(:xpath, '//input[@id="customer_email"]')
        .should_not.be_disabled
        .should_not.match_css(':disabled')
    end

    it 'should see disabled options as disabled' do
      form_page.find(:xpath, '//select[@id="form_title"]/option[1]').should_not.be_disabled
      form_page.find(:xpath, '//select[@id="form_title"]/option[@disabled]').should.be_disabled
    end

    it 'should see enabled options in disabled select as disabled' do
      form_page.find(:xpath, '//select[@id="form_disabled_select"]/option').should.be_disabled
      form_page.find(:xpath, '//select[@id="form_disabled_select"]/optgroup/option').should.be_disabled
      form_page.find(:xpath, '//select[@id="form_title"]/option[1]').should_not.be_disabled
    end

    it 'should see enabled options in disabled optgroup as disabled' do
      form_page.find(:xpath, '//option', text: 'A.B.1').should.be_disabled
      form_page.find(:xpath, '//option', text: 'A.2').should_not.be_disabled
    end

    it 'should see a disabled fieldset as disabled' do
      form_page.find(:xpath, './/fieldset[@id="form_disabled_fieldset"]').should.be_disabled
    end

    context 'in a disabled fieldset' do
      # https://html.spec.whatwg.org/#the-fieldset-element
      it 'should see elements not in first legend as disabled' do
        form_page.find(:xpath, '//input[@id="form_disabled_fieldset_child"]').should.be_disabled
        form_page.find(:xpath, '//input[@id="form_disabled_fieldset_second_legend_child"]').should.be_disabled
        form_page.find(:xpath, '//input[@id="form_enabled_fieldset_child"]').should_not.be_disabled
      end

      it 'should see elements in first legend as enabled' do
        form_page.find(:xpath, '//input[@id="form_disabled_fieldset_legend_child"]').should_not.be_disabled
      end

      it 'should sees options not in first legend as disabled' do
        form_page.find(:xpath, '//option', text: 'Disabled Child Option').should.be_disabled
      end
    end

    it 'should be disabled for all elements that are CSS :disabled' do
      # sanity check
      expect(form_page.all(':disabled')).to all(be_disabled)
    end
  end

  describe '#visible?' do
    before { Capybara.ignore_hidden_elements = false }

    it 'should extract node visibility' do
      html_page.first(:xpath, '//a').should.be_visible

      html_page.find(:xpath, '//div[@id="hidden"]').should_not.be_visible
      html_page.find(:xpath, '//div[@id="hidden_via_ancestor"]').should_not.be_visible
      html_page.find(:xpath, '//div[@id="hidden_attr"]').should_not.be_visible
      html_page.find(:xpath, '//a[@id="hidden_attr_via_ancestor"]').should_not.be_visible
      html_page.find(:xpath, '//input[@id="hidden_input"]').should_not.be_visible
    end

    it 'template elements should not be visible' do
      html_page.find(:xpath, '//template').should_not.be_visible
    end

    it 'closed details > summary elements and descendants should be visible' do
      html_page.find('#closed_details summary').should.be_visible
      html_page.find('#closed_details summary h6').should.be_visible
    end

    it 'details non-summary descendants should be non-visible when closed' do
      descendants = html_page.all('#closed_details > *:not(summary), #closed_details > *:not(summary) *', minimum: 2)
      expect(descendants).not_to include(be_visible)
    end

    it 'deatils descendants should be visible when open' do
      expect(html_page.all('#open_details *')).to all(be_visible)
    end

    it 'works when details is toggled open and closed' do
      html_page.find('#closed_details > summary').click
      html_page.should.have_css('#closed_details *', visible: :visible, count: 5)
        .and(have_no_css('#closed_details *', visible: :hidden))

      html_page.find('#closed_details > summary').click
      descendants_css = '#closed_details > *:not(summary), #closed_details > *:not(summary) *'
      expect(html_page).to have_no_css(descendants_css, visible: :visible)
        .and(have_css(descendants_css, visible: :hidden, count: 3))
    end
  end

  describe '#obscured?', driver: :chrome_headless do
    it 'should see non visible elements as obscured' do
      Capybara.ignore_hidden_elements = false
      html_page.find(:xpath, '//div[@id="hidden"]').should.be_obscured
      html_page.find(:xpath, '//div[@id="hidden_via_ancestor"]').should.be_obscured
      html_page.find(:xpath, '//div[@id="hidden_attr"]').should.be_obscured
      html_page.find(:xpath, '//a[@id="hidden_attr_via_ancestor"]').should.be_obscured
      html_page.find(:xpath, '//input[@id="hidden_input"]').should.be_obscured
    end

    it 'should see non-overlapped elements as not obscured' do
      visit('/obscured')
      html_page.find('#cover').should_not.be_obscured
    end

    it 'should see elements only overlapped by descendants as not obscured' do
      html_page.first('p:not(.para)').should_not.be_obscured
    end

    it 'should see elements outside the viewport as obscured' do
      visit('/obscured')
      off = html_page.find('#offscreen')
      off_wrapper = html_page.find('#offscreen_wrapper')
      expect(off).to be_obscured
      expect(off_wrapper).to be_obscured
      html_page.scroll_to(off_wrapper)
      expect(off_wrapper).not_to be_obscured
      expect(off).to be_obscured
      off_wrapper.scroll_to(off)
      expect(off).not_to be_obscured
      expect(off_wrapper).not_to be_obscured
    end

    it 'should see overlapped elements as obscured' do
      visit('/obscured')
      html_page.find('#obscured').should.be_obscured
    end

    it 'should work in frames' do
      visit('/obscured')
      html_page.within_frame('frameOne') do
        div = html_page.find('#divInFrameOne').should.be_obscured
        html_page.scroll_to(div)
        div.should_no_longer.be_obscured
      end
    end

    it 'should work in nested iframes' do
      visit('/obscured')
      html_page.within_frame('nestedFrames') do
        html_page.within_frame(:css, '#childFrame') do
          gcframe = html_page.find('#grandchildFrame2')
          html_page.within_frame(gcframe.to_capybara_node) do
            html_page.find('#divInFrameTwo').should.be_obscured
          end
          html_page.scroll_to(gcframe)
          html_page.within_frame(gcframe.to_capybara_node) do
            html_page.find('#divInFrameTwo').should_not.be_obscured
            expect { html_page.find('#divInFrameTwo').should.be_obscured }
              .to raise_error(RSpec::Expectations::ExpectationNotMetError, /expected #<Capybara::Node::Element tag="div" .*> to be obscured/)
          end
        end
      end
    end
  end

  describe '#checked?' do
    it 'should extract node checked state' do
      form_page.visit_page
      form_page.find(:xpath, '//input[@id="gender_female"]').should.be_checked
      form_page.find(:xpath, '//input[@id="gender_male"]').should_not.be_checked
      form_page.first(:xpath, '//h1').should_not.be_checked
      expect { form_page.first(:xpath, '//h1').should.be_checked }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end
  end

  describe '#selected?' do
    it 'should extract node selected state' do
      form_page.visit_page
      form_page.find(:xpath, '//option[@value="en"]').should.be_selected
      form_page.find(:xpath, '//option[@value="sv"]').should_not.be_selected
      form_page.first(:xpath, '//h1').should_not.be_selected
      expect { form_page.first(:xpath, '//h1').should.be_selected }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end
  end

  describe '#==' do
    it 'preserve object identity' do
      expect(html_page.find(:xpath, '//h1') == html_page.find(:xpath, '//h1')).to be true
      expect(html_page.find(:xpath, '//h1') == html_page.find(:xpath, '//h1').to_capybara_node).to be true
      expect(html_page.find(:xpath, '//h1') === html_page.find(:xpath, '//h1')).to be true # rubocop:disable Style/CaseEquality
      expect(html_page.find(:xpath, '//h1').eql?(html_page.find(:xpath, '//h1'))).to be false
    end

    it 'returns false for unrelated object' do
      expect(html_page.find(:xpath, '//h1') == 'Not Capybara::Node::Base').to be false
      expect(html_page.find(:xpath, '//h1') == html_page.find(:xpath, '//h2', match: :first)).to be false
    end
  end

  describe '#path' do
    # Testing for specific XPaths here doesn't make sense since there
    # are many that can refer to the same element
    before do
      visit('/path')
    end

    it 'returns xpath which points to itself' do
      element = html_page.find(:link, 'Second Link')
      expect(html_page.find(:xpath, element.path)).to eq(element)
    end
  end

  describe '#drag_to', driver: :chrome_headless do
    it 'should drag and drop an object' do
      js_page.visit_page
      element = js_page.find(:xpath, '//div[@id="drag"]')
      target = js_page.find(:xpath, '//div[@id="drop"]')
      element.drag_to(target)
      js_page.should.have_dropped_element
    end

    it 'should drag and drop if scrolling is needed' do
      js_page.visit_page
      element = js_page.find(:xpath, '//div[@id="drag_scroll"]')
      target = js_page.find(:xpath, '//div[@id="drop_scroll"]')
      element.drag_to(target)
      js_page.should.have_dropped_element
    end

    it 'should drag a link' do
      js_page.visit_page
      link = js_page.find_link('drag_link')
      target = js_page.find(:id, 'drop')
      link.drag_to target
      js_page.should.have_dropped_element
    end

    it 'should work with Dragula' do
      visit('/with_dragula')
      js_page.within('#sortable.ready') do
        src = js_page.find('div', text: 'Item 1')
        target = js_page.find('div', text: 'Item 3')
        src.drag_to target
        html_page.should.have_content(/Item 2.*Item 1/, normalize_ws: true)
      end
    end

    it 'should work with jsTree' do
      visit('/with_jstree')
      js_page.within('#container') do
        js_page.assert_text(/A.*B.*C/m)
        source = js_page.find('#j1_1_anchor')
        target = js_page.find('#j1_2_anchor')

        source.drag_to(target)

        js_page.assert_no_text(/A.*B.*C/m)
        js_page.assert_text(/B.*C/m)
      end
    end

    it 'should simulate a single held down modifier key' do
      %I[
        alt
        ctrl
        meta
        shift
      ].each do |modifier_key|
        js_page.visit_page

        element = js_page.find(:xpath, '//div[@id="drag"]')
        target = js_page.find(:xpath, '//div[@id="drop"]')

        element.drag_to(target, drop_modifiers: modifier_key)
        js_page.should.have_css('div.drag_start', exact_text: 'Dragged!')
        js_page.should.have_dropped_element(modifier_key)
      end
    end

    it 'should simulate multiple held down modifier keys' do
      js_page.visit_page

      element = js_page.find(:xpath, '//div[@id="drag"]')
      target = js_page.find(:xpath, '//div[@id="drop"]')

      modifier_keys = %I[alt ctrl meta shift]

      element.drag_to(target, drop_modifiers: modifier_keys)
      js_page.should.have_dropped_element(*modifier_keys)
    end

    it 'should support key aliases' do
      { control: :ctrl,
        command: :meta,
        cmd: :meta }.each do |(key_alias, key)|
        js_page.visit_page

        element = js_page.find(:xpath, '//div[@id="drag"]')
        target = js_page.find(:xpath, '//div[@id="drop"]')

        element.drag_to(target, drop_modifiers: [key_alias])
        target.should.have_text("Dropped!-#{ key }", exact: true)
      end
    end

    context 'HTML5', driver: :chrome_headless do
      it 'should HTML5 drag and drop an object' do
        js_page.visit_page
        element = js_page.find(:xpath, '//div[@id="drag_html5"]')
        target = js_page.find(:xpath, '//div[@id="drop_html5"]')
        element.drag_to(target)
        expect(js_page).to have_xpath('//div[contains(., "HTML5 Dropped string: text/plain drag_html5")]')
      end

      it 'should HTML5 drag and drop an object child' do
        js_page.visit_page
        element = js_page.find(:xpath, '//div[@id="drag_html5"]/p')
        target = js_page.find(:xpath, '//div[@id="drop_html5"]')
        element.drag_to(target)
        expect(js_page).to have_xpath('//div[contains(., "HTML5 Dropped string: text/plain drag_html5")]')
      end

      it 'should set clientX/Y in dragover events' do
        js_page.visit_page
        element = js_page.find(:xpath, '//div[@id="drag_html5"]')
        target = js_page.find(:xpath, '//div[@id="drop_html5"]')
        element.drag_to(target)
        js_page.should.have_css('div.log', text: /DragOver with client position: [1-9]\d*,[1-9]\d*/, count: 2)
      end

      it 'should preserve clientX/Y from last dragover event' do
        js_page.visit_page
        element = js_page.find(:xpath, '//div[@id="drag_html5"]')
        target = js_page.find(:xpath, '//div[@id="drop_html5"]')
        element.drag_to(target)

        conditions = %w[DragLeave Drop DragEnd].map do |text|
          have_css('div.log', text: text)
        end
        expect(js_page).to(conditions.reduce { |memo, cond| memo.and(cond) })

        # The first "DragOver" div is inserted by the last dragover event dispatched
        drag_over_div = js_page.first(:xpath, '//div[@class="log" and starts-with(text(), "DragOver")]')
        position = drag_over_div.text.sub('DragOver ', '')

        js_page.should.have_css('div.log', text: /DragLeave #{ position }/, count: 1)
        js_page.should.have_css('div.log', text: /Drop #{ position }/, count: 1)
        js_page.should.have_css('div.log', text: /DragEnd #{ position }/, count: 1)
      end

      it 'should not HTML5 drag and drop on a non HTML5 drop element' do
        js_page.visit_page
        element = js_page.find(:xpath, '//div[@id="drag_html5"]')
        target = js_page.find(:xpath, '//div[@id="drop_html5"]')
        target.execute_script("$(this).removeClass('drop');")
        element.drag_to(target)
        sleep 1
        expect(js_page).not_to have_xpath('//div[contains(., "HTML5 Dropped")]')
      end

      it 'should HTML5 drag and drop when scrolling needed' do
        js_page.visit_page
        element = js_page.find(:xpath, '//div[@id="drag_html5_scroll"]')
        target = js_page.find(:xpath, '//div[@id="drop_html5_scroll"]')
        element.drag_to(target)
        expect(js_page).to have_xpath('//div[contains(., "HTML5 Dropped string: text/plain drag_html5_scroll")]')
      end

      it 'should drag HTML5 default draggable elements' do
        js_page.visit_page
        link = js_page.find_link('drag_link_html5')
        target = js_page.find(:id, 'drop_html5')
        link.drag_to target
        expect(js_page).to have_xpath('//div[contains(., "HTML5 Dropped")]')
      end

      it 'should drag HTML5 default draggable element child' do
        js_page.visit_page
        source = js_page.find_link('drag_link_html5').find('p')
        target = js_page.find(:id, 'drop_html5')
        source.drag_to target
        expect(js_page).to have_xpath('//div[contains(., "HTML5 Dropped")]')
      end

      it 'should simulate a single held down modifier key' do
        %I[alt ctrl meta shift].each do |modifier_key|
          js_page.visit_page

          element = js_page.find(:xpath, '//div[@id="drag_html5"]')
          target = js_page.find(:xpath, '//div[@id="drop_html5"]')

          element.drag_to(target, drop_modifiers: modifier_key)

          js_page.should.have_css('div.drag_start', exact_text: 'HTML5 Dragged!')
          expect(js_page).to have_xpath("//div[contains(., 'HTML5 Dropped string: text/plain drag_html5-#{ modifier_key }')]")
        end
      end

      it 'should simulate multiple held down modifier keys' do
        js_page.visit_page

        element = js_page.find(:xpath, '//div[@id="drag_html5"]')
        target = js_page.find(:xpath, '//div[@id="drop_html5"]')

        modifier_keys = %I[alt ctrl meta shift]

        element.drag_to(target, drop_modifiers: modifier_keys)
        expect(js_page).to have_xpath("//div[contains(., 'HTML5 Dropped string: text/plain drag_html5-#{ modifier_keys.join('-') }')]")
      end

      it 'should support key aliases' do
        { control: :ctrl,
          command: :meta,
          cmd: :meta }.each do |(key_alias, key)|
          js_page.visit_page

          element = js_page.find(:xpath, '//div[@id="drag_html5"]')
          target = js_page.find(:xpath, '//div[@id="drop_html5"]')

          element.drag_to(target, drop_modifiers: [key_alias])
          target.should.have_text(%r{^HTML5 Dropped string: text/plain drag_html5-#{ key }$}m, exact: true)
        end
      end
    end
  end

  describe 'Element#drop', driver: :chrome_headless do
    it 'can drop a file' do
      js_page.visit_page
      js_page.drop_target
        .drop_file('capybara.jpg')
        .should.have_dropped('file: capybara.jpg')
    end

    it 'can drop multiple files' do
      js_page.visit_page
      js_page.drop_target
        .drop_file('capybara.jpg', 'test_file.txt')
        .should.have_dropped('file: capybara.jpg')
        .should.have_dropped('file: test_file.txt')
    end

    it 'can drop strings' do
      js_page.visit_page
      js_page.drop_target
        .drop('text/plain' => 'Some dropped text')
        .should.have_dropped('string: text/plain Some dropped text')
    end

    it 'can drop multiple strings' do
      js_page.visit_page
      js_page.drop_target
        .drop('text/plain' => 'Some dropped text', 'text/url' => 'http://www.google.com')
        .should.have_dropped('string: text/plain Some dropped text')
        .should.have_dropped('string: text/url http://www.google.com')
    end
  end

  describe '#hover', driver: :chrome_headless do
    it 'should allow hovering on an element' do
      visit('/with_hover')
      revealed_on_hover = js_page.find('.wrapper:not(.scroll_needed) .hidden_until_hover', visible: false)

      revealed_on_hover.should_not.be_visible
      js_page.find('.wrapper:not(.scroll_needed)').hover
      revealed_on_hover.should_now.be_visible
    end

    it 'should allow hovering on an element that needs to be scrolled into view' do
      visit('/with_hover')
      revealed_on_hover = js_page.find('.wrapper.scroll_needed .hidden_until_hover', visible: false)

      revealed_on_hover.should_not.be_visible
      js_page.find('.wrapper.scroll_needed').hover
      revealed_on_hover.should_now.be_visible
    end

    it 'should hover again after following a link and back' do
      visit('/with_hover')
      js_page.find('.wrapper:not(.scroll_needed)').hover
      js_page.click_link('Other hover page')
      js_page.click_link('Go back')
      js_page.find('.wrapper:not(.scroll_needed)').hover
        .find('.hidden_until_hover', visible: false).should.be_visible
    end
  end

  describe '#click' do
    it 'should not follow a link if no href' do
      html_page.find('#link_placeholder').click
      expect(html_page.current_url).to match(%r{/with_html$})
    end

    it 'should go to the same page if href is blank' do
      html_page.find('#link_blank_href').click
      sleep 1
      expect(html_page).to have_current_path('/with_html')
    end

    it 'should be able to check a checkbox' do
      form_page.visit_page
      form_page.find(:checkbox, 'form_terms_of_use')
        .should_not.be_checked
        .click
        .should.be_checked
    end

    it 'should be able to uncheck a checkbox' do
      form_page.visit_page
      form_page.find(:checkbox, 'form_pets_dog')
        .should.be_checked
        .click
        .should_not.be_checked
    end

    it 'should be able to select a radio button' do
      form_page.visit_page
      form_page.find(:radio_button, 'gender_male')
        .should_not.be_checked
        .click
        .should.be_checked
    end

    it 'should allow modifiers', driver: :chrome_headless do
      js_page.visit_page
      html_page.find('#click-test').click(:shift)
      expect(html_page).to have_link('Has been shift clicked')
    end

    it 'should allow multiple modifiers', driver: :chrome_headless do
      js_page.visit_page
      html_page.find('#click-test').click(:control, :alt, :meta, :shift)
      # Selenium with Chrome on OSX ctrl-click generates a right click so just verify all keys but not click type
      expect(html_page).to have_link('alt control meta shift')
    end

    it 'should allow to adjust the click offset', driver: :chrome_headless do
      js_page.visit_page
      html_page.find('#click-test').click(x: 5, y: 5)
      link = html_page.find(:link, 'has-been-clicked')
      locations = link.text.match(/^Has been clicked at (?<x>[\d.-]+),(?<y>[\d.-]+)$/)
      # Resulting click location should be very close to 0, 0 relative to top left corner of the element, but may not be exact due to
      # integer/float conversions and rounding.
      expect(locations[:x].to_f).to be_within(1).of(5)
      expect(locations[:y].to_f).to be_within(1).of(5)
    end

    it 'should raise error if both x and y values are not passed' do
      js_page.visit_page
      el = html_page.find('#click-test')
      expect { el.click(x: 5) }.to raise_error ArgumentError
      expect { el.click(x: nil, y: 3) }.to raise_error ArgumentError
    end

    it 'should be able to click a table row', driver: :chrome_headless do
      visit('/tables')
      html_page.find('#agent_table tr:first-child').click
        .should.have_css('label', text: 'Clicked')
    end

    it 'should retry clicking', driver: :chrome_headless do
      visit('/animated')
      obscured = html_page.find('#obscured')
      html_page.execute_script("setTimeout(function(){ $('#cover').hide(); }, 700)")
      expect { obscured.click }.not_to raise_error
    end

    it 'should allow to retry longer', driver: :chrome_headless do
      visit('/animated')
      obscured = html_page.find('#obscured')
      html_page.execute_script("setTimeout(function(){ $('#cover').hide(); }, 3000)")
      expect { obscured.click(wait: 4) }.not_to raise_error
    end

    it 'should not retry clicking when wait is disabled', driver: :chrome_headless do
      visit('/animated')
      obscured = html_page.find('#obscured')
      html_page.execute_script("setTimeout(function(){ $('#cover').hide(); }, 2000)")
      expect { obscured.click(wait: 0) }.to(raise_error { |e| expect(e).to be_an_invalid_element_error })
    end

    context 'offset', driver: :chrome_headless do
      before do
        visit('/offset')
      end

      let :clicker do
        html_page.find(:id, 'clicker')
      end

      context 'when w3c_click_offset is false' do
        before do
          Capybara.w3c_click_offset = false
        end

        it 'should offset from top left of element' do
          clicker.click(x: 10, y: 5)
          html_page.should.have_text(/clicked at 110,105/)
        end

        it 'should offset outside the element' do
          clicker.click(x: -15, y: -10)
          html_page.should.have_text(/clicked at 85,90/)
        end

        it 'should default to click the middle' do
          clicker.click
          html_page.should.have_text(/clicked at 150,150/)
        end
      end

      context 'when w3c_click_offset is true' do
        before do
          Capybara.w3c_click_offset = true
        end

        it 'should offset from center of element' do
          clicker.click(x: 10, y: 5)
          html_page.should.have_text(/clicked at 160,155/)
        end

        it 'should offset outside from center of element' do
          clicker.click(x: -65, y: -60)
          html_page.should.have_text(/clicked at 85,90/)
        end

        it 'should default to click the middle' do
          clicker.click
          html_page.should.have_text(/clicked at 150,150/)
        end
      end
    end

    context 'delay', driver: :chrome_headless do
      it 'should delay the mouse up' do
        js_page.visit_page
        html_page.find('#click-test').click(delay: 2)
        delay = html_page.evaluate_script('window.click_delay')
        expect(delay).to be >= 2
      end
    end
  end

  describe '#double_click', driver: :chrome_headless do
    it 'should double click an element' do
      js_page.visit_page
      html_page.find('#click-test').double_click
      html_page.should.have_css('#has-been-double-clicked')
    end

    it 'should allow modifiers', driver: :chrome_headless do
      js_page.visit_page
      html_page.find('#click-test').double_click(:alt)
      expect(html_page).to have_link('Has been alt double clicked')
    end

    it 'should allow to adjust the offset', driver: :chrome_headless do
      js_page.visit_page
      html_page.find('#click-test').double_click(x: 10, y: 5)
      link = html_page.find(:link, 'has-been-double-clicked')
      locations = link.text.match(/^Has been double clicked at (?<x>[\d.-]+),(?<y>[\d.-]+)$/)
      # Resulting click location should be very close to 10, 5 relative to top left corner of the element, but may not be exact due
      # to integer/float conversions and rounding.
      expect(locations[:x].to_f).to be_within(1).of(10)
      expect(locations[:y].to_f).to be_within(1).of(5)
    end

    it 'should retry clicking', driver: :chrome_headless do
      visit('/animated')
      obscured = html_page.find('#obscured')
      html_page.execute_script("setTimeout(function(){ $('#cover').hide(); }, 700)")
      expect { obscured.double_click }.not_to raise_error
    end

    context 'offset', driver: :chrome_headless do
      before do
        visit('/offset')
      end

      let :clicker do
        html_page.find(:id, 'clicker')
      end

      context 'when w3c_click_offset is false' do
        before do
          Capybara.w3c_click_offset = false
        end

        it 'should offset from top left of element' do
          clicker.double_click(x: 10, y: 5)
          html_page.should.have_text(/clicked at 110,105/)
        end

        it 'should offset outside the element' do
          clicker.double_click(x: -15, y: -10)
          html_page.should.have_text(/clicked at 85,90/)
        end

        it 'should default to click the middle' do
          clicker.double_click
          html_page.should.have_text(/clicked at 150,150/)
        end
      end

      context 'when w3c_click_offset is true' do
        before do
          Capybara.w3c_click_offset = true
        end

        it 'should offset from center of element' do
          clicker.double_click(x: 10, y: 5)
          html_page.should.have_text(/clicked at 160,155/)
        end

        it 'should offset outside from center of element' do
          clicker.double_click(x: -65, y: -60)
          html_page.should.have_text(/clicked at 85,90/)
        end

        it 'should default to click the middle' do
          clicker.double_click
          html_page.should.have_text(/clicked at 150,150/)
        end
      end
    end
  end

  describe '#right_click', driver: :chrome_headless do
    it 'should right click an element' do
      js_page.visit_page
      html_page.find('#click-test').right_click
      html_page.should.have_css('#has-been-right-clicked')
    end

    it 'should allow modifiers', driver: :chrome_headless do
      js_page.visit_page
      html_page.find('#click-test').right_click(:meta)
      expect(html_page).to have_link('Has been meta right clicked')
    end

    it 'should allow to adjust the offset', driver: :chrome_headless do
      js_page.visit_page
      html_page.find('#click-test').right_click(x: 10, y: 10)
      link = html_page.find(:link, 'has-been-right-clicked')
      locations = link.text.match(/^Has been right clicked at (?<x>[\d.-]+),(?<y>[\d.-]+)$/)
      # Resulting click location should be very close to 10, 10 relative to top left corner of the element, but may not be exact due
      # to integer/float conversions and rounding
      expect(locations[:x].to_f).to be_within(1).of(10)
      expect(locations[:y].to_f).to be_within(1).of(10)
    end

    it 'should retry clicking', driver: :chrome_headless do
      visit('/animated')
      obscured = html_page.find('#obscured')
      html_page.execute_script("setTimeout(function(){ $('#cover').hide(); }, 700)")
      expect { obscured.right_click }.not_to raise_error
    end

    context 'offset', driver: :chrome_headless do
      before do
        visit('/offset')
      end

      let :clicker do
        html_page.find(:id, 'clicker')
      end

      context 'when w3c_click_offset is false' do
        before do
          Capybara.w3c_click_offset = false
        end

        it 'should offset from top left of element' do
          clicker.right_click(x: 10, y: 5)
          html_page.should.have_text(/clicked at 110,105/)
        end

        it 'should offset outside the element' do
          clicker.right_click(x: -15, y: -10)
          html_page.should.have_text(/clicked at 85,90/)
        end

        it 'should default to click the middle' do
          clicker.right_click
          html_page.should.have_text(/clicked at 150,150/)
        end
      end

      context 'when w3c_click_offset is true' do
        before do
          Capybara.w3c_click_offset = true
        end

        it 'should offset from center of element' do
          clicker.right_click(x: 10, y: 5)
          html_page.should.have_text(/clicked at 160,155/)
        end

        it 'should offset outside from center of element' do
          clicker.right_click(x: -65, y: -60)
          html_page.should.have_text(/clicked at 85,90/)
        end

        it 'should default to click the middle' do
          clicker.right_click
          html_page.should.have_text(/clicked at 150,150/)
        end
      end
    end

    context 'delay', driver: :chrome_headless do
      it 'should delay the mouse up' do
        js_page.visit_page
        html_page.find('#click-test').right_click(delay: 2)
        delay = html_page.evaluate_script('window.right_click_delay')
        expect(delay).to be >= 2
      end
    end
  end

  describe '#send_keys', driver: :chrome_headless do
    it 'should send a string of keys to an element' do
      form_page.visit_page
      html_page.find('#address1_city')
        .type_in('Oceanside')
        .should.have_value('Oceanside')
    end

    it 'should send special characters' do
      form_page.visit_page
      html_page.find('#address1_city')
        .type_in('Ocean', :space, 'sie', :left, 'd')
        .should.have_value('Ocean side')
    end

    it 'should allow for multiple simultaneous keys' do
      form_page.visit_page
      html_page.find('#address1_city')
        .type_in([:shift, 'o'], 'ceanside')
        .should.have_value('Oceanside')
    end

    it 'should hold modifiers at top level' do
      form_page.visit_page
      html_page.find('#address1_city')
        .type_in('ocean', :shift, 'side')
        .should.have_value('oceanSIDE')
    end

    it 'should generate key events', driver: :chrome_headless do
      js_page.visit_page
      html_page.find('#with-key-events').type_in([:shift, 't'], [:shift, 'w'])
      html_page.find('#key-events-output').should.have_text('keydown:16 keydown:84 keydown:16 keydown:87')
    end
  end

  describe '#execute_script', driver: :chrome_headless do
    it 'should execute the given script in the context of the element and return itself' do
      js_page.visit_page
      js_page.change
        .execute_script("this.textContent = 'Funky Doodle'")
        .should.have_content('Funky Doodle')
    end

    it 'should pass arguments to the script' do
      js_page.visit_page
      js_page.change.execute_script('this.textContent = arguments[0]', 'Doodle Funk')
      js_page.should.have(:change, text: 'Doodle Funk')
    end
  end

  describe '#evaluate_script', driver: :chrome_headless do
    it 'should evaluate the given script in the context of the element and  return whatever it produces' do
      js_page.visit_page
      el = html_page.find('#with_change_event')
      expect(el.evaluate_script('this.value')).to eq('default value')
    end

    it 'should ignore leading whitespace' do
      js_page.visit_page
      expect(js_page.change.evaluate_script('
        2 + 3
      ')).to eq 5
    end

    it 'should pass arguments to the script' do
      js_page.visit_page
      js_page.change.evaluate_script('this.textContent = arguments[0]', 'Doodle Funk')
      js_page.should.have(:change, text: 'Doodle Funk')
    end

    it 'should pass multiple arguments' do
      js_page.visit_page
      expect(js_page.evaluate_script('arguments[0] + arguments[1]', 2, 3)).to eq 5
    end

    it 'should support returning elements' do
      js_page.visit_page
      el = js_page.change.evaluate_script('this')
      expect(el).to be_instance_of(Capybara::Node::Element)
      expect(el).to eq(js_page.change)

      el = js_page.change.evaluate_script('arguments[0]', js_page.change)
      expect(el).to be_instance_of(Capybara::Node::Element)
      expect(el).to eq(js_page.change)
    end
  end

  describe '#evaluate_async_script', driver: :chrome_headless do
    it 'should evaluate the given script in the context of the element' do
      js_page.visit_page
      el = html_page.find('#with_change_event')
      expect(el.evaluate_async_script('arguments[0](this.value)')).to eq('default value')
    end

    it 'should support returning elements after asynchronous operation' do
      js_page.visit_page
      change = js_page.change # ensure page has loaded and element is available
      el = change.evaluate_async_script('var cb = arguments[0]; setTimeout(function(el){ cb(el) }, 100, this)')
      expect(el).to eq(change)
    end
  end

  describe '#reload', driver: :chrome_headless do
    it 'should reload elements found via ancestor with CSS' do
      js_page.visit_page
      node = html_page.find('#reload-me em').ancestor('div')
      node.reload.should.have_id('reload-me')
    end

    it 'should reload elements found via ancestor with XPath' do
      js_page.visit_page
      node = html_page.find('#reload-me em').ancestor(:xpath, './/div')
      node.reload.should.have_id('reload-me')
    end

    it 'should reload elements found via sibling' do
      js_page.visit_page
      first_item = js_page.find('#the-list li', text: 'Item 1')

      first_item.sibling('li')
        .should.have_text('Item 2')
        .reload
        .should.have_text('Item 2')

      first_item.sibling(:list_item, below: first_item)
        .should.have_text('Item 2')

      expect { first_item.sibling(:list_item, above: first_item) }
        .to raise_error(Capybara::ElementNotFound, /"li" above/)
    end

    context 'without automatic reload' do
      before { Capybara.automatic_reload = false }

      after { Capybara.automatic_reload = true }

      it 'should reload the current context of the node' do
        js_page.visit_page
        node = html_page.find('#reload-me')
        html_page.click_link('Reload!')
        sleep(0.3)
        node.reload
          .should.have_text('has been reloaded')
          .should.have_text('has been reloaded')
      end

      it 'should reload a parent node' do
        js_page.visit_page
        node = html_page.find('#reload-me').find('em')
        html_page.click_link('Reload!')
        sleep(0.3)
        node.reload
          .should.have_text('has been reloaded')
          .should.have_text('has been reloaded')
      end

      it 'should not automatically reload' do
        js_page.visit_page
        node = html_page.find('#reload-me')
        html_page.click_link('Reload!')
        sleep(0.3)
        expect { node.should.have_text('has been reloaded') }
          .to(raise_error { |error| expect(error).to be_an_invalid_element_error })
      end
    end

    context 'with automatic reload' do
      before do
        Capybara.default_max_wait_time = 4
      end

      it 'should reload the current context of the node automatically' do
        js_page.visit_page
        node = html_page.find('#reload-me')
        html_page.click_link('Reload!')
        sleep(1)
        node.should.have_text('has been reloaded')
      end

      it 'should reload a parent node automatically' do
        js_page.visit_page
        node = html_page.find('#reload-me').find('em')
        html_page.click_link('Reload!')
        sleep(1)
        node.should.have_text('has been reloaded')
      end

      it 'should reload a node automatically when using find' do
        js_page.visit_page
        node = html_page.find('#reload-me')
        html_page.click_link('Reload!')
        sleep(1)
        node.find('a').should.have_text('has been reloaded')
      end

      it "should not reload nodes which haven't been found with reevaluateable queries" do
        js_page.visit_page
        node = html_page.all('#the-list li')[1]
        html_page.click_link('Fetch new list!')
        sleep(1)

        expect {
          node.should.have_text('Foo')
        }.to(raise_error { |error| expect(error).to be_an_invalid_element_error })
        expect {
          node.should.have_text('Bar')
        }.to(raise_error { |error| expect(error).to be_an_invalid_element_error })
      end

      it 'should reload nodes with options' do
        js_page.visit_page
        node = html_page.find('em', text: 'reloaded')
        html_page.click_link('Reload!')
        sleep(1)
        node.should.have_text('has been reloaded')
      end
    end
  end

  context 'when #synchronize raises server errors' do
    it 'sets an explanatory exception as the cause of server exceptions', driver: :chrome_headless do
      quietly { visit('/error') }
      expect { html_page.find('span') }
        .to(raise_error(TestApp::TestAppError) do |e|
          expect(e.cause).to be_a Capybara::CapybaraError
          expect(e.cause.message).to match(/Your application server raised an error/)
        end)
    end

    it 'sets an explanatory exception as the cause of server exceptions with errors with initializers', driver: :chrome_headless do
      quietly { visit('/other_error') }
      expect { html_page.find('span') }
        .to(raise_error(TestApp::TestAppOtherError) do |e|
          expect(e.cause).to be_a Capybara::CapybaraError
          expect(e.cause.message).to match(/Your application server raised an error/)
        end)
    end
  end
end
