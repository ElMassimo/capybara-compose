[api]: /api/
[capybara dsl]: https://github.com/teamcapybara/capybara#the-dsl
[selectors]: /guide/essentials/aliases
[to_capybara_node]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/lib/capybara_test_helpers/test_helper.rb#L56-L58

# Actions 🖱⌨️

All of the actions provided by the [Capybara DSL] are available to be used in test helpers.

<!-- You can check the [API Reference][api] for information about the available actions and their return value. -->

```ruby
users.click_link('Add')
form.fill_in('Name', with: 'Alice')
form.click_button('Save')
```

Although it's possible to target specific elements and labels directly, it's often beneficial to encapsulate interactions to make them more __semantic__.

```ruby
users.add_user(name: 'Alice')
```

By decoupling usage from implementation, tests become __easier to understand__, and require less frequent updates and less effort to update when needed.

## Custom Actions ⚡️

You can create a custom action by defining an instance method in a test helper.

```ruby
class FormTestHelper < Capybara::TestHelper
  def save
    click_button('Save')
  end
end

form.save
```

Creating actions with descriptive names can make a test a lot easier to follow.

```ruby
class UsersTestHelper < Capybara::TestHelper
  use_test_helpers(:form)

  def add_user(name:)
    click_link('Add')
    fill_in('Name', with: name)
    form.save
  end
end

users.add_user(name: 'Alice')
```

## Return Values ⏎

In order to provide a consistent development experience, all actions will preserve
the original return value from Capybara.

For example, `click` returns the same element, while `fill_in` returns the specified field instead.

```ruby
save_button = form.find_button('Save').click
name_field = form.fill_in('Name', with: name)
```

When the return value of the capybara method is an element, it will be
_automatically wrapped_ so that other actions or selectors from the test helper
can be chained.

You may return `self` on your custom actions to achieve a more fluent API whenever the default behavior is not desirable.

<!-- You can check the [API Reference][api] for information about the available actions and their return value. -->

## Finding the Right Balance ⚖️

Too many hardcoded labels can make tests brittle and time consuming to update. Generic actions can hide the intent behind the test making it __obscure__ and hard to understand.

On the other hand, too much abstraction can create unnecesary levels of __indirection__.

It's up to you to figure out __the right balance__ between direct references to labels and selectors, and more specific actions that describe a use case or interaction.
