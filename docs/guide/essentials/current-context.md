[actions]: /guide/essentials/actions
[alias]: /guide/essentials/aliases
[finders]: /guide/essentials/finders
[to_capybara_node]: /api/#to-capybara-node
[injection]: /guide/essentials/injection
[wrapping]: /api/#wrap-element

# Understanding the Context

By default, test helpers wrap the current `session`, aliased in Capybara as `page`.

[Finders] and certain [actions] will return a specific element, which will be [wrapped][wrapping] with a new test helper.

```ruby
scenario 'edit user', test_helpers: [:users] do
  user = users.find(:table_row, { 'Name' => 'Kim' })
  user.click_link('Edit')
end
```

In this example, the __context__ for `users` is the entire `page`, because it was [injected][injection] in the test.

On the other hand, the __context__ for `user` is the table row returned by `find`, which we say it's the __current element__ for that helper.

## Current Element

Certain methods can only be performed on node elements, such as `click`, `hover` or `set`.

When calling these methods on a test helper without a current element, an element will be [obtained][to_capybara_node] by using an `:el` [alias] defined in the test helper.

`:el` should always be the top-level element that the test helper is encapsulating, which could be a small component, or an entire page.

```ruby
class CheckboxTestHelper < BaseTestHelper
  aliases(
    el: 'input[type=checkbox]',
  )
end

checkbox.value
# same as
checkbox.el.value
# same as
find('input[type=checkbox]').value
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
