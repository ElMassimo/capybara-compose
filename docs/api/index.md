---
sidebar: auto
---

[el convention]: /guide/essentials/current-context.html#current-element
[current context]: /guide/essentials/current-context.html
[actions]: /guide/essentials/actions
[aliases]: /guide/essentials/aliases
[aliases shortcuts]: /guide/essentials/aliases#aliases-shortcuts
[assertions]: /guide/essentials/assertions
[expectations]: /guide/essentials/assertions.html#using-the-assertion-state
[assertion state]: /guide/essentials/assertions.html#understanding-the-assertion-state
[matchers]: /guide/essentials/querying
[api_matchers]: /api/#matchers
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
[find]: /api/#find
[launchy]: https://github.com/copiousfreetime/launchy
[capybara api]: https://rubydoc.info/github/teamcapybara/capybara/master/Capybara/Session
[current element]: /api/#to-capybara-node
[capybara_node_code]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/lib/capybara_test_helpers/test_helper.rb#L56-L58
[click]: /api/#click
[async]: https://github.com/teamcapybara/capybara#asynchronous-javascript-ajax-and-friends
[using_wait_time]: /api/#using-wait-time
[should]: /api/#should
[should_not]: /api/#should-not
[within_frame]: /api/#within-frame
[within_window]: /api/#within-window
[capybara_synchronize]: https://rubydoc.info/github/jnicklas/capybara/master/Capybara/Node/Base#synchronize-instance_method
[keys]: https://www.rubydoc.info/github/teamcapybara/capybara/Capybara%2FNode%2FElement:send_keys

# API Reference

All of the following methods can be called on a `Capybara::TestHelper` instance.

Most of these methods are coming from the [Capybara API], except some of them
have been extended to support [locator aliases][aliases].

Some methods can receive a `:wait` option, which determines how long an interaction will be [retried][async] before failing. For the actions that don't, it can still be configured with [`using_wait_time`][using_wait_time].

## Class DSL

### **aliases**

Defines [locator aliases][aliases] that can be used by [actions][api_actions], [finders][api_finders], [matchers][api_matchers], and [assertions][api_assertions].

A method with the alias name will be defined for each specified alias, as a [shortcut][aliases shortcuts] for `find`.

Read the [aliases] guide for a quick overview.

- **Arguments**:
  - `{Hash} locator_aliases`:
    - `{Symbol} key`: name of the alias
    - `{String | Array}`: the locator

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

- **Arguments**:
  - `{Symbol} *method_names`: the methods to delegate to the test context

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
  - `{Symbol} *helper_names`: the names of the test helpers to inject

- **Example**:

  ```ruby
  class CitiesTestHelper < BaseTestHelper
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


## Test Helper

### **not_to**

The current [assertion state] of the test helper. Also aliased as `or_should_not`.

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

Returns a test helper with a positive [assertion state], allowing any [assertions] to be chained after it.

Also available as `should_still`, `should_now`, `and`, `and_instead`, `and_also`, `and_still`.

- **Arguments**:
  - `{Boolean} negated`: defaults to `false`, if truthy it will return a test helper with a negative assertion state.

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

Returns a test helper with a negative [assertion state], allowing any [assertions] to be chained after it.

Also available as `should_still_not`, `should_no_longer`, `nor`, `and_not`.

- **Examples**:
  ```ruby
  users.should_not.have_content('Jim')
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

  `{Capybara::Node::Element | Capybara::TestHelper} element`: the element to wrap

- **Returns**:

  A new `Capybara::TestHelper` of the same class the method was invoked in.

- **Example**:

  ```ruby
  def find_user(name)
    wrap_element table.row_for(name)
  end
  ```

## Element

Some of the following methods will indicate that they are performed on the [current element], while other methods will use the [current context] (which by default is the current `page`).

### **[]**

Retrieves the given HTML attribute of the [current element].

- **Arguments**:
  - `{String | Symbol} attribute` the name of the HTML attribute

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

### **click**

Clicks the [current element].

- **Arguments**:

  - `{Symbol} *modifier_keys`: modifier keys that should be held during click
  - __Options__:

    By default it will attempt to click the center of the element.
    - `{Numeric} :x`: the X coordinate to offset the click location
    - `{Numeric} :y`: the Y coordinate to offset the click location
    - `{Numeric} :wait`: how long to wait to retry the action until the element becomes interactable

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

### **disabled?**

Whether or not the [current element] is disabled.

- **Returns**: `Boolean`

- **Example**:
  ```ruby
  form.name_input.disabled?
  ```

### **double_click**

Double clicks the [current element].

- **Arguments**: Same as [`click`][click].

- **Returns**: `self`

### **drag_to**

Drags the [current element] to the given other element.

- **Arguments**:

  - `{Capybara::Node::Element | Capybara::TestHelper} node`: the destination to drag to
  - __Options__:

    Driver-specific, might not be supported by all drivers.

    - `{Numeric} :delay`: the amount of seconds between each stage, defaults to `0.05`
    - `{Boolean} :html5`: force the use of HTML5, otherwise auto-detected by the driver
    - `{Array<Symbol>} :drop_modifiers`: Modifier keys which should be held while dragging

- **Returns**: `self`

- **Example**:
  ```ruby
  todo = pending_list.item_for('Water plants')
  todo.drag_to(done_list)
  ```

### **drop**

Drops items on the [current element].

- **Arguments**:

  - `{String | #to_path | Hash} *path`: location(s) of the file(s) to drop on the element

- **Returns**: `self`

- **Example**:
  ```ruby
  file_input.drop('/some/path/file.csv')
  file_input.drop({ 'text/url' => 'https://www.google.com', 'text/plain' => 'Website' })
  ```

### **evaluate_async_script**

Evaluates the given JavaScript in the [current context] of the element, and obtains the result from a callback function that is passed as the _last argument_ to the script.

- **Arguments**:

  - `{String} script`: a string of JavaScript to evaluate
  - `{Object} *args`: parameters for the JavaScript function

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

Use [`execute_script`](#execute_script) instead when the script returns complex objects such as jQuery statements.

- **Arguments**:

  - `{String} script`: a string of JavaScript to evaluate
  - `{Object} *args`: parameters for the JavaScript function

- **Returns**: `Object` result of evaluating the script

- **Example**:
  ```ruby
  def offset_height(padding: 5)
    evaluate_script('this.offsetHeight - arguments[0]', padding)
  end
  ```

### **execute_script**

Execute the given JS in the [current context] without returning a result.

If the test helper has a [current element], then `this` in the script will refer to that HTML node.

Should be used over [`evaluate_script`](#evaluate_script) whenever a result is not needed, specially for scripts that return complex objects, such as jQuery statements.

- **Arguments**:

  - `{String} script`: a string of JavaScript to evaluate
  - `{Object} *args`: parameters for the JavaScript function

- **Returns**: `self`

- **Example**:
  ```ruby
  def blur
    execute_script('this.blur()')
  end
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

### **multiple?**

Whether or not the [current element] supports multiple results.

- **Returns**: `Boolean`

- **Example**:
  ```ruby
  def can_select_many?
    select_input.multiple?
  end
  ```

### **native**

The native element from the driver, this allows access to driver-specific methods.

- **Returns**: `Object`

### **obscured?**

Whether the [current element] is not currently in the viewport or it (or descendants) would not be considered clickable at the elements center point.

- **Returns**: `Boolean`

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

### **rect**

Returns size and position information for the [current element].

- **Returns**: `Struct { x, y, height, width }`

### **right_click**

Right clicks the [current element].

- **Arguments**: Same as [`click`][click].

- **Returns**: `self`

### **scroll_to**

Supports three different ways to perform scrolling.

- Scroll the page or element to its top, bottom or middle.
  - `{:top | :bottom | :center | :current} position`

  ```ruby
  current_page.scroll_to(:top, offset: [0, 20])
  ```

- Scroll the page or element into view until the given element is aligned as specified.
   - `{Capybara::Node::Element | Capybara::TestHelper} element`: the element to be scrolled
   - `{:top | :bottom | :center } :align`: where to align the element being scrolled into view with relation to the current page/element if possible.

  ```ruby
  def scroll_into_view
    scroll_to(self, align: :top)
  end
  ```

- Scroll horizontally or vertically.
  - `{Integer} x`
  - `{Integer} y`

  ```ruby
  current_page.scroll_to(100, 500)
  ```

- **Options**:
  - `[x, y] :offset`

- **Returns**: `self`

### **select_option**

Selects the [current element] if it is an option inside a select tag.

- **Returns**: `self`

### **selected?**

Whether or not the [current element] is selected.

- **Returns**: `Boolean`

- **Example**:
  ```ruby
  option.selected?
  ```

### **send_keys**

Sends keystrokes to the [current element].

You may use any of the [supported symbol keys][keys].

- **Arguments**: `{String | Symbol} *keys` the [keys][keys] to type

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

- **Arguments**: `{Object} value` the new value
  - __Options__:
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

- **Arguments**: `{String} *styles` the style properties to retrieve

- **Returns**: ` Hash` with the computed style properties

- **Example**:
  ```ruby
    heading.style('color', 'font-size')
  ```

### **tag_name**
- **Returns**: `String`
The tag name of the element.

### **text**
Retrieve the text of the element.

- **Arguments**: `(type = nil, normalize_ws: false)`

- **Returns**: `String`

### **trigger**
Trigger any event on the current element, for example mouseover or focus events.

- **Arguments**: `(event)`

- **Returns**: `Capybara::Node::Element`

### **unselect_option**
Unselect this node if it is an option element inside a multiple select tag.

- **Arguments**: `(wait: nil)`

- **Returns**: `Capybara::Node::Element`

### **value**
 ⇒ String
The value of the form element.

### **visible?**
 ⇒ Boolean
Whether or not the element is visible.

## Actions

Check the [guide][Actions] for a quick tour.

### **attach_file**
- **Arguments**: `(locator = nil, paths, make_visible: nil, **options)`

- **Returns**: `Capybara::Node::Element`

Find a descendant file field on the page and attach a file given its path.

### **check**
- **Arguments**: `([locator], **options)`

- **Returns**: `Capybara::Node::Element`

Find a descendant check box and mark it as checked.

### **choose**
- **Arguments**: `([locator], **options)`

- **Returns**: `Capybara::Node::Element`

Find a descendant radio button and mark it as checked.

### **click_button**
- **Arguments**: `([locator], **options)`

- **Returns**: `Capybara::Node::Element`

Finds a button on the page and clicks it.

### **click_link**
- **Arguments**: `([locator], **options)`

- **Returns**: `Capybara::Node::Element`

Finds a link by id, test_id attribute, text or title and clicks it.

### **click_on**
- **Arguments**: `([locator], **options)`

- **Returns**: `Capybara::Node::Element (also: #click_on)`

Finds a button or link and clicks it.

### **fill_in**
- **Arguments**: `([locator], with: , **options)`

- **Returns**: `Capybara::Node::Element`

Locate a text field or text area and fill it in with the given text.

### **select**
- **Arguments**: `(value = nil, from: nil, **options)`

- **Returns**: `Capybara::Node::Element`

If from option is present, #select finds a select box, or text input with associated datalist, on the page and selects a particular option from it.

### **uncheck**
- **Arguments**: `([locator], **options)`

- **Returns**: `Capybara::Node::Element`

Find a descendant check box and uncheck it.

### **unselect**
- **Arguments**: `(value = nil, from: nil, **options)`

- **Returns**: `Capybara::Node::Element`

Find a select box on the page and unselect a particular option from it.


## Assertions

Check the [guide][Assertions] for a quick tour.

To use an assertion, call [`should`][should] or [`should_not`][should_not], and then chain the assertion.

Negated versions are available for most, such as `have_no_selector`, but are ommitted for brevity.


### **have_ancestor**

RSpec matcher for whether ancestor element(s) matching a given selector exist.

- **Arguments**: `(*args, **kw_args, &optional_filter_block)`

- **Returns**: `Object`



### **have_button**

RSpec matcher for buttons.

- **Arguments**: `(locator = nil, **options, &optional_filter_block)`

- **Returns**: `Object`


### **have_checked_field**

RSpec matcher for checked fields.

- **Arguments**: `(locator = nil, **options, &optional_filter_block)`

- **Returns**: `Object`


### **have_css**

RSpec matcher for whether elements(s) matching a given css selector exist.

- **Arguments**: `(css, **options, &optional_filter_block)`

- **Returns**: `Object`


### **have_current_path**

RSpec matcher for the current path.

- **Arguments**: `(path, **options, &optional_filter_block)`

- **Returns**: `Object`


### **have_field**

RSpec matcher for form fields.

- **Arguments**: `(locator = nil, **options, &optional_filter_block)`

- **Returns**: `Object`


### **have_link**

RSpec matcher for links.

- **Arguments**: `(locator = nil, **options, &optional_filter_block)`

- **Returns**: `Object`


### **have_select**

RSpec matcher for select elements.

- **Arguments**: `(locator = nil, **options, &optional_filter_block)`

- **Returns**: `Object`


### **have_selector**

RSpec matcher for whether the element(s) matching a given selector exist.

- **Arguments**: `(*args, **kw_args, &optional_filter_block)`

- **Returns**: `Object`


### **have_sibling**

RSpec matcher for whether sibling element(s) matching a given selector exist.

- **Arguments**: `(*args, **kw_args, &optional_filter_block)`

- **Returns**: `Object`


### **have_table**

RSpec matcher for table elements.

- **Arguments**: `(locator = nil, **options, &optional_filter_block)`

- **Returns**: `Object`


### **have_text**

RSpec matcher for text content.

- **Arguments**: `(text_or_type, *args, **options)`

- **Returns**: `Object (also: #have_content)`


### **have_unchecked_field**

RSpec matcher for unchecked fields.

- **Arguments**: `(locator = nil, **options, &optional_filter_block)`

- **Returns**: `Object`


### **have_xpath**

RSpec matcher for whether elements(s) matching a given xpath selector exist.

- **Arguments**: `(xpath, **options, &optional_filter_block)`

- **Returns**: `Object`


### **match_css**

RSpec matcher for whether the current element matches a given css selector.

- **Arguments**: `(css, **options, &optional_filter_block)`

- **Returns**: `Object`


### **match_selector**

RSpec matcher for whether the current element matches a given selector.

- **Arguments**: `(*args, **kw_args, &optional_filter_block)`

- **Returns**: `Object`


### **match_style**

RSpec matcher for element style.

- **Arguments**: `(styles = nil, **options)`

- **Returns**: `Object`


### **match_xpath**

RSpec matcher for whether the current element matches a given xpath selector.

- **Arguments**: `(xpath, **options, &optional_filter_block)`

- **Returns**: `Object`



### **have_all_of_selectors**

Asserts that all of the provided selectors are descendants of the [current context].

Aliases can be used, but you must provide a selector such as `:css` as the first argument.

It will wait until all of the elements are found, until [timeout][synchronization].

- **Examples**:
  ```ruby
  form.should.have_all_of_selectors(:css, :name_input, :last_name_input)
  ```

### **have_any_of_selectors**

Asserts that at least of the provided selectors are descendants of the [current context].

Aliases can be used, but you must provide a selector such as `:css` as the first argument.

It will wait until one of the elements is found, until [timeout][synchronization].

- **Examples**:
  ```ruby
  form.should.have_any_of_selectors(:css, :name_input, :last_name_input, wait: 2)
  ```

### **have_none_of_selectors**

Asserts that none of the provided selectors are descendants of the [current context].

Aliases can be used, but you must provide a selector such as `:css` as the first argument.

It will wait until none of the elements are found, until [timeout][synchronization].

- **Examples**:
  ```ruby
  form.should.have_none_of_selectors(:css, '.error', '.warning')
  ```

## Finders

Check the [guide][Finders] for a quick tour, or [learn how to filter with blocks][filtering].

### **all**
Finds all elements on the page matching the given selector and options.

- **Arguments**: `([kind = Capybara.default_selector], locator = nil, **options)`

- **Returns**: `Capybara::Result (also: #find_all)`


### **ancestor**
Finds an Element based on the given arguments that is also an ancestor of the element called on.

- **Arguments**: `(*args, **options, &optional_filter_block)`

- **Returns**: `Capybara::Node::Element`


### **find**
Finds an Element based on the given arguments.

- **Arguments**: `(*args, **options, &optional_filter_block)`

- **Returns**: `Capybara::Node::Element`


### **find_button**
Finds a button on the page.

- **Arguments**: `([locator], **options)`

- **Returns**: `Capybara::Node::Element`


### **find_by_id**
Finds a element on the page, given its id.

- **Arguments**: `(id, **options, &optional_filter_block)`

- **Returns**: `Capybara::Node::Element`


### **find_field**
Finds a form field on the page.

- **Arguments**: `([locator], **options)`

- **Returns**: `Capybara::Node::Element`


### **find_link**
Finds a link on the page.

- **Arguments**: `([locator], **options)`

- **Returns**: `Capybara::Node::Element`


### **first**
Finds the first element on the page matching the given selector and options.

- **Arguments**: `([kind], locator, options)`

- **Returns**: `Capybara::Node::Element`


### **sibling**
Finds an Element based on the given arguments that is also a sibling of the element called on.

- **Arguments**: `(*args, **options, &optional_filter_block)`

- **Returns**: `Capybara::Node::Element`


## Matchers

Check the [guide][Matchers] for a quick tour.

Have in mind that matchers have some [caveats][matcher caveats], so prefer [assertions] when possible.

### **has_ancestor?**
Predicate version of #assert_ancestor.

- **Arguments**: `(*args, **options, &optional_filter_block)`

- **Returns**: `Boolean`


### **has_button?**
Checks if the page or current node has a button with the given text, value or id.

- **Arguments**: `(locator = nil, **options, &optional_filter_block)`

- **Returns**: `Boolean`


### **has_checked_field?**
Checks if the page or current node has a radio button or checkbox with the given label, value, id, or test_id attribute that is currently checked.

- **Arguments**: `(locator = nil, **options, &optional_filter_block)`

- **Returns**: `Boolean`

### **has_css?**
Checks if a given CSS selector is on the page or a descendant of the current node.

- **Arguments**: `(path, **options, &optional_filter_block)`

- **Returns**: `Boolean`


### **has_field?**
Checks if the page or current node has a form field with the given label, name or id.

- **Arguments**: `(locator = nil, **options, &optional_filter_block)`

- **Returns**: `Boolean`


### **has_link?**
Checks if the page or current node has a link with the given text or id.

- **Arguments**: `(locator = nil, **options, &optional_filter_block)`

- **Returns**: `Boolean`



### **has_select?**
Checks if the page or current node has a select field with the given label, name or id.

- **Arguments**: `(locator = nil, **options, &optional_filter_block)`

- **Returns**: `Boolean`


### **has_selector?**
Checks if a given selector is on the page or a descendant of the current node.

- **Arguments**: `(*args, **options, &optional_filter_block)`

- **Returns**: `Boolean`


### **has_sibling?**
Predicate version of #assert_sibling.

- **Arguments**: `(*args, **options, &optional_filter_block)`

- **Returns**: `Boolean`


### **has_table?**
Checks if the page or current node has a table with the given id or caption:.

- **Arguments**: `(locator = nil, **options, &optional_filter_block)`

- **Returns**: `Boolean`


### **has_text?**
Checks if the page or current node has the given text content, ignoring any HTML tags.

- **Arguments**: `(*args, **options)`

- **Returns**: `Boolean (also: #has_content?)`


### **has_unchecked_field?**

Checks if the page or current node has a radio button or checkbox with the given label, value or id, or test_id attribute that is currently unchecked.

- **Arguments**: `(locator = nil, **options, &optional_filter_block)`

- **Returns**: `Boolean`

### **has_xpath?**
Checks if a given XPath expression is on the page or a descendant of the current node.

- **Arguments**: `(path, **options, &optional_filter_block)`

- **Returns**: `Boolean`


### **matches_css?**
Checks if the current node matches given CSS selector.

- **Arguments**: `(css, **options, &optional_filter_block)`

- **Returns**: `Boolean`


### **matches_selector?**
Checks if the current node matches given selector.

- **Arguments**: `(*args, **options, &optional_filter_block)`

- **Returns**: `Boolean`


### **matches_style?**
Checks if a an element has the specified CSS styles.

- **Arguments**: `(styles = nil, **options)`

- **Returns**: `Boolean`


### **matches_xpath?**
Checks if the current node matches given XPath expression.

- **Arguments**: `(xpath, **options, &optional_filter_block)`

- **Returns**: `Boolean`


## Scoping

Check the [guide][scoping] for a quick tour.

### **within**

Executes the given block within the context of the specified element.

For the duration of the block, any command to Capybara will be scoped to the given element.

When called without parameters the block will be scoped to the [current element].

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

Useful as a escape hatch to interact with content outside a previous `within` call, such as modals.

### **within_fieldset**

Executes the given block within the specific fieldset.

- **Arguments**:
  -  `{String} locator`: id or legend of the fieldset

### **within_frame**

Executes the given block within the given iframe.

- **Arguments**:
  -  `{String} frame`: frame, id, name, or index of the frame

### **within_table**

Executes the given block within the a specific table.

- **Arguments**:
  -  `{String} locator`: id or caption of the table

### **within_window**

Switches to the given window, executes the given block within that window, and then switches back to the original window.

- **Arguments**:
  -  `{Capybara::Window | Proc } window`: window to switch to

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

## Synchronization

Check the [guide][Synchronization] for a quick tour.

### **synchronize**

This method is Capybara's primary way to deal with asynchronicity.

Learn more about it [in the documentation][capybara_synchronize].

You should rarely need to use this directly, check `synchronize_expectation` instead.

- **Options**:
  -  `{Array} :errors`: exception classes that should be retried
  -  `{Numeric} :wait`: amount of seconds to retry the block before it succeeds or times out

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
  -  `{Array} :retry_on_errors`: additional exception classes that should be retried
  -  `{Numeric} :wait`: amount of seconds to retry the block before it succeeds or times out

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
  -  `{Numeric} seconds`: the default maximum wait time for retried commands

- **Example**:
  ```ruby
  def wait_and_hover
    using_wait_time(10) { hover }
  end
  ```

## Modals

### **accept_alert**

Executes the block, accepting an alert that is opened while it executes.

- **Arguments**:
  -  `{String | Regexp} text (optional)`: text that the modal should contain

### **accept_confirm**

Executes the block, accepting a confirmation dialog that is opened while it executes.

- **Arguments**:
  -  `{String | Regexp} text (optional)`: text that the modal should contain

- **Example**:
  ```ruby
  def delete(city)
    accept_confirm { row_for(city).click_on('Destroy') }
  end
  ```

### **accept_prompt**

Executes the block, accepting a prompt, and optionally responding to it.

- **Arguments**:
  -  `{String | Regexp} text (optional)`: text that the prompt should contain
  - __Options__:
      - `{String} :with (optional)`: input for the prompt

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

Path helpers can be easily [made available to test helpers](https://github.com/ElMassimo/capybara_test_helpers/blob/819ad283ba32468fbc67a4d45c929f4efac5a464/examples/rails_app/test_helpers/routes_test_helper.rb#L25-L43).

- **Arguments**:
  - `visit_uri`: The URL to navigate to. The parameter will be cast to a `String`.

- **Example**:

  ```ruby
  def visit_page
    visit cities_path
  end
  ```

## Debugging

### **flash**

Toggles the [current element] background color between white and black for a period of time.

### **inspect_node**

Inspects the `Capybara::Node::Element` element the test helper is wrapping.

### **save_and_open_page**

Saves a snapshot of the page and open it in a browser for inspection. Requires [`launchy`][launchy].


- **Arguments**:
  - `{String} path (optional)`: the path to where it should be saved

### **save_and_open_screenshot**

Save a screenshot of the page and open it for inspection. Requires [`launchy`][launchy].

- **Arguments**:
  - `{String} path (optional)`: the path to where it should be saved

- **Returns**:
  - `{String} path`: the path to which the file was saved

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

- **Arguments**:
  - `{String} path (optional)`: the path to where it should be saved

- **Returns**:
  - `{String} path`: the path to which the file was saved

### **save_screenshot**

Saves a screenshot of the page.

- **Arguments**:
  - `{String} path (optional)`: the path to where it should be saved

- **Returns**:
  - `{String} path`: the path to which the file was saved

## Page

### **have_title**
[Asserts][api_assertions] if the page has the given title.

- **Arguments**:
  - `{String | Regexp} title`: string or regex that the title should match
  - __Options__:
    - `{Boolean} :exact`: defaults to `false`, whether the provided string should be an exact match or just a substring

- **Example**:
  ```ruby
  current_page.should.have_title('Capybara Test Helpers', exact: false)
  ```

### **has_title?**

[Checks][api_matchers] if the page has the given title.

- **Arguments**:
  - `{String | Regexp} title`: string or regex that the title should match
  - __Options__:
    - `{Boolean} :exact`: defaults to `false`, whether the provided string should be an exact match or just a substring

- **Returns**: `Boolean`

- **Example**:
  ```ruby
  current_page.has_title?('Capybara Test Helpers', wait: false)
  ```

### **page.html**
- **Returns**: `String` snapshot of the DOM of the current document

### **page.title**
- **Returns**: `String` title of the document

## Window

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

- **Arguments**: `{Symbol} kind` defaults to `:tab`

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

- **Options**: `{Numeric} :wait`: seconds to wait a new window to be opened

- **Returns**: `Capybara::Window` opened in the block

- **Examples**:
  ```ruby
  checkout_window = window_opened_by { click_button('Checkout') }
  ```

### **windows**

All the windows that are currently open. The order depends on the driver, don't rely on it.

 - **Returns**: `Array<Capybara::Window>`

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
