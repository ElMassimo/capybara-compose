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
  def be_checked
    expect(checked?).to_or not_to, eq(true)
  end
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
  def be_disabled
    expect(disabled?).to_or not_to, eq(true)
  end
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

- **Returns**: `{ x, y, height, width }`

### **right_click**

Right clicks the [current element].

- **Arguments**: Same as [`click`][click].

- **Returns**: `self`

### **scroll_to**

- Scroll the page or element to its top, bottom or middle.
  - `{:top | :bottom | :center | :current} position`

  ```ruby
  current_page.scroll_to(:top, offset: [0, 20])
  ```

- Scroll the page or current element into view until the given element is aligned as specified.
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
(wait: nil) ⇒ Capybara::Node::Element
Select this node if it is an option element inside a select tag.

### **selected?**
⇒ Boolean
Whether or not the element is selected.

### **send_keys**
(keys, ...) ⇒ Capybara::Node::Element
Send Keystrokes to the Element.

### **set**
(value, **options) ⇒ Capybara::Node::Element
Set the value of the form element to the given value.

### **style**
(*styles) ⇒ Hash
Retrieve the given CSS styles.

### **tag_name**
⇒ String
The tag name of the element.

### **text**
(type = nil, normalize_ws: false) ⇒ String
Retrieve the text of the element.

### **trigger**
(event) ⇒ Capybara::Node::Element
Trigger any event on the current element, for example mouseover or focus events.

### **unselect_option**
(wait: nil) ⇒ Capybara::Node::Element
Unselect this node if it is an option element inside a multiple select tag.

### **value**
 ⇒ String
The value of the form element.

### **visible?**
 ⇒ Boolean
Whether or not the element is visible.

## Actions

Check the [guide][Actions] for a quick tour.

### **attach_file**
(locator = nil, paths, make_visible: nil, **options) ⇒ Capybara::Node::Element
Find a descendant file field on the page and attach a file given its path.

### **check**
([locator], **options) ⇒ Capybara::Node::Element
Find a descendant check box and mark it as checked.

### **choose**
([locator], **options) ⇒ Capybara::Node::Element
Find a descendant radio button and mark it as checked.

### **click_button**
([locator], **options) ⇒ Capybara::Node::Element
Finds a button on the page and clicks it.

### **click_link**
([locator], **options) ⇒ Capybara::Node::Element
Finds a link by id, test_id attribute, text or title and clicks it.

### **click_on**
([locator], **options) ⇒ Capybara::Node::Element (also: #click_on)
Finds a button or link and clicks it.

### **fill_in**
([locator], with: , **options) ⇒ Capybara::Node::Element
Locate a text field or text area and fill it in with the given text.

### **select**
(value = nil, from: nil, **options) ⇒ Capybara::Node::Element
If from option is present, #select finds a select box, or text input with associated datalist, on the page and selects a particular option from it.

### **uncheck**
([locator], **options) ⇒ Capybara::Node::Element
Find a descendant check box and uncheck it.

### **unselect**
(value = nil, from: nil, **options) ⇒ Capybara::Node::Element
Find a select box on the page and unselect a particular option from it.


## Assertions

Check the [guide][Assertions] for a quick tour.

To use an assertion, call [`should`][should] or [`should_not`][should_not], and then chain the assertion.

Negated versions are available for most, such as `have_no_selector`, but are ommitted for brevity.

### **have_all_of_selectors**
(*args, **kw_args, &optional_filter_block) ⇒ Object
RSpec matcher for whether the element(s) matching a group of selectors exist.

### **have_ancestor**
(*args, **kw_args, &optional_filter_block) ⇒ Object
RSpec matcher for whether ancestor element(s) matching a given selector exist.

### **have_any_of_selectors**
(*args, **kw_args, &optional_filter_block) ⇒ Object
RSpec matcher for whether the element(s) matching any of a group of selectors exist.

### **have_button**
(locator = nil, **options, &optional_filter_block) ⇒ Object
RSpec matcher for buttons.

### **have_checked_field**
(locator = nil, **options, &optional_filter_block) ⇒ Object
RSpec matcher for checked fields.

### **have_css**
(css, **options, &optional_filter_block) ⇒ Object
RSpec matcher for whether elements(s) matching a given css selector exist.

### **have_current_path**
(path, **options, &optional_filter_block) ⇒ Object
RSpec matcher for the current path.

### **have_field**
(locator = nil, **options, &optional_filter_block) ⇒ Object
RSpec matcher for form fields.

### **have_link**
(locator = nil, **options, &optional_filter_block) ⇒ Object
RSpec matcher for links.

### **have_none_of_selectors**
(*args, **kw_args, &optional_filter_block) ⇒ Object
RSpec matcher for whether no element(s) matching a group of selectors exist.

### **have_select**
(locator = nil, **options, &optional_filter_block) ⇒ Object
RSpec matcher for select elements.

### **have_selector**
(*args, **kw_args, &optional_filter_block) ⇒ Object
RSpec matcher for whether the element(s) matching a given selector exist.

### **have_sibling**
(*args, **kw_args, &optional_filter_block) ⇒ Object
RSpec matcher for whether sibling element(s) matching a given selector exist.

### **have_table**
(locator = nil, **options, &optional_filter_block) ⇒ Object
RSpec matcher for table elements.

### **have_text**
(text_or_type, *args, **options) ⇒ Object (also: #have_content)
RSpec matcher for text content.

### **have_unchecked_field**
(locator = nil, **options, &optional_filter_block) ⇒ Object
RSpec matcher for unchecked fields.

### **have_xpath**
(xpath, **options, &optional_filter_block) ⇒ Object
RSpec matcher for whether elements(s) matching a given xpath selector exist.

### **match_css**
(css, **options, &optional_filter_block) ⇒ Object
RSpec matcher for whether the current element matches a given css selector.

### **match_selector**
(*args, **kw_args, &optional_filter_block) ⇒ Object
RSpec matcher for whether the current element matches a given selector.

### **match_style**
(styles = nil, **options) ⇒ Object
RSpec matcher for element style.

### **match_xpath**
(xpath, **options, &optional_filter_block) ⇒ Object
RSpec matcher for whether the current element matches a given xpath selector.

## Finders

Check the [guide][Finders] for a quick tour, or [learn how to filter with blocks][filtering].

### **all**
([kind = Capybara.default_selector], locator = nil, **options) ⇒ Capybara::Result (also: #find_all)
Find all elements on the page matching the given selector and options.

### **ancestor**
(*args, **options, &optional_filter_block) ⇒ Capybara::Node::Element
Find an Element based on the given arguments that is also an ancestor of the element called on.

### **find**
(*args, **options, &optional_filter_block) ⇒ Capybara::Node::Element
Find an Element based on the given arguments.

### **find_button**
([locator], **options) ⇒ Capybara::Node::Element
Find a button on the page.

### **find_by_id**
(id, **options, &optional_filter_block) ⇒ Capybara::Node::Element
Find a element on the page, given its id.

### **find_field**
([locator], **options) ⇒ Capybara::Node::Element
Find a form field on the page.

### **find_link**
([locator], **options) ⇒ Capybara::Node::Element
Find a link on the page.

### **first**
([kind], locator, options) ⇒ Capybara::Node::Element
Find the first element on the page matching the given selector and options.

### **sibling**
(*args, **options, &optional_filter_block) ⇒ Capybara::Node::Element
Find an Element based on the given arguments that is also a sibling of the element called on.

## Matchers

Check the [guide][Matchers] for a quick tour.

Have in mind that matchers have some [caveats][matcher caveats], so prefer [assertions] when possible.

### **has_ancestor?**
(*args, **options, &optional_filter_block) ⇒ Boolean

Predicate version of #assert_ancestor.

### **has_button?**
(locator = nil, **options, &optional_filter_block) ⇒ Boolean
Checks if the page or current node has a button with the given text, value or id.

### **has_checked_field?**
(locator = nil, **options, &optional_filter_block) ⇒ Boolean
Checks if the page or current node has a radio button or checkbox with the given label, value, id, or test_id attribute that is currently checked.

### **has_css?**
(path, **options, &optional_filter_block) ⇒ Boolean
Checks if a given CSS selector is on the page or a descendant of the current node.

### **has_field?**
(locator = nil, **options, &optional_filter_block) ⇒ Boolean
Checks if the page or current node has a form field with the given label, name or id.

### **has_link?**
(locator = nil, **options, &optional_filter_block) ⇒ Boolean
Checks if the page or current node has a link with the given text or id.

### **has_no_ancestor?**
(*args, **options, &optional_filter_block) ⇒ Boolean

Predicate version of #assert_no_ancestor.

### **has_no_button?**
(locator = nil, **options, &optional_filter_block) ⇒ Boolean
Checks if the page or current node has no button with the given text, value or id.

### **has_no_checked_field?**
(locator = nil, **options, &optional_filter_block) ⇒ Boolean
Checks if the page or current node has no radio button or checkbox with the given label, value or id, or test_id attribute that is currently checked.

### **has_no_css?**
(path, **options, &optional_filter_block) ⇒ Boolean
Checks if a given CSS selector is not on the page or a descendant of the current node.

### **has_no_field?**
(locator = nil, **options, &optional_filter_block) ⇒ Boolean
Checks if the page or current node has no form field with the given label, name or id.

### **has_no_link?**
(locator = nil, **options, &optional_filter_block) ⇒ Boolean
Checks if the page or current node has no link with the given text or id.

### **has_no_select?**
(locator = nil, **options, &optional_filter_block) ⇒ Boolean
Checks if the page or current node has no select field with the given label, name or id.

### **has_no_selector?**
(*args, **options, &optional_filter_block) ⇒ Boolean
Checks if a given selector is not on the page or a descendant of the current node.

### **has_no_sibling?**
(*args, **options, &optional_filter_block) ⇒ Boolean

Predicate version of #assert_no_sibling.

### **has_no_table?**
(locator = nil, **options, &optional_filter_block) ⇒ Boolean
Checks if the page or current node has no table with the given id or caption.

### **has_no_text?**
(*args, **options) ⇒ Boolean (also: #has_no_content?)
Checks if the page or current node does not have the given text content, ignoring any HTML tags and normalizing whitespace.

### **has_no_unchecked_field?**
(locator = nil, **options, &optional_filter_block) ⇒ Boolean
Checks if the page or current node has no radio button or checkbox with the given label, value or id, or test_id attribute that is currently unchecked.

### **has_no_xpath?**
(path, **options, &optional_filter_block) ⇒ Boolean
Checks if a given XPath expression is not on the page or a descendant of the current node.

### **has_select?**
(locator = nil, **options, &optional_filter_block) ⇒ Boolean
Checks if the page or current node has a select field with the given label, name or id.

### **has_selector?**
(*args, **options, &optional_filter_block) ⇒ Boolean
Checks if a given selector is on the page or a descendant of the current node.

### **has_sibling?**
(*args, **options, &optional_filter_block) ⇒ Boolean

Predicate version of #assert_sibling.

### **has_table?**
(locator = nil, **options, &optional_filter_block) ⇒ Boolean
Checks if the page or current node has a table with the given id or caption:.

### **has_text?**
(*args, **options) ⇒ Boolean (also: #has_content?)
Checks if the page or current node has the given text content, ignoring any HTML tags.

### **has_unchecked_field?**
(locator = nil, **options, &optional_filter_block) ⇒ Boolean
Checks if the page or current node has a radio button or checkbox with the given label, value or id, or test_id attribute that is currently unchecked.

### **has_xpath?**
(path, **options, &optional_filter_block) ⇒ Boolean
Checks if a given XPath expression is on the page or a descendant of the current node.

### **matches_css?**
(css, **options, &optional_filter_block) ⇒ Boolean
Checks if the current node matches given CSS selector.

### **matches_selector?**
(*args, **options, &optional_filter_block) ⇒ Boolean
Checks if the current node matches given selector.

### **matches_style?**
(styles = nil, **options) ⇒ Boolean
Checks if a an element has the specified CSS styles.

### **matches_xpath?**
(xpath, **options, &optional_filter_block) ⇒ Boolean
Checks if the current node matches given XPath expression.

### **not_matches_css?**
(css, **options, &optional_filter_block) ⇒ Boolean
Checks if the current node does not match given CSS selector.

### **not_matches_selector?**
(*args, **options, &optional_filter_block) ⇒ Boolean
Checks if the current node does not match given selector.

### **not_matches_xpath?**
(xpath, **options, &optional_filter_block) ⇒ Boolean
Checks if the current node does not match given XPath expression.


## Scoping

Check the [guide][scoping] for a quick tour.

### **within**

Executes the given block within the context of the specified element.

For the duration of the block, any command to Capybara will be scoped to the given element.

When called without parameters the block will be scoped to the [current element].

- **Arguments**: Same as [`find`], can also handle [aliases].

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
