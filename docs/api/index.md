---
sidebar: auto
---

[el convention]: /guide/essentials/current-context.html#current-element
[current context]: /guide/essentials/current-context.html
[actions]: /guide/essentials/actions
[aliases]: /guide/essentials/aliases
[capybara selectors]: https://www.rubydoc.info/github/teamcapybara/capybara/Capybara/Selector
[aliases shortcuts]: /guide/essentials/aliases#aliases-shortcuts
[assertions]: /guide/essentials/assertions
[asserts]: /guide/essentials/assertions
[expectations]: /guide/essentials/assertions.html#using-the-assertion-state
[assertion state]: /guide/essentials/assertions.html#understanding-the-assertion-state
[matchers]: /guide/essentials/querying
[api_matchers]: /api/#matchers
[predicate]: /guide/essentials/querying
[api_assertions]: /api/#assertions
[api_finders]: /api/#finders
[api_aliases]: /api/#aliases
[api_actions]: /api/#actions
[matcher caveats]: /guide/essentials/querying.html#query-caveats-⚠%EF%B8%8F
[finders]: /guide/essentials/finders
[scoping]: /guide/essentials/finders.html#scoping-🎯
[filtering]: /guide/advanced/filtering
[synchronization]: /guide/advanced/synchronization
[composition]: /guide/advanced/composition
[wrapping]: /guide/advanced/composition.html#wrapping-%F0%9F%8E%81
[wrap]: /api/#wrap-element
[all]: /api/#all
[ancestor]: /api/#ancestor
[find]: /api/#find
[sibling]: /api/#sibling
[launchy]: https://github.com/copiousfreetime/launchy
[capybara api]: https://rubydoc.info/github/teamcapybara/capybara/master/Capybara/Session
[current element]: /api/#to-capybara-node
[capybara_node_code]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/lib/capybara_test_helpers/test_helper.rb#L56-L58
[click]: /api/#click
[async]: https://github.com/teamcapybara/capybara#asynchronous-javascript-ajax-and-friends
[using_wait_time]: /api/#using-wait-time
[select]: /api/#select
[unselect]: /api/#unselect
[should]: /api/#should
[should_not]: /api/#should-not
[within_frame]: /api/#within-frame
[within_window]: /api/#within-window
[find_field]: /api/#find-field
[find_link]: /api/#find-link
[find_button]: /api/#find-button
[test_context]: /api/#test-context
[delegate_to_test_context]: /api/#delegate-to-test-context
[synchronize_expectation]: /api/#synchronize-expectation
[capybara_synchronize]: https://rubydoc.info/github/jnicklas/capybara/master/Capybara/Node/Base#synchronize-instance_method
[keys]: https://www.rubydoc.info/github/teamcapybara/capybara/Capybara%2FNode%2FElement:send_keys
[positive and negative]: https://maximomussini.com/posts/cucumber-to_or_not_to/
[selectors]: /api/selectors
[have]: /api/#have
[have_ancestor]: /api/#have-ancestor
[have_button]: /api/#have-button
[have_checked_field]: /api/#have-checked-field
[have_css]: /api/#have-css
[have_current_path]: /api/#have-current-path
[have_field]: /api/#have-field
[have_link]: /api/#have-link
[have_select]: /api/#have-select
[have_selector]: /api/#have-selector
[have_sibling]: /api/#have-sibling
[have_table]: /api/#have-table
[have_text]: /api/#have-text
[have_unchecked_field]: /api/#have-unchecked-field
[have_value]: /api/#have-value
[have_xpath]: /api/#have-xpath
[match_css]: /api/#match-css
[match_selector]: /api/#match-selector
[match_style]: /api/#match-style
[match_xpath]: /api/#match-xpath
[have_all_of_selectors]: /api/#have-all-of-selectors
[have_any_of_selectors]: /api/#have-any-of-selectors
[have_none_of_selectors]: /api/#have-none-of-selectors
[matching strategy]: https://github.com/teamcapybara/capybara#strategy
[filters]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/spec/support/global_filters.rb#L10-L19
[test_id]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/spec/support/global_filters.rb#L6-L8

# API Reference

All of the following methods can be called on a `Capybara::TestHelper` instance.

Many of these methods are coming from the [Capybara API] and can be used exactly the same, except they have been extended to support [locator aliases][aliases].

Most methods that find or interact with an element can receive a `:wait` option, which determines how long the command will be [retried][async] before failing. For the ones that don't, it can still be configured with [`using_wait_time`][using_wait_time].


## Test Helper Class

The following methods are available at the class scope in `Capybara::TestHelper` subclasses.

### **aliases**

Defines [locator aliases][aliases] that can be used by [actions][api_actions], [finders][api_finders], [matchers][api_matchers], and [assertions][api_assertions].

A method with the alias name will be defined for each specified alias, as a [shortcut][aliases shortcuts] for `find`.

Read the [aliases] guide for a quick overview.

- **Arguments**:
  - `locator_aliases {Hash}`:
    - `key {Symbol}`: name of the alias
    - `value {String | Array}`: the locator

- **Example**:

  ```ruby
  class FormTestHelper < Capybara::TestHelper
    aliases(
      el: 'form',
      save_button: '.button[type=submit]',
      save_loading_indicator: [:save_button, ' .loading-indicator'],
    )

    def save
      within { save_button.click }
    end

    def be_saving
      have(:save_loading_indicator)
    end
  end
  ```

### **delegate_to_test_context**

Makes the specified methods from the RSpec or Cucumber context available in the test helper instance.

This is useful when defining custom logic in support files.

For one-off usages, you may call [`test_context`][test_context] manually in the instance.

- **Arguments**:
  - `*method_names {Symbol}`: the methods to delegate to the test context

- **Example**:

  ```ruby
  class BaseTestHelper < Capybara::TestHelper
    delegate_to_test_context(:support_file_path)

    def drop_file(filename)
      drop support_file_path(filename)
    end
  end
  ```

### **use_test_helpers**

Makes other test helpers available in the instance as methods.

The defined methods can optionally receive an element to [wrap].

Read the [composition] guide for a quick overview.

- **Arguments**:
  - `*helper_names {Symbol}`: the names of the test helpers to inject

- **Example**:

  ```ruby
  class CitiesTestHelper < Capybara::TestHelper
    use_test_helpers(:form, :table)

    aliases(
      cities_table: '.cities',
    )

    def edit(name, with:)
      table(cities_table).row_for(name).click_link('Edit')
      form.within {
        fill_in('Name', with: with[:name])
        form.save
      }
    end
  end
  ```


## Test Helper Instance

The following instance methods are available in `Capybara::TestHelper` instances.

### **not_to**

The current [assertion state] of the test helper.

Intended to be used along with `to_or` to create [positive and negative] assertions at once.

Also available as `or_should_not`, for syntax sugar: `should(or_should_not)`, but usually not needed because [injected][composition] test helpers preserve the assertion state.

- **Example**:

  ```ruby
  def be_checked
    expect(checked?).to_or not_to, eq(true)
  end
  ```

  ::: tip
  Make sure to [manually synchronize][synchronization] when writing custom expectations.
  :::

### **should**

Returns a test helper with a positive [assertion state], allowing any [assertions][api_assertions] to be chained after it.

Also available as `should_still`, `should_now`, `and`, `and_instead`, `and_also`, `and_still`.

- **Arguments**:
  - `negated {Boolean}`: defaults to `false`, if truthy it will return a test helper with a negative assertion state.

- **Examples**:
  ```ruby
  users.should.have_content('Jim')
  ```
  ```ruby
  Then(/^there should( not)? be an? "(.+?)" city$/) do |or_should_not, name|
    cities.should(or_should_not).have_city(name)
  end
  ```

### **should_not**

Returns a test helper with a negative [assertion state], allowing any [assertions][api_assertions] to be chained after it.

Also available as `should_still_not`, `should_no_longer`, `nor`, `and_not`.

- **Examples**:
  ```ruby
  users.should_not.have_content('Jim')
  ```

### **test_context**

The test context in which the test helper was instantiated.

Set implicitly to the RSpec example or Cucumber world when using [injected][composition] test helpers.

[`delegate_to_test_context`][delegate_to_test_context] allows you to expose methods in the test helper as needed.

- **Examples**:
  ```ruby
  # Internal: Quick way to grab the current user being used on the test.
  def user
    test_context.instance_variable_get('@user') || test_context.current_user
  end
  ```

### **to_capybara_node**

- **Usage**:

  Casts the [current context] as a `Capybara::Node::Element`.

  - If the test helper is wrapping an element, it will return it.
  - If the test helper is wrapping the page, it will find an element using the [`:el` alias][el convention].

  [Source][capybara_node_code]

- **Example**:

  ```ruby
  def focus
    to_capybara_node.execute_script('this.focus()')
    self
  end
  ```

### **wrap_element**

[Wraps][wrapping] the given element with a new test helper instance.

When passing a test helper, it will wrap its [current element].

- **Arguments**:

  `element {Capybara::Node::Element | Capybara::TestHelper}`: the element to wrap

- **Returns**:

  A new `Capybara::TestHelper` of the same class the method was invoked in.

- **Example**:

  ```ruby
  def find_user(name)
    wrap_element table.row_for(name)
  end
  ```


## Actions

Check the [guide][Actions] for a quick tour.

Some of the following methods will be performed on the [current element], while other methods will use the [current context] (which by default is the current `page`).

### **attach_file**

Finds a file field in the [current context], and attaches a file to it.

- **Arguments**:
  - `locator (optional)`: uses the [`:file_field` selector](/api/selectors#file-field)
  - `paths {String | Array<String>}`: the path(s) of the file(s) to attach

- **Returns**: the file field

- **Example**:
  ```ruby
    form.csv_file_input.attach_file('/path/to/example.csv')
    # same as
    form.attach_file('CSV File', '/path/to/example.csv')
  ```
  ```ruby
    # attach file to any file input triggered by the block
    form.attach_file('/path/to/file.png') { form.click_link('Upload Image') }
  ```

### **blur**

Removes focus from the [current element] using JS.

- **Returns**: `self`

- **Example**:
  ```ruby
  form.search_input.blur
  ```

### **check**

Finds a check box in the [current context], and marks it as checked.

- **Arguments**: `locator (optional)`: uses the [`:checkbox` selector](/api/selectors#checkbox)

- **Returns**: the element checked or the label clicked

- **Example**:
  ```ruby
  form.terms_and_conditions.check
  form.language.check('German')
  ```

### **choose**

Finds a radio button in the [current context], and checks it.

- **Arguments**: `locator (optional)`: uses the [`:radio_button` selector](/api/selectors#radio-button)

- **Returns**: the element chosen or the label clicked

- **Example**:
  ```ruby
  form.preferred_menu.check('Vegetarian')
  form.check('menu', option: 'Vegetarian')
  ```

### **click**

Clicks the [current element].

- **Arguments**:

  - `*modifier_keys {Symbol}`: modifier keys that should be held during click

  __Options__:

    By default it will attempt to click the center of the element.
    - `:x {Numeric}`: the X coordinate to offset the click location
    - `:y {Numeric}`: the Y coordinate to offset the click location

- **Returns**: `self`

- **Examples**:
  ```ruby
  def toggle_menu
    find('#menu').click
  end
  ```
  ```ruby
  def open_in_new_tab
    click(:control, x: 5, y: 5)
  end
  ```

### **click_button**

Finds a button in the [current context] and clicks it.

- **Arguments**: same as [`find_button`][find_button]

- **Returns**: the clicked button

- **Example**:
  ```ruby
  form.click_button('Save')
  ```

### **click_link**

Finds a link in the [current context] and clicks it.

- **Arguments**: same as [`find_link`][find_link]

- **Returns**: the clicked link

- **Example**:
  ```ruby
  current_page.click_link('Back to Home')
  ```

### **click_on**

Finds a link or button in the [current context] and clicks it.

- **Arguments**: same as [`find_button`][find_button] and [`find_link`][find_link]

- **Returns**: the clicked link or button

- **Example**:
  ```ruby
  purchase_page.click_on('Checkout')
  ```

### **double_click**

Double clicks the [current element].

- **Arguments**: Same as [`click`][click].

- **Returns**: `self`

### **drag_to**

Drags the [current element] to the given other element.

- **Arguments**:

  - `node {Capybara::Node::Element | Capybara::TestHelper}`: the destination to drag to

  __Options__:

    Driver-specific, might not be supported by all drivers.

    - `:delay {Numeric}`: the amount of seconds between each stage, defaults to `0.05`
    - `:html5 {Boolean}`: force the use of HTML5, otherwise auto-detected by the driver
    - `:drop_modifiers {Array<Symbol>}`: Modifier keys which should be held while dragging

- **Returns**: `self`

- **Example**:
  ```ruby
  todo = pending_list.item_for('Water plants')
  todo.drag_to(done_list)
  ```

### **drop**

Drops items on the [current element].

- **Arguments**:

  - `*path {String | #to_path | Hash}`: location(s) of the file(s) to drop on the element

- **Returns**: `self`

- **Example**:
  ```ruby
  file_input.drop('/some/path/file.csv')
  file_input.drop({ 'text/url' => 'https://www.google.com', 'text/plain' => 'Website' })
  ```

### **evaluate_async_script**

Evaluates the given JavaScript in the [current context] of the element, and obtains the result from a callback function that is passed as the _last argument_ to the script.

- **Arguments**:

  - `script {String}`: a string of JavaScript to evaluate
  - `*args {Object}`: parameters for the JavaScript function

- **Returns**: `Object` result of the callback function

- **Example**:
  ```ruby
  def delayed_value(delay: 0.1)
    # Since we are passing only one argument (delay), the second argument will
    # be the callback that will capture the value.
    evaluate_async_script(<<~JS, delay)
      const delay = arguments[0]
      const callback = arguments[1]
      setTimeout(() => callback(this.value), delay)
    JS
  end
  ```

### **evaluate_script**

Evaluates the given JS in the [current context], and returns the result.

If the test helper has a [current element], then `this` in the script will refer to that HTML node.

- **Arguments**:

  - `script {String}`: a string of JavaScript to evaluate
  - `*args {Object}`: parameters for the JavaScript function

- **Returns**: `Object` result of evaluating the script

- **Example**:
  ```ruby
  def offset_height(padding: 5)
    evaluate_script('this.offsetHeight - arguments[0]', padding)
  end
  ```
  ::: tip
  Use [`execute_script`](#execute_script) instead when the script returns complex objects such as jQuery statements.
  :::

### **execute_script**

Execute the given JS in the [current context] without returning a result.

If the test helper has a [current element], then `this` in the script will refer to that HTML node.

- **Arguments**:

  - `script {String}`: a string of JavaScript to evaluate
  - `*args {Object}`: parameters for the JavaScript function

- **Returns**: `self`

- **Example**:
  ```ruby
  def move_caret_to_the_beginning
    execute_script('this.setSelectionRange(0, 0)')
  end
  ```
  ::: tip
  Should be used over [`evaluate_script`](#evaluate_script) whenever a result is not needed, specially for scripts that return complex objects, such as jQuery statements.
  :::

### **fill_in**

Finds a text field or text area in the [current context], and fills it in with the given text.

- **Arguments**:
  - `locator (optional)`: uses the [`:fillable_field` selector](/api/selectors#fillable-field)

  __Options__:
    - `:with {String}`: the value to fill in
    - `:currently_with {String}`: the current value of the field to fill in

- **Returns**: the element that was filled in

- **Example**:
  ```ruby
  def add_user(name:)
    fill_in('Name', with: name)
    click_on('Submit')
  end
  ```
  ```ruby
  address_form.street_input.fill_in(with: 'Evergreen St.')
  ```

### **focus**

Focuses the [current element] using JS.

- **Returns**: `self`

- **Example**:
  ```ruby
  form.find_field('Name').focus.move_caret_to_the_beginning
  ```

### **hover**

Hovers on the [current element].

- **Returns**: `self`

- **Example**:
  ```ruby
  def have_tooltip(title)
    hover.have('.tooltip', text: title)
  end
  ```

### **right_click**

Right clicks the [current element].

- **Arguments**: Same as [`click`][click].

- **Returns**: `self`

### **scroll_to**

Supports three different ways to perform scrolling.

- Scroll the page or element to its top, bottom or middle.
  - `position {:top | :bottom | :center | :current}`

  ```ruby
  current_page.scroll_to(:top, offset: [0, 20])
  ```

- Scroll the page or element into view until the given element is aligned as specified.
   - `element {Capybara::Node::Element | Capybara::TestHelper}`: the element to be scrolled
   - `:align {:top | :bottom | :center }`: where to align the element being scrolled into view with relation to the current page/element if possible.

  ```ruby
  def scroll_into_view
    scroll_to(self, align: :top)
  end
  ```

- Scroll horizontally or vertically.
  - `x {Integer}`
  - `y {Integer}`

  ```ruby
  current_page.scroll_to(100, 500)
  ```

- **Options**:
  - `[x, y] :offset`

- **Returns**: `self`


### **select**

Finds an option inside the [current context] and selects it.

If the select box is a multiple select, it can be called multiple times to select more than
one option.

- **Arguments**:
  - `value {String}`: the value to select
  - `:from (optional)`: uses the [`:select` or `:datalist_input` selectors](/api/selectors#select)

- **Returns**: the selected option element

- **Example**:
  ```ruby
    form.month_input.select('March')
    # same as
    form.select('March', from: 'Month')
  ```

### **select_option**

Selects the [current element] if it is an option inside a select tag.

Used implicitly when calling [`select`][select], which should be preferred.

- **Returns**: `self`

- **Example**:
  ```ruby
  option.select_option
  ```

### **send_keys**

Sends keystrokes to the [current element].

You may use any of the [supported symbol keys][keys].

- **Arguments**: `*keys {String | Symbol}` the [keys][keys] to type

- **Returns**: `self`

- **Example**:
  ```ruby
  input
    .send_keys('fod', :left, 'o')       # value: 'food'
    .send_keys([:control, 'a'], :space) # value: ' ' (assuming select all)
    .send_keys(:tab)
  ```

### **set**

Sets the value of the [current element] to the specified value.

- **Arguments**: `value {Object}` the new value

  __Options__:
    - `:clear`: The method used to clear the previous value
      - `nil` the default, clears the input using JS
      - `:none` appends the new value to the previous value
      - `:backspace` sends backspace keystrokes to clear the field

- **Returns**: `self`

- **Example**:
  ```ruby
  input.set('fo').set('od', clear: :none).should.have_value('food')
  ```

### **style**

Retrieves the specified CSS styles for the [current element].

- **Arguments**: `*styles {String}` the style properties to retrieve

- **Returns**: ` Hash` with the computed style properties

- **Example**:
  ```ruby
    heading.style(:color, 'font-size')
  ```

  ::: tip
  Use [`match_style`][match_style] instead when making assertions.
  :::

### **uncheck**

Finds a check box in the [current context], and unchecks it.

- **Arguments**:
  - `locator (optional)`: uses the [`:checkbox` selector](/api/selectors#checkbox)

- **Returns**: the element checked or the label clicked

- **Example**:
  ```ruby
  form.uncheck('Email Notifications')
  form.terms_and_conditions.uncheck
  ```

### **unselect**

Finds an option inside the [current context] and unselects it.

If the select box is a multiple select, it can be called multiple times to unselect more than
one option.

- **Arguments**:
  - `value {String}`: the value to select
  - `:from (optional)`: uses the [`:select` or `:datalist_input` selectors](/api/selectors#select)

- **Returns**: the unselected option element

- **Example**:
  ```ruby
    form.locale_select.unselect('English')
    # same as
    form.unselect('English', from: 'form_locale')
  ```

### **unselect_option**

Unselects the [current element] if it is an option inside a multiple select tag.

Used implicitly when calling [`unselect`][unselect], which should be preferred.

- **Returns**: `self`

- **Example**:
  ```ruby
  option.unselect_option
  ```

## Assertions

Check the [guide][Assertions] for a quick tour.

To use an assertion, call [`should`][should] or [`should_not`][should_not], and then chain the assertion.

Negated versions are available, such as `have_no_selector` and `not_match_selector`, but are omitted for brevity as they work exactly the same as using [`should_not`](should_not) with a positive assertion.

::: tip
[Injected][composition] test helpers will preserve the _[assertion state]_ of the current helper.
:::

### **have**

[Asserts] that the [current context] contains an element with the given selector.

You may specify a [locator alias][aliases] or use any [capybara selector][selectors].

- **Arguments**: same as [`find_all`][all]

- **Returns**: `self`

- **Examples**:
  ```ruby
  current_page
    .should.have(:title, text: 'Using Test Helpers')
    .should.have(:subtitle, count: 3)
    .should.have('h3', text: 'Global Test Helpers', visible: true)
  ```
  ```ruby
  table.should.have(:table_row, { 'Name' => 'Allen' })
  ```

### **have_ancestor**

[Asserts] that the [current element] has an ancestor with the given selector.

- **Arguments**: same as [`ancestor`][ancestor]

- **Returns**: `self`

- **Example**:
  ```ruby
  list_item
    .should.have_ancestor('ul', text: 'Pending')
    .should_not.have_ancestor('ul', text: 'Done')
  ```

### **have_button**

[Asserts] that the [current context] contains a button with the given selector.

- **Arguments**: same as [`find_all`][all], see the [`:button` selector](/api/selectors#button) for usage

- **Returns**: `self`

- **Example**:
  ```ruby
  form.should.have_button(type: 'submit', disabled: true)
  ```

### **have_checked_field**

[Asserts] that the [current context] contains a radio button or checkbox with the given selector, that is currently checked.

- **Arguments**: same as [`find_all`][all], see the [`:field` selector](/api/selectors#field) for usage

- **Returns**: `self`

- **Example**:
  ```ruby
  form.should.have_checked_field('Terms and Conditions')
  ```

### **have_content**

Alias for [`have_text`][have_text].


### **have_css**

[Asserts] that the [current context] contains an element with the given CSS selector.

- **Arguments**: same as [`find_all`][all], see the [`:css` selector](/api/selectors#css) for usage

- **Returns**: `self`


### **have_field**

[Asserts] that the [current context] contains a form field with the given selector.

- **Arguments**: same as [`find_all`][all], see the [`:field` selector](/api/selectors#field) for usage

- **Returns**: `self`

- **Example**:
  ```ruby
  form.should.have_field('First Name').should_not.have_field('Last Name')
  ```

### **have_link**

[Asserts] that the [current context] contains a link with the given selector.

- **Arguments**: same as [`find_all`][all], see the [`:link` selector](/api/selectors#link) for usage

- **Returns**: `self`

- **Example**:
  ```ruby
  current_page.should.have_link('Go to Checkout', href: '#checkout')
  ```

### **have_select**

[Asserts] for select elements.

- **Arguments**: same as [`find_all`][all], see the [`:select` selector](/api/selectors#select) for usage

- **Returns**: `self`

- **Example**:
  ```ruby
  form.should_not.have_select('Language', selected: 'German')
  form.should.have_select('Language', selected: ['English', 'German'])
  form.should.have_select('Language', options: ['English', 'German', 'Spanish'])
  form.should.have_select('Language', with_options: ['English', 'German'])
  ```

### **have_selector**

Alias for [`have`][have].


### **have_sibling**

[Asserts] whether sibling element(s) matching a given selector exist.

- **Arguments**: `(*args, **kw_args, &optional_filter_block)`

- **Returns**: `self`

- **Example**:
  ```ruby
  # TODO: Example
  ```


### **have_table**

[Asserts] for table elements.

- **Arguments**: `(locator = nil, **options, &optional_filter_block)`

- **Returns**: `self`

- **Example**:
  ```ruby
  # TODO: Example
  ```


### **have_text**

[Asserts] for text content.

- **Arguments**: `(text_or_type, *args, **options)`

- **Returns**: `Object (also: #have_content)`

- **Example**:
  ```ruby
  # TODO: Example
  ```


### **have_unchecked_field**

[Asserts] for unchecked fields.

- **Arguments**: `(locator = nil, **options, &optional_filter_block)`

- **Returns**: `self`

- **Example**:
  ```ruby
  # TODO: Example
  ```

### **have_value**

[Asserts] whether the value of the [current element] matches the provided value.

- **Arguments**: `(*args, **kw_args, &optional_filter_block)`

- **Returns**: `self`

- **Example**:
  ```ruby
  # TODO: Example
  ```

### **have_xpath**

[Asserts] whether elements(s) matching a given xpath selector exist.

- **Arguments**: `(xpath, **options, &optional_filter_block)`

- **Returns**: `self`

- **Example**:
  ```ruby
  # TODO: Example
  ```


### **match_css**

[Asserts] whether the current element matches a given css selector.

- **Arguments**: `(css, **options, &optional_filter_block)`

- **Returns**: `self`

- **Example**:
  ```ruby
  # TODO: Example
  ```


### **match_selector**

[Asserts] whether the current element matches a given selector.

- **Arguments**: `(*args, **kw_args, &optional_filter_block)`

- **Returns**: `self`

- **Example**:
  ```ruby
  # TODO: Example
  ```


### **match_style**

[Asserts] for element style.

- **Arguments**: `(styles = nil, **options)`

- **Returns**: `self`

- **Example**:
  ```ruby
  # TODO: Example
  ```


### **match_xpath**

[Asserts] whether the current element matches a given xpath selector.

- **Arguments**: `(xpath, **options, &optional_filter_block)`

- **Returns**: `self`

- **Example**:
  ```ruby
  # TODO: Example
  ```

### **have_all_of_selectors**

[Asserts] that all of the provided selectors are descendants of the [current context].

If using [aliases], you must explicitly provide a [selector][selectors] as the first argument.

It will wait until all of the elements are found, until [timeout][synchronization].

- **Returns**: `self`

- **Example**:
  ```ruby
  form.should.have_all_of_selectors(:css, :name_input, :last_name_input)
  ```

### **have_any_of_selectors**

[Asserts] that at least of the provided selectors are descendants of the [current context].

If using [aliases], you must explicitly provide a [selector][selectors] as the first argument.

It will wait until one of the elements is found, until [timeout][synchronization].

- **Returns**: `self`

- **Example**:
  ```ruby
  form.should.have_any_of_selectors(:css, :name_input, :last_name_input, wait: 2)
  ```

### **have_none_of_selectors**

[Asserts] that none of the provided selectors are descendants of the [current context].

If using [aliases], you must explicitly provide a [selector][selectors] as the first argument.

It will wait until none of the elements are found, until [timeout][synchronization].

- **Returns**: `self`

- **Example**:
  ```ruby
  form.should.have_none_of_selectors(:css, '.error', '.warning')
  ```


## Debugging

Check out the [guide](/guide/advanced/debugging) for additional information.

The following methods are useful when debugging test failures.

### **flash**

Toggles the [current element] background color between white and black for a period of time.

### **inspect_node**

Inspects the `Capybara::Node::Element` element the test helper is wrapping.

### **save_and_open_page**

Saves a snapshot of the page and open it in a browser for inspection. Requires [`launchy`][launchy].


- **Arguments**: `path {String} (optional)`: the path to where it should be saved

### **save_and_open_screenshot**

Save a screenshot of the page and open it for inspection. Requires [`launchy`][launchy].

- **Arguments**: `path {String} (optional)`: the path to where it should be saved

- **Returns**: `path {String}`: the path to which the file was saved

- **Example**:
  ```ruby
  def have_city(name)
    # Take a screenshot before the assertion runs.
    save_and_open_screenshot('have_city.png')
    have_content(name)
  end
  ```

### **save_page**

Saves a snapshot of the page.

- **Arguments**: `path {String} (optional)`: the path to where it should be saved

- **Returns**: `path {String}`: the path to which the file was saved

### **save_screenshot**

Saves a screenshot of the page.

- **Arguments**: `path {String} (optional)`: the path to where it should be saved

- **Returns**: `path {String}`: the path to which the file was saved


## Element

The following methods are always performed on the [current element].

### **[]**

Retrieves the given HTML attribute of the [current element].

- **Arguments**:
  - `attribute {String | Symbol}` the name of the HTML attribute

- **Returns**: `String` value of the attribute

- **Examples**:
  ```ruby
  input[:value]
  ```
  ```ruby
  # Public: Returns the HTML id of the element.
  def id
    self[:id]
  end
  ```

### **checked?**

Whether or not the [current element] is checked.

- **Returns**: `Boolean`

- **Example**:
  ```ruby
  checkbox.checked?
  ```

  ::: tip
  You can pass [`:checked`](/api/selectors) to [assertions][api_assertions] or [finders][api_finders].
  :::


### **disabled?**

Whether or not the [current element] is disabled.

- **Returns**: `Boolean`

- **Example**:
  ```ruby
  form.name_input.disabled?
  ```

  ::: tip
  You can pass [`:disabled`](/api/selectors) to [assertions][api_assertions] or [finders][api_finders].
  :::

### **multiple?**

Whether or not the [current element] supports multiple results.

- **Returns**: `Boolean`

- **Example**:
  ```ruby
  def can_select_many?
    select_input.multiple?
  end
  ```

  ::: tip
  You can pass [`:multiple`](/api/selectors) to [assertions][api_assertions] or [finders][api_finders].
  :::

### **native**

The native element from the driver, this allows access to driver-specific methods.

- **Returns**: `Object`

### **obscured?**

Whether the [current element] is not currently in the viewport or it (or descendants) would not be considered clickable at the elements center point.

- **Returns**: `Boolean`

  ::: tip
  You can pass [`:obscured`][find] to [assertions][api_assertions] or [finders][api_finders].
  :::

### **path**

An XPath expression describing where on the page the element can be found.

- **Returns**:  `String`

### **readonly?**

Whether the [current element] is read-only.

- **Returns**: `Boolean`

- **Example**:
  ```ruby
  def optional_type_in(text)
    input.set(text) unless input.readonly?
  end
  ```

  ::: tip
  You can pass [`:readonly`](/api/selectors) to [assertions][api_assertions] or [finders][api_finders].
  :::

### **rect**

Returns size and position information for the [current element].

- **Returns**: `Struct { x, y, height, width }`


### **selected?**

Whether or not the [current element] is selected.

- **Returns**: `Boolean`

- **Example**:
  ```ruby
  option.selected?
  ```

  ::: tip
  You can pass [`:selected`](/api/selectors) to [assertions][api_assertions] or [finders][api_finders].
  :::

### **tag_name**

The tag name of the [current element].

- **Returns**: `String`

- **Example**:
  ```ruby
  users.click_link('Add User').tag_name == 'a'
  ```

### **text**

Retrieves the text of the [current element].

- **Arguments**: `type { :all | :visible }`: defaults to `:visible` text

- **Returns**: `String`

- **Example**:
  ```ruby
  find_link('Home').text == 'Home'
  find_link('Hidden', visible: false).text(:all) == 'Hidden'
  ```

  ::: tip
  Use [`have_text`][have_text] instead when making assertions, or pass [`:text` or `:exact_text`][find] to [finders][api_finders] to restrict the results.
  :::

### **value**

Retrieves the value of the [current element].

- **Returns**: `{ String | Array<String> }`

- **Example**:
  ```ruby
  city_input.value == 'Montevideo'
  languages_input.value == ['English', 'Spanish']
  ```
  ::: tip
  Use [`have_value`][have_value] instead when making assertions, or pass [`:with`](/api/selectors#field) to [`find_field`][find_field].
  :::

### **visible?**

Whether or not the [current element] is visible.

- **Returns**: `Boolean`

- **Example**:
  ```ruby
  find_link('Sign in with SSO', visible: :all).visible?
  ```

  ::: tip
  Prefer to pass [`:visible`][find] to [assertions][api_assertions] or [finders][api_finders], or [create an assertion][synchronize_expectation].
  :::


## Finders

Check the [guide][Finders] for a quick tour.

You can locate elements with different strategies by specifying a [selector][selectors].

Additionally, you can use [locator aliases][aliases], and may provide [an optional block to filter results][filtering].

::: tip
All finders will [automatically retry][synchronization] until the element is found, or the timeout ellapses.
:::

### **all**

Finds all elements in the [current context] that match the given selector and options.

Also available as `find_all`.

- **Arguments**: same as [`find`][find], plus:

    - `:count {Integer}`: of matching elements that should exist
    - `:minimum {Integer}`: of matching elements that should exist
    - `:maximum {Integer}`: of matching elements that should exist
    - `:between {Range}`: range of matching elements that should exist

- **Raises**: `Capybara::ExpectationNotMet` if the number of elements doesn't match the conditions
- **Returns**: a collection of found elements, which **may be empty**

  ::: tip
  If no elements are found, it will wait until timeout and return an empty collection.

  If you want it to fail, you can pass `minimum: 1`, or to avoid waiting `wait: false`.
  :::

- **Examples**:
  ```ruby
  table.find_all('tr', minimum: 1)
  form.all(:fillable_field, count: 3)
  ```
  ```ruby
  def unselect_all_items
    all(:selected_option, wait: false).each(&:click)
  end
  ```
  ```ruby
  def find_by_index(locator, index:, **options)
    find_all(locator, minimum: index + 1, **options)[index]
  end
  ```

### **ancestor**

Finds an element that matches the given arguments and is an ancestor of the [current context].

- **Arguments**: same as [`find`][find].

- **Returns**: the ancestor element

- **Examples**:
  ```ruby
  list_item.ancestor('ul', text: 'Pending')
  ```
  ```ruby
  def group_with_name(group)
    find(:group_name, text: group).ancestor(:group)
  end
  ```

### **find**
Finds an element in the [current context] based on the given arguments.

- **Arguments**: a [locator alias][aliases], or a [capybara selector][selectors].

  **Options**: any filters in the specified (or default) [selector][selectors], plus:

  - `:text {String | Regexp}`: only elements which contain or match this text
  - `:exact_text {String | Boolean}`: only elements that exactly match this text
  - `:visible {Boolean | Symbol}`:
    - `true` or `:visible`: only find visible elements
    - `false` or `:all`: find invisible _and_ visible elements
    - `:hidden`: only find invisible elements
  - `:obscured {Boolean}`:
    - `true`: only elements whose centerpoint is not in the viewport or is obscured
    - `false`: only elements whose centerpoint is in the viewport and is not obscured
  - `:id {String | Regexp}`: only elements with the specified id
  - `:class {String | Array<String> | Regexp}`: only elements with matching class(es)
    - Absence of a class can be checked by prefixing the class name with `!`
  - `:style {String | Regexp | Hash}`: only elements with matching style
  - `:match {Symbol}`: the [matching strategy] to use

- **Returns**: the found element, [wrapped][wrap] in a test helper

- **Examples**:
  ```ruby
  table.find('tr', match: :first).find('td', text: 'Bond')
  ```
  ```ruby
  form.find(:first_name_input, disabled: true, wait: 5)
  ```
  ```ruby
  container.find(:xpath, '../..')
  ```
  ```ruby
  def find_admin(name)
    find('tr.user', text: name) { |row| row.admin? }
  end
  ```

### **find_all**

Alias for [`all`][all].

### **find_button**
Finds a button in the [current context].

- **Arguments**: same as [`find`][find], see the [`:button` selector](/api/selectors#button) for usage

- **Returns**: the found button

- **Examples**:
  ```ruby
  find_button('Save')
  find_button(type: 'submit')
  ```

### **find_by_id**
Finds a element in the [current context], given its id.

- **Arguments**: same as [`find`][find], see the [`:id` selector](/api/selectors#id) for usage

- **Returns**: the found element

- **Examples**:
  ```ruby
  find_by_id('main', visible: true)
  ```

### **find_field**
Finds a form field in the [current context].

The field can be found by its name, id, or label text.

- **Arguments**: same as [`find`][find], see the [`:field` selector](/api/selectors#field) for usage

- **Returns**: the found field

- **Examples**:
  ```ruby
  find_field(type: 'checkbox', disabled: false)
  find_field('Description', type: 'textarea', with: /Lorem/)
  ```

### **find_link**
Finds a link in the [current context].

- **Arguments**: same as [`find`][find], see the [`:link` selector](/api/selectors#link) for usage

- **Returns**: the found link

- **Examples**:
  ```ruby
  find_link(href: '#introduction')
  find_link('Download Paper', download: true)
  ```

### **first**
Finds the first element in the [current context] matching the given selector and options.

- **Arguments**: same as [`all`][all], uses `minimum: 1` by default

- **Returns**: the found element

  When passing `count`, `minimum`, or `between`, it **may return `nil`** if the conditions allow it.

- **Raises**: `Capybara::ExpectationNotMet` if the number of elements doesn't match the conditions

- **Examples**:
  ```ruby
  first(:link, href: true)
  ```
  ```ruby
  navbar.first(:menu, minimum: 0)
  ```

### **sibling**

Finds an element based on the given arguments that is also a sibling of the [current context].

- **Arguments**: same as [`find`][find].

- **Returns**: the sibling element

- **Examples**:
  ```ruby
  list_item.sibling('li', text: 'Pending')
  ```
  ```ruby
  def next_menu
    sibling(:menu, below: self)
  end
  ```

## Modals

### **accept_alert**

Executes the block, accepting an alert that is opened while it executes.

- **Arguments**:
  -  `text {String | Regexp} (optional)`: text that the modal should contain

### **accept_confirm**

Executes the block, accepting a confirmation dialog that is opened while it executes.

- **Arguments**:
  -  `text {String | Regexp} (optional)`: text that the modal should contain

- **Example**:
  ```ruby
  def delete(city)
    accept_confirm { row_for(city).click_on('Destroy') }
  end
  ```

### **accept_prompt**

Executes the block, accepting a prompt, and optionally responding to it.

- **Arguments**:
  -  `text {String | Regexp} (optional)`: text that the prompt should contain

  __Options__:
      - `:with {String} (optional)`: input for the prompt

### **dismiss_confirm**

Like `accept_confirm`, but dismisses the confirmation dialog instead.

### **dismiss_prompt**

Like `accept_prompt`, but dismisses the prompt instead.


## Navigation

### **go_back**

Moves back a single entry in the browser's history.

### **go_forward**

Moves forward a single entry in the browser's history.

### **refresh**

Refreshes the current page.

### **visit**

Navigates to the given URL, which can either be relative or absolute.

Path helpers can be easily [made available to test helpers](https://github.com/ElMassimo/capybara_test_helpers/blob/819ad283ba32468fbc67a4d45c929f4efac5a464/examples/rails_app/test_helpers/navigation_test_helper.rb#L25-L43).

- **Arguments**:
  - `visit_uri`: The URL to navigate to. The parameter will be cast to a `String`.

- **Example**:

  ```ruby
  def visit_page
    visit cities_path
  end
  ```

## Page

### **have_current_path**

[Asserts] that the page has the given path.

- When passing a full url it will compare against the full url
- When passing a path only the path and query portion will be compared
- When passing a regexp, it will depend on the `:url` option

- **Arguments**: `path {String | Regexp}`: the expected path

  __Options__:
  - `:url {Boolean}`: whether to compare to the current url or just the path
  - `:ignore_query {Boolean}`: whether to ignore the query portion, defaults to `false`
  - `:wait {Numeric}`: how much time to wait for the current url to match
- **Returns**: `self`

- **Example**:
  ```ruby
  current_page.should.have_current_path('/cities', wait: 10)
  current_page.should_not.have_current_path('https://example.com', ignore_query: true)
  ```

### **have_title**
[Asserts][api_assertions] if the page has the given title.

- **Arguments**:
  - `title {String | Regexp}`: string or regex that the title should match

  __Options__:
    - `:exact {Boolean}`: defaults to `false`, whether the provided string should be an exact match or just a substring

- **Example**:
  ```ruby
  current_page.should.have_title('Capybara Test Helpers', exact: false)
  ```

### **has_title?**

[Checks][api_matchers] if the page has the given title.

- **Arguments**:
  - `title {String | Regexp}`: string or regex that the title should match

  __Options__:
    - `:exact {Boolean}`: defaults to `false`, whether the provided string should be an exact match or just a substring

- **Returns**: `Boolean`

- **Example**:
  ```ruby
  current_page.has_title?('Capybara Test Helpers', wait: false)
  ```

### **page.html**
- **Returns**: `String` snapshot of the DOM of the current document

### **page.title**
- **Returns**: `String` title of the document


## Querying

Check the [guide][Matchers] for a quick tour.

Unlike [assertions][api_assertions], matchers return a `Boolean` **instead of failing**.

Negated versions are available for all of them, such as `has_no?` and `not_matches_selector?`, but are omitted for brevity.

::: tip
Have in mind that matchers have some [caveats][matcher caveats], so prefer [assertions] when possible.
:::

### **has?**

[Predicate] version of [`have`][have].

- **Returns**: `Boolean`

### **has_ancestor?**

[Predicate] version of [`have_ancestor`][have_ancestor].

- **Returns**: `Boolean`

### **has_button?**
[Predicate] version of [`have_button`][have_button].

- **Returns**: `Boolean`

### **has_checked_field?**

[Predicate] version of [`have_checked_field`][have_checked_field].

- **Returns**: `Boolean`

### **has_content?**
[Predicate] version of [`have_text`][have_text].

- **Returns**: `Boolean`

### **has_css?**

[Predicate] version of [`have_css`][have_css].

- **Returns**: `Boolean`

### **has_field?**

[Predicate] version of [`have_field`][have_field].

- **Returns**: `Boolean`

### **has_link?**
[Predicate] version of [`have_link`][have_link].

- **Returns**: `Boolean`

### **has_select?**
[Predicate] version of [`have_select`][have_select].

- **Returns**: `Boolean`

### **has_selector?**
[Predicate] version of [`have_selector`][have_selector].

- **Returns**: `Boolean`


### **has_sibling?**
[Predicate] version of [`have_sibling`][have_sibling].

- **Returns**: `Boolean`


### **has_table?**
[Predicate] version of [`have_table`][have_table].

- **Returns**: `Boolean`


### **has_text?**
[Predicate] version of [`have_text`][have_text].

- **Returns**: `Boolean`


### **has_unchecked_field?**
[Predicate] version of [`have_unchecked_field`][have_unchecked_field].

- **Returns**: `Boolean`

### **has_xpath?**
[Predicate] version of [`have_xpath`][have_xpath].

- **Returns**: `Boolean`


### **matches_css?**
[Predicate] version of [`match_css`][match_css].

- **Returns**: `Boolean`


### **matches_selector?**
[Predicate] version of [`match_selector`][match_selector].

- **Returns**: `Boolean`


### **matches_style?**
[Predicate] version of [`match_style`][match_style].

- **Returns**: `Boolean`


### **matches_xpath?**
[Predicate] version of [`match_xpath`][match_xpath].

- **Returns**: `Boolean`


## Scoping

Check the [guide][scoping] for a quick tour.

### **within**

Executes the given block within the context of the specified element.

For the duration of the block, any command to Capybara will be scoped to the given element.

::: tip
When called without parameters the block will be scoped to the [current element].
:::

- **Arguments**: Same as [`find`][find], can also handle [aliases].

- **Returns**: `Object`: The return value of the block.

- **Examples**:
  ```ruby
  dropdown.within { click_link('Open') }
  ```
  ```ruby
  users.find_user('Kim').within { click_link('Edit') }
  ```
  ```ruby
  def add_user(first_name:)
    click_link('Add User')

    within('.new-user-modal') {
      fill_in 'First Name', with: first_name
      click_button 'Save'
    }
  end
  ```

### **within_document**

Unscopes the inner block from any previous `within` calls.

For the duration of the block, any command to Capybara will be scoped to the entire `page`.

::: tip
Use as a escape hatch to interact with content outside a previous `within` call, such as modals.
:::

### **within_fieldset**

Executes the given block within the specific fieldset.

- **Arguments**:
  -  `locator {String}`: id or legend of the fieldset

### **within_frame**

Executes the given block within the given iframe.

- **Arguments**:
  -  `frame {String}`: frame, id, name, or index of the frame

### **within_table**

Executes the given block within the a specific table.

- **Arguments**:
  -  `locator {String}`: id or caption of the table

### **within_window**

Switches to the given window, executes the given block within that window, and then switches back to the original window.

- **Arguments**:
  -  `window {Capybara::Window | Proc }`: window to switch to

  When passing a proc, it will be invoked once per existing window, choosing the first window where the `proc` returns true.

- **Examples**:
  ```ruby
  checkout = window_opened_by { click_button('Checkout') }
  within_window(checkout) { click_on('Confirm Purchase') }
  ```
  ```ruby
  within_window(->{ page.title == 'New User' }) do
    click_button 'Submit'
  end
  ```

## Server

### **server_url**
- **Returns**: `String` url of the current server, including protocol and port

### **status_code**
- **Returns**: `Integer` for the current HTTP status code

### **response_headers**
- **Returns**: `Hash<String, String>` of response headers

## Session

### **current_host**

- **Returns**: `String` host of the current page

### **current_path**

- **Returns**: `String` path of the current page, without any domain information

### **current_url**

- **Returns**: `String` fully qualified URL of the current page.

## Synchronization

Check the [guide][Synchronization] for a quick tour.

### **synchronize**

This method is Capybara's primary way to deal with asynchronicity.

Learn more about it [in the documentation][capybara_synchronize].

You should rarely need to use this directly, check `synchronize_expectation` instead.

- **Options**:
  -  `:errors {Array}`: exception classes that should be retried
  -  `:wait {Numeric}`: amount of seconds to retry the block before it succeeds or times out

- **Example**:
  ```ruby
  def have_created_user(name)
    synchronize(wait: 3, errors: [ActiveRecord::RecordNotFound]) {
      User.find_by(name: name)
    }
  end
  ```

### **synchronize_expectation**

Allows to automatically retry [expectations][expectations] until they succeed or the [time out][synchronization] ellapses.

It will automatically [reload][synchronization] the [current context] on each retry.

- **Options**:
  -  `:retry_on_errors {Array}`: additional exception classes that should be retried
  -  `:wait {Numeric}`: amount of seconds to retry the block before it succeeds or times out

- **Example**:
  ```ruby
  def be_visible
    synchronize_expectation(wait: 2) {
      expect(visible?).to_or not_to, eq(true)
    }
  end
  ```

### **using_wait_time**

Changes the [default maximum wait time][synchronization] for all commands that are executed inside the block.

Useful for changing the timeout for commands that do not take a `:wait` keyword argument.

- **Arguments**:
  -  `seconds {Numeric}`: the default maximum wait time for retried commands

- **Example**:
  ```ruby
  # Hovers even if it takes 10 seconds for the element to become interactable.
  def wait_and_hover
    using_wait_time(10) { hover }
  end
  ```

## Windows

### **become_closed**

Waits for a window to become closed.

- **Example**:

  ```ruby
  expect(window).to become_closed(wait: 5)
  ```

### **current_window**

- **Returns**: `Capybara::Window` the current window

- **Example**:
  ```ruby
  def close_window
    current_window.close
  end
  ```

### **open_new_window**

Opens a new window, __without__ switching to it.

- **Arguments**: `kind {Symbol}` defaults to `:tab`

- **Returns**: `Capybara::Window` a new window or tab

- **Examples**:
  ```ruby
  def visit_in_new_tab(url)
    new_tab = open_new_window(:tab)
    within_window(new_tab) { visit(url) }
  end
  ```

### **switch_to_frame**

Switches to the specified frame permanently. Prefer to use [`within_frame`][within_frame] when possible.

- **Arguments**: Same as [`within_frame`][within_frame]

### **switch_to_window**

Switches to the given window permanently. Prefer to use [`within_window`][within_window] when possible.

- **Arguments**: Same as [`within_window`][within_window]

### **window_opened_by**

Captures a window that is opened while executing the given block.

More reliable than using `windows.last`, as it will wait for the window to be opened.

- **Options**: `:wait {Numeric}`: seconds to wait a new window to be opened

- **Returns**: `Capybara::Window` opened in the block

- **Examples**:
  ```ruby
  checkout_window = window_opened_by { click_button('Checkout') }
  ```

### **windows**

All the windows that are currently open. The order depends on the driver, don't rely on it.

 - **Returns**: `Array<Capybara::Window>`
