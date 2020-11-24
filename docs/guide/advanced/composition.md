[injection]: /guide/essentials/injection
[el convention]: /guide/essentials/current-context.html#el-convention
[assertion state]: /guide/essentials/assertions.html#understanding-the-assertion-state

# Advanced Composition 🧩

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

We will inject this helper by using `use_test_helpers`.

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

The returned instance will preserve the _[assertion state]_ of the `UsersTestHelper` instance, which means we can use any assertion without having to explicitly call `table.should(or_should_not).have_row(name)`.

```ruby
users.should.have_user('Jim').should_not.have_user('John')
```

## Wrapping 🎁

Any helper registered with `use_test_helper` can optionally take an element as a parameter.

```ruby
  def find_user(name)
    table(el).row_for(name) # same as: table.wrap_test_helper(el).row_for(name)
  end
```

When passing a test helper, the [`:el` convention][el convention] will be used to obtain an element to wrap if there is no current element.

```ruby
  def find_user(name)
    table(self).row_for(name) # same as: table.wrap_test_helper(to_capybara_node).row_for(name)
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
    wrap_test_helper table(self).row_for(name)
  end
```
```ruby
users.find_user('Jim').click_to_edit # #<UsersTestHelper tag="a">
```

## Inheritance

It is possible to avoid all of this wrapping and context switching by using inheritance.

```ruby
Capybara.get_test_helper_class(:table)

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
```ruby
users.find_user('Jim').click_to_edit # #<UsersTestHelper tag="a">
```

Simple is better though, and composition should be preferred over inheritance in most cases.
