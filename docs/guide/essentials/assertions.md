[capybara querying]: https://github.com/teamcapybara/capybara#querying
[should]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/lib/capybara_test_helpers/assertions.rb#L10-L15
[should_not]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/lib/capybara_test_helpers/assertions.rb#L17-L22
[positive and negative assertions]: https://maximomussini.com/posts/cucumber-to_or_not_to/
[assertions]: /guide/advanced/assertions

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

If an assertion is not met, the test will fail with an error describing the result.

## Custom Assertions 🎩

The example above becomes a lot nicer if we define a more semantic assertion,
which can be easily done by leveraging an existing assertion, such as `have`:

```ruby
class UsersTestHelper < BaseTestHelper
  def have_user(*names)
    within_table { have(:table_row, names) }
  end
end
```

and then use it as:

```ruby
users
  .should.have_user('Jane', 'Doe')
  .should_not.have_user('John', 'Doe')
```

Notice that you don't need to define both the [positive and negative assertions]: both are available because `have` already handles the [_assertion state_](#understanding-the-assertion-state).

You can also create your own [assertions from scratch][assertions] and use the assertion state manually.

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
