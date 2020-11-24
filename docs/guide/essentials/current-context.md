[actions]: /guide/essentials/actions
[alias]: /guide/essentials/aliases
[finders]: /guide/essentials/finders
[to_capybara_node]: /api/#to-capybara-node
[injection]: /guide/essentials/injection

# Understanding the Context

By default, [injected test helpers][injection] wrap the current `session` (aliased in Capybara as `page`).

[Finders] and certain [actions] will return a specific element, which will be wrapped with a new test helper.

```ruby
scenario 'edit user', test_helpers: [:users] do
  user = users.find(:table_row, { 'Name' => 'Kim' })
  user.click_link('Edit')
end
```

In this example, the __context__ for `users` is the entire `page`, because it was [injected][injection] in the test.

On the other hand, the __context__ for `user` is the table row returned by `find`, which we say it's the __current element__ for that helper. Any methods will work with the table row, instead of the entire page.

## Current Element

Certain actions can only be performed on node elements, such as `click`, `hover` or `set`.

Same with assertions such as `have_text` and `match_style`, or matchers like `has_ancestor?` and `has_sibling?`.

When these methods are called in an [injected test helper][injection], an element will be [obtained][to_capybara_node] by using an `:el` [alias] defined in the test helper.

```ruby
class CheckboxTestHelper < BaseTestHelper
  aliases(
    el: 'input[type=checkbox]',
  )
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
  aliases(
    el: '.dropdown',
    toggle: '.dropdown-toggle',
  )

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
