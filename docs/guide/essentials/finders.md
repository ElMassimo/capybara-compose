[api]: /api/
[capybara finding]: https://github.com/teamcapybara/capybara#finding
[selectors]: /guide/essentials/aliases
[actions]: /guide/essentials/actions
[assertions]: /guide/essentials/assertions
[to_capybara_node]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/lib/capybara_test_helpers/test_helper.rb#L56-L58
[adding a filter]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/spec/support/global_filters.rb#L6-L8
[el convention]: /guide/essentials/current-context.html#el-convention

# Finders 🧭

Finder methods such as `find` and `all` allow you to obtain specific elements in the page. They return a test helper wrapping the element found by Capybara.

All of the finders provided by the [Capybara DSL][capybara finding] are available to be used in test helpers.

<!-- You can check the [API Reference][api] for more information. -->

```ruby
users.find('table.users').find(:table_row)
form.find_field('First Name')
table.all(:table_row)
```

## Chaining 🔗

All finders wrap the result with a test helper so that you can chain methods to work with the returned element, or find other elements within it.

```ruby
class UsersTestHelper < BaseTestHelper
  def find_user(*name)
    find('table.users').find(:table_row, name)
  end

  def click_to_edit
    click_link('Edit')
  end
end

users.find_user('Bob').click_to_edit
# same as
find('table.users').find(:table_row, ['Bob']).click_link('Edit')
```

A way to make chaining even more terse is to use [getters][selectors].

## Scoping 🎯

You can use `within` to restrict certain actions to a specific area of the page.

Any operation inside the block will only target elements that are _within_ the specified selector.

```ruby
class UsersTestHelper < BaseTestHelper
  def add_user(first_name:)
    click_link('Add User')
    within('.new-user-modal') {
      fill_in 'First Name', with: first_name
      click_button 'Save'
    }
  end
end

users.add_user(first_name: 'Alice')
```

In the example above, the _Add User_ link could be anywhere on the page, while using `within` ensures that the _First Name_ field and the _Save_ button are inside the `.new-user-modal` element.

This is very helpful to make the test more explicit, and prevent interacting with similar fields in a different section of the page, which could cause ambiguity problems and race conditions.

### Implicit Scoping

When working with an element, it's possible to call `within` without parameters.

```ruby
users.find_user('Kim').within { click_link('Edit') }
# same as:
find('table.users').find(:table_row, ['Kim']).click_link('Edit')
```

This provides some nice syntax sugar when used in combination with the [`:el` convention][el convention].
