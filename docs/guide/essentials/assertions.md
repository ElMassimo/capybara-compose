[api]: /api/#assertions
[not_to]: /api/#not-to
[synchronization]: /guide/advanced/synchronization
[should]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/lib/capybara_test_helpers/assertions.rb#L10-L15
[should_not]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/lib/capybara_test_helpers/assertions.rb#L17-L22
[positive and negative assertions]: https://maximomussini.com/posts/cucumber-to_or_not_to/

# Assertions ☑️

[Assertions][api] allow you to check the existence of a specific element or condition, and __fail the test__ if the condition is not fulfilled.

To use an assertion, call [`should`][should] or [`should_not`][should_not], and then chain the assertion.

```ruby
users
  .should.have(:table_row, ['Jane', 'Doe']
  .should_not.have(:table_row, ['John', 'Doe'])
```

You can check the [API Reference][api] for information.

## Custom Assertions 🎩

The example above becomes nicer to read if we define a more semantic version:

```ruby
class UsersTestHelper < BaseTestHelper
  def have_user(*names)
    have(:table_row, names)
  end
end
```
```ruby
users
  .should.have_user('Jane', 'Doe')
  .should_not.have_user('John', 'Doe')
```

Notice that both the [positive and negative assertions] are available.

This is because [built-in assertions][api] like `have` already handle the __*assertion state*__.

## Understanding the Assertion State

When calling `should`, any assertion calls that follow will execute the positive expectation.

```ruby
users.should.have_selector('.user')
# same as
expect(users).to have_selector('.user')
```

On the other hand, after calling `should_not` any assertions will execute the negated expectation.

```ruby
users.should_not.have_selector('.user')
# same as
expect(users).not_to have_selector('.user')
```

## Using the Assertion State

Sometimes [built-in assertions][api] are not enough, and you need to create your own expectation.

The _assertion state_ is exposed as [`not_to`][not_to] as syntax sugar.

Use [`to_or not_to`][positive and negative assertions] to create an expectation that can be used with `should` or `should_not`.

```ruby
class CurrentPageTestHelper < BaseTestHelper
  def fullscreen?
    evaluate_script('Boolean(document.fullscreenElement)')
  end

  def be_fullscreen
    expect(fullscreen?).to_or not_to, eq(true)
  end
end

current_page.should.be_fullscreen
current_page.should_not.be_fullscreen
```

::: tip
When creating your own assertions, it's important to ensure they are [correctly synchronized][synchronization].
:::
