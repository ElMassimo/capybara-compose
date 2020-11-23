[actions]: /guide/essentials/actions
[alias]: /guide/essentials/aliases
[finders]: /guide/essentials/finders
[to_capybara_node]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/lib/capybara_test_helpers/test_helper.rb#L56-L58

# Understanding the Context

By default, a test helper wraps the current `page`.

Both [finders] and [actions] will return new test helpers that wrap the resulting element.

```ruby
kim = users.find_user('Kim')
```

Any method call on the resulting helpers will be scoped to the inner element.

```ruby
kim.click_link('Edit')
```

## Current Element

Certain actions can only be performed on node elements, such as `hover` or `set`.

Same with assertions such as `have_text` and `match_style`, or matchers as `has_ancestor?` and `has_sibling?`.

If a test helper is not wrapping an element when these methods are called, then [an element will be obtained][to_capybara_node] by using an `:el` [alias] defined in the test helper.

```ruby
class CheckboxTestHelper < BaseTestHelper
  SELECTORS = {
    el: 'input[type=checkbox]',
  }
end

checkbox.value
# same as
find('input[type=checkbox]').value

checkbox.click.checked?
# same as
find('input[type=checkbox]').click.checked?
```

This convention makes it less cumbersome to extract and use test helpers for simple components.

```ruby
class DropdownTestHelper < BaseTestHelper
  SELECTORS = {
    el: '.dropdown',
    toggle: '.dropdown-toggle',
  }

  def toggle_menu
    within { toggle.click }
  end
end

dropdown.toggle_menu
# same as
within('.dropdown') { find('.dropdown-toggle').click }
```

`:el` should always be the top-level element that the test helper is encapsulating, which could be a small component, or an entire page.

## Using the Current Element

You can leverage this convention as needed when creating your own actions by calling [`to_capybara_node`][to_capybara_node]:

```ruby
# Public: Useful to natively give focus to an element.
def focus
  to_capybara_node.execute_script('this.focus()')
  self
end
```

Have in mind that in most cases this is unnecessary, as the current element will be used implicitly when calling an action such as `click`, `hover`, or `set`.
