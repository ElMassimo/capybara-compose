[capybara dsl]: https://github.com/teamcapybara/capybara#the-dsl
[rspec_injection]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/examples/rails_app/spec/system/cities_spec.rb#L7
[rspec_global_injection]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/examples/rails_app/spec/system/support/default_test_helpers.rb#L8
[cucumber_injection]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/examples/rails_app/features/step_definitions/city_steps.rb#L3
[example app]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/examples/rails_app
[capybara_test_helpers_tests]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/spec
[rspec matchers]: https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers

# Using Test Helpers

To make a test helper available in an RSpec test you can use the [`test_helpers` option][rspec_injection]
in a `describe`, `context` or `scenario`.

```ruby
RSpec.describe 'Cities', test_helpers: [:cities] do
# or
scenario 'submit the form', helpers: [:form, :users] do
```

## Inside Test Helpers

Using composition can help to keep your tests dry and make them easier to understand and update.

`use_test_helpers` provides getters for other test helpers, making it convenient to extract and reuse common functionality, such as forms, buttons, and other components.

```ruby
class CitiesTestHelper < BaseTestHelper
  use_test_helpers(:form, :table)

  def edit(name, with:)
    table.row_for(name).click_on('Edit')
    form.within {
      fill_in 'Name', with: with[:name]
      form.save
    }
  end
end
```

## In Cucumber

When using Cucumber, you may call [`use_test_helpers`][cucumber_injection] in the step definitions.

```ruby
use_test_helpers(:cities)

When('I edit the {string} city with:') do |name, table|
  cities.edit(name, with: table.rows_hash.symbolize_keys)
end
```

## Global Test Helpers

You can call [`use_test_helpers`][rspec_global_injection] in an RSpec helper module to make them available globally.

```ruby
module GlobalTestHelpers
  extend ActiveSupport::Concern

  included do
    use_test_helpers(:current_page, :routes)
  end
end

# Make the default helpers available in all feature or system tests.
RSpec.configure do |config|
  config.include(GlobalTestHelpers, type: :feature)
  config.include(GlobalTestHelpers, type: :system)
end
```

## Naming Conventions 🔤

The following convention is applied when injecting test helpers by using `use_test_helpers`, or the `test_helpers` option in RSpec scenarios:

| Shorthand Name                 | Test Helper Class        | File Name                                |
| ------------------------------ | ------------------------ | ---------------------------------------- |
| `:cities`                      | `CitiesTestHelper`       | `cities_test_helper.rb`     |
| `:form`                        | `FormTestHelper`         | `form_test_helper.rb`       |
| `:current_page`                | `CurrentPageTestHelper`  | `current_page_test_helper.rb`|


Test helpers should be located in a `test_helpers` folder at the root of your project.

You may configure a different location by configuring `helpers_paths`:

```ruby
CapybaraTestHelpers.config.helpers_paths = ['my_integration_test_helpers']
```

## Generating Test Helpers

When using Rails, you can generate a test helper by running:

    $ rails g test_helper users
