[cucumber_injection]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/examples/rails_app/features/step_definitions/city_steps.rb#L3

# Usage with Cucumber 🥒

When using Cucumber, you may call [`use_test_helpers`][cucumber_injection] in the step definitions.

You can then use helpers to encapsulate logic that can be reused in different steps.

```ruby
use_test_helpers(:cities)

When('I edit the {string} city with:') do |name, table|
  cities.edit(name, with: table.rows_hash.symbolize_keys)
end

When('I delete the {string} city') do |name|
  cities.delete(name)
end

Then(/^there should( not)? be an? "(.+?)" city$/) do |or_should_not, name|
  cities.should(or_should_not).have_city(name)
end
```

Capybara Test Helpers can be [a great way to share code](https://github.com/ElMassimo/capybara_test_helpers/blob/master/examples/rails_app/features/step_definitions/city_steps.rb) if you are writing both Cucumber and RSpec integration tests.

:::tip
Unless you are sharing Cucumber tests with stakeholders, RSpec will provide a better development experience, and will make it easier to achieve robust and maintainable tests.
:::
