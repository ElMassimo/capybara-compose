[capybara querying]: https://github.com/teamcapybara/capybara#querying
[should]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/lib/capybara_test_helpers/assertions.rb#L10-L15
[should_not]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/lib/capybara_test_helpers/assertions.rb#L17-L22
[positive and negative assertions]: https://maximomussini.com/posts/cucumber-to_or_not_to/
[synchronization]: /guide/advanced/synchronization

# Assertions ☑️

You can use any of the [RSpec matchers provided by Capybara][capybara querying],
but usage in test helpers is slightly different.

Before using an assertion, you must call [`should`][should] or [`should_not`][should_not], and then
chain the RSpec matcher or your own custom assertion.

```ruby
users.find(:table)
  .should.have_selector(:table_row, ['Jane', 'Doe']
  .should_not.have_selector(:table_row, ['John', 'Doe'])
```

## Understanding the Assertion State

When calling `should`, any assertion calls that follow will execute the positive expectation (`to`).

```ruby
users.should.have_selector('.user')
# same as
expect(users).to have_selector('.user')
```

On the other hand, after calling `should_not` any assertions will execute the negated expectation (`not_to`).

```ruby
users.should_not.have_selector('.user')
# same as
expect(users).not_to have_selector('.user')
```

Calling an assertion without `should` or `should_not` will raise an error, to avoid development mistakes.

## Custom Assertions 🎩

The example above becomes a lot nicer if we define a more semantic assertion,
which can be easily done by leveraging an existing assertion:

```ruby
class UsersTestHelper < BaseTestHelper
  SELECTORS = {
    list: 'table.users',
  }

# Assertions: Check on element properties, used with `should` and `should_not`.
  def have_user(*names)
    have(:table_row, names)
  end
```

and then use it as:

```ruby
users.list
  .should.have_user('Jane', 'Doe')
  .should_not.have_user('John', 'Doe')
```

Notice that you don't need to define both the [positive and negative assertions]: both available because we are using an existing assertion which already handles the _assertion state_.

## Advanced Assertions ⚙️

Sometimes built-in assertions are not enough, and you need to use an expectation
directly.

The assertion state is exposed via the `not_to` method (also aliased as `or_should_not`).

Test helpers also provide the [`to_or` method][positive and negative assertions] to easily implement an assertion that you can use with both `should` or `should_not`.

```ruby
class CurrentPageTestHelper < BaseTestHelper
# Getters: A convenient way to get related data or nested elements.
  def fullscreen?
    evaluate_script('!!(document.mozFullScreenElement || document.webkitFullscreenElement)')
  end

# Assertions: Allow to check on element properties while keeping it DRY.
  def be_fullscreen
    expect(fullscreen?).to_or not_to, eq(true)
  end
end

current_page.should.be_fullscreen
current_page.should_not.be_fullscreen
```

Make sure to [synchronize these expectations][synchronization] to avoid flaky tests.
