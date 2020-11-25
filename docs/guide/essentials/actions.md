[api]: /api/
[capybara dsl]: https://github.com/teamcapybara/capybara#the-dsl
[aliases]: /guide/essentials/aliases
[to_capybara_node]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/lib/capybara_test_helpers/test_helper.rb#L56-L58
[wrap]: /api/#wrap-element

# Actions 🖱⌨️

All of the actions provided by the [Capybara DSL] are available to be used in test helpers.

You can check the [API Reference][api] for information about the available actions and their return value.

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
```

and then use it as:

```ruby
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
```
```ruby
users.add_user(name: 'Alice')
```

You may purposefully return `self` on some of your actions to allow chaining other methods.

## Finding the Right Balance ⚖️

Too many hardcoded labels can make tests brittle and time consuming to update. Generic actions can hide the intent behind the test making it __obscure__ and hard to understand.

On the other hand, too much abstraction can create unnecesary levels of __indirection__.

It's up to you to figure out __the right balance__ between using direct references to labels and selectors or creating more specific actions that describe a use case or interaction.
