[api]: /api/#finders
[find]: /api/#find
[all]: /api/#all
[within]: /api/#within
[aliases]: /guide/essentials/aliases
[actions]: /guide/essentials/actions

# Finders 🧭

Finder methods such as [`find`][find] and [`all`][all] allow you to obtain specific elements in the page. They return a test helper wrapping the element found by Capybara.

You can check the [API Reference][api] for more information.

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
```
```ruby
users.find_user('Bob').click_to_edit
# same as
find('table.users').find(:table_row, ['Bob']).click_link('Edit')
```

A way to make chaining even more terse is to use [aliases shortcuts][aliases].

## Scoping 🎯

You can use [`within`][within] to restrict certain actions to a specific area of the page.

Any operation inside the block will only target elements that are _within_ the specified selector or element.

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
```
```ruby
users.add_user(first_name: 'Alice')
```

In the example above, the _Add User_ link could be anywhere on the page, while using [`within`][within] ensures that the _First Name_ field and the _Save_ button are inside the `.new-user-modal` element.

This is very helpful to make the test more explicit, and prevent interacting with similar fields in a different section of the page, which could cause ambiguity problems and race conditions.
