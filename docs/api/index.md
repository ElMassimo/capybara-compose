---
sidebar: auto
---

# API Reference

All of the following methods can be called on a `Capybara::TestHelper` instance.

## Navigation

### **go_back**

Move back a single entry in the browser's history.

### **go_forward**

Move forward a single entry in the browser's history.

### **refresh**

Refresh the current page.

### **visit**

Navigate to the given URL.

- **Arguments**:
  - `visit_uri`

- **Example**:

```ruby
def visit_page
  visit cities_path
end
```

## Session

### **current_host**
 ⇒ String
Host of the current page.

### **current_path**
 ⇒ String
Path of the current page, without any domain information.

### **current_url**
 ⇒ String
Fully qualified URL of the current page.

## Test Helper

### **to_capybara_node**
 ⇒ Object

## Document

### **have_title**
(title, **options) ⇒ Object
Asserts if the page has the given title.

### **has_title?**
(title, **options) ⇒ Boolean
Checks if the page has the given title.

### **html**
 ⇒ String
(also: #body, #source)
A snapshot of the DOM of the current document, as it looks right now
(potentially modified by JavaScript).

### **title**
⇒ String
The title of the document.

## Element

### **[]**
(attribute) ⇒ String
Retrieve the given attribute.

### **allow_reload!**
(idx = nil) ⇒ Object

### **checked?**
⇒ Boolean
Whether or not the element is checked.

### **click**
(*modifier_keys, wait: nil, **offset) ⇒ Capybara::Node::Element
Click the Element.

### **disabled?**
⇒ Boolean
Whether or not the element is disabled.

### **double_click**
(*modifier_keys, wait: nil, **offset) ⇒ Capybara::Node::Element
Double Click the Element.

### **drag_to**
(node, **options) ⇒ Capybara::Node::Element
Drag the element to the given other element.

### **drop**
(*args) ⇒ Capybara::Node::Element
Drop items on the current element.

### **evaluate_async_script**
(script, *args) ⇒ Object
Evaluate the given JavaScript in the context of the element and obtain the result from a callback function which will be passed as the last argument to the script.

### **evaluate_script**
(script, *args) ⇒ Object
Evaluate the given JS in the context of the element and return the result.

### **execute_script**
(script, *args) ⇒ Object
Execute the given JS in the context of the element not returning a result.

### **flash**
⇒ Capybara::Node::Element
Toggle the elements background color between white and black for a period of time.

### **hover**
⇒ Capybara::Node::Element
Hover on the Element.

### **initial_cache**
⇒ Object private

### **inspect**
⇒ String
A human-readable representation of the element.

### **multiple?**
⇒ Boolean
Whether or not the element supports multiple results.

### **native**
⇒ Object
The native element from the driver, this allows access to driver specific methods.

### **obscured?**
⇒ Boolean
Whether or not the element is currently in the viewport and it **
(or descendants) would be considered clickable at the elements center point.

### **path**
⇒ String
An XPath expression describing where on the page the element can be found.

### **readonly?**
⇒ Boolean
Whether or not the element is readonly.

### **rect**
⇒ Object

### **reload**
⇒ Object private

### **right_click**
(*modifier_keys, wait: nil, **offset) ⇒ Capybara::Node::Element
Right Click the Element.

### **scroll_to**
(pos_or_el_or_x, y = nil, align: :top, offset: nil) ⇒ Capybara::Node::Element
Scroll the page or element.

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

## Aliases

## Assertions

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

### **within**
(*args, **kw_args)
 ⇒ Object
(also: #within_element)
Executes the given block within the context of a node.

### **within_document**

Unscopes the inner block from any previous `within` calls.

### **within_fieldset**
(locator, &block)
 ⇒ Object
Execute the given block within the a specific fieldset given the id or legend of that fieldset.

### **within_frame**
(*args, **kw_args)
 ⇒ Object
Execute the given block within the given iframe using given frame, frame name/id or index.

### **within_table**
(locator, &block)
 ⇒ Object
Execute the given block within the a specific table given the id or caption of that table.

### **within_window**
(window_or_proc)
 ⇒ Object
This method does the following:
1. Switches to the given window (it can be located by window instance/lambda/string).
2. Executes the given block (within window located at previous step).
3. Switches back (this step will be invoked even if an exception occurs at the second step).


## Synchronization

### **synchronize**
(seconds = nil, errors: nil) ⇒ Object
This method is Capybara's primary defence against asynchronicity problems.

### **synchronize_expectation**
(seconds = nil, errors: nil) ⇒ Object
This method is Capybara's primary defence against asynchronicity problems.

### **using_wait_time**
(seconds, &block)
 ⇒ Object
Yield a block using a specific maximum wait time.

## Modals

### **accept_alert**
(text = nil, **options, &blk)
 ⇒ String
Execute the block, accepting a alert.

### **accept_confirm**
(text = nil, **options, &blk)
 ⇒ String
Execute the block, accepting a confirm.

### **accept_prompt**
(text = nil, **options, &blk)
 ⇒ String
Execute the block, accepting a prompt, optionally responding to the prompt.


### **dismiss_confirm**
(text = nil, **options, &blk)
 ⇒ String
Execute the block, dismissing a confirm.

### **dismiss_prompt**
(text = nil, **options, &blk)
 ⇒ String
Execute the block, dismissing a prompt.

## Window

### **become_closed**
(**options) ⇒ Object
Wait for window to become closed.

### **current_window**
 ⇒ Capybara::Window
Current window.

### **open_new_window**
(kind = :tab)
 ⇒ Capybara::Window
Open a new window.

### **switch_to_frame**
(frame)
 ⇒ Object
Switch to the given frame.

### **switch_to_window**
(window = nil, **options, &window_locator)
 ⇒ Capybara::Window
Switch to the given window.

### **window_opened_by**
(**options, &block)
 ⇒ Capybara::Window
Get the window that has been opened by the passed block.

### **windows**
 ⇒ Array<Capybara::Window>
Get all opened windows.

## Debugging

### **save_and_open_page**
(path = nil)
 ⇒ Object
Save a snapshot of the page and open it in a browser for inspection.

### **save_and_open_screenshot**
(path = nil, **options)
 ⇒ Object
Save a screenshot of the page and open it for inspection.

### **save_page**
(path = nil)
 ⇒ String
Save a snapshot of the page.

### **save_screenshot**
(path = nil, **options)
 ⇒ String
Save a screenshot of page.

## Requests

### **server_url**
 ⇒ Object

### **status_code**
 ⇒ Integer
Returns the current HTTP status code as an integer.

### **response_headers**
 ⇒ Hash<String, String>
Returns a hash of response headers.

### **response_headers**
 ⇒ Hash<String, String>
Returns a hash of response headers.
