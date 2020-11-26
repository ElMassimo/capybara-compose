[aliases]: /guide/essentials/aliases
[injection]: /guide/essentials/injection
[el convention]: /guide/essentials/current-context.html#current-element
[assertion state]: /guide/essentials/assertions.html#understanding-the-assertion-state
[current context]: /guide/essentials/current-context.html
[current element]: /guide/essentials/current-context.html#current-element
[wrapping]: /api/#wrap-element
[use_test_helpers]: /api/#use-test-helpers
[to_capybara_node]: /api/#to-capybara-node

# Composition and Injection 🧩

As described in [_Using Test Helpers_][injection], it's possible to easily combine test helpers.

In this section, we dive into detail on different use cases and ways to solve them.

## Understanding Injection

Let's say that we want to leverage some logic from our `TableTestHelper`.

```ruby
class TableTestHelper < BaseTestHelper
  def row_for(*cells)
    find(:table_row, cells)
  end

  def have_row(*cells)
    have(:table_row, cells)
  end
end
```

We will inject this helper with [`use_test_helpers`][use_test_helpers].

```ruby
class UsersTestHelper < BaseTestHelper
  use_test_helpers(:table)

  aliases(
    el: '.users'
  )

  def find_user(name)
    within { table.row_for(name) }
  end

  def click_to_edit
    click_link('Edit')
  end

  def have_user(name)
    within { table.have_row(name) }
    self
  end
end
```

Every time we call `table`, an instance of `TableTestHelper` is returned.

::: tip
Injected test helpers will preserve the _[assertion state]_ of the current helper.
:::

We can use any assertion without having to explicitly call `should` in the `table` helper.

```ruby
users.should.have_user('Jim').should_not.have_user('John')
```

## Wrapping 🎁

Any [injected helper][injection] can optionally take an element as a parameter, which will be [wrapped][wrapping] and used as the [initial context][current context] for the returned helper.

```ruby
  def find_user(name)
    table(self).row_for(name) # same as: table.wrap_element(el).row_for(name)
  end
```

Just as before using `within`, it will only find rows inside the `.user` element.

```ruby
users.find_user('Jim')
# same as
find('.users').find(:table_row, ['Jim'])
```

### Wrapping to Chain

In the examples above, `find_user` returns an instance of `TableTestHelper`:

```ruby
users.find_user('Jim').click_to_edit
# NoMethodError: undefined method `click_to_edit' for #<TableTestHelper tag="tr">
```

We can workaround this by wrapping the result:

```ruby
  def find_user(name)
    wrap_element table(self).row_for(name)
  end
```
```ruby
users.find_user('Jim').click_to_edit
# #<UsersTestHelper tag="a">
```

## Inheritance

Another way to share functionality between test helpers is to use inheritance.

Just like methods, any [aliases] defined in ancestors will also be available in the subclass.

```ruby
Capybara.get_test_helper_class(:table) # or require_relative './table_test_helper'

class UsersTestHelper < TableTestHelper
  aliases(
    el: '.users'
  )

  def find_user(name)
    el.row_for(name)
  end

  def click_to_edit
    click_link('Edit')
  end
end
```

Because we are using inheritance, we can skip all the wrapping and context switching from the previous examples.

```ruby
users.find_user('Jim').click_to_edit
# #<UsersTestHelper tag="a">
```
Simple is better though, and composition should be preferred over inheritance in most cases.

## Using the Current Element

You can leverage the [current element] as needed when creating your own actions or assertions by calling [`to_capybara_node`][to_capybara_node]:

```ruby
def focus
  to_capybara_node.execute_script('this.focus()')
  self
end
```

Have in mind that in most cases this is unnecessary, as many actions such as `click` already use the [current element].
