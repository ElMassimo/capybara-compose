[capybara dsl]: https://github.com/teamcapybara/capybara#the-dsl
[rspec_injection]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/examples/rails_app/spec/system/cities_spec.rb#L7
[rspec_global_injection]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/examples/rails_app/spec/system/support/default_test_helpers.rb#L8
[cucumber_injection]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/examples/rails_app/features/step_definitions/city_steps.rb#L3
[example app]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/examples/rails_app
[capybara_test_helpers_tests]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/spec
[rspec matchers]: https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers

# Getting Started 🚀

Using Capybara Test Helpers is very similar to using plain Capybara.

Every single method in the [Capybara DSL] is available inside test helpers, as
well as the [built-in RSpec matchers][rspec matchers].

The advantage is that when we add test helpers to the mix, it becomes easier to
encapsulate and modularize the interactions with different pages or UI components.

Here's an example:

## Integration Test

```ruby
RSpec.describe 'Cities', test_helpers: [:cities] do
  let!(:nyc) { cities.given_there_is_a_city('NYC') }

  before { cities.visit_page }

  scenario 'valid inputs' do
    cities.add(name: 'Minneapolis')
    cities.should.have_city('Minneapolis')
  end

  scenario 'invalid inputs' do
    cities.add(name: '') { |form|
      form.should.have_error("Name can't be blank")
    }
  end

  scenario 'editing a city' do
    cities.edit(nyc, with: { name: 'New York City' })
    cities.should_no_longer.have_city('NYC')
    cities.should_now.have_city('New York City')
  end

  scenario 'deleting a city', screen_size: :phone do
    cities.delete(nyc)
    cities.should_no_longer.have_city('NYC')
  end
end
```

<details>
  <summary>See this test <b>without</b> test helpers</summary>

```ruby
RSpec.describe 'Cities' do
  let!(:nyc) { City.create!(name: 'NYC') }

  before { visit(cities_path) }

  scenario 'valid inputs' do
    click_on('New City')
    within('form') {
      fill_in 'Name', with: 'Minneapolis'
      click_button(type: 'submit')
    }
    within('table.cities') {
      expect(page).to have_selector(:table_row, { 'Name' => 'Minneapolis' })
    }
  end

  scenario 'invalid inputs' do
    click_on('New City')
    within('form') {
      fill_in 'Name', with: ''
      click_button(type: 'submit')
      expect(page).to have_selector('#error_explanation', text: "Name can't be blank")
    }
  end

  scenario 'editing a city' do
    within('.table.cities') {
      find(:table_row, { 'Name' => 'NYC' }).click_on('Edit')
    }
    within('form') {
      fill_in 'Name', with: 'New York City'
      click_button(type: 'submit')
    }
    within('table.cities') {
      expect(page).not_to have_selector(:table_row, { 'Name' => 'NYC' })
      expect(page).to have_selector(:table_row, { 'Name' => 'New York City' })
    }
  end

  scenario 'deleting a city' do
    within('.table.cities') {
      nyc_row = find(:table_row, { 'Name' => 'NYC' })
      accept_confirm { nyc_row.click_on('Destroy') }
    }
    within('table.cities') {
      expect(page).not_to have_selector(:table_row, { 'Name' => 'NYC' })
    }
  end
end
```
</details>

## Test Helper

```ruby
class CitiesTestHelper < Capybara::TestHelper
  use_test_helpers(:form, :table)

# Selectors: Semantic aliases for elements, a useful abstraction.
  SELECTORS = {
    el: 'table.cities',
  }

# Getters: A convenient way to get related data or nested elements.
  def row_for(city)
    within { table.row_for(city.name) }
  end

# Actions: Encapsulate complex actions to provide a cleaner interface.
  def add(**args)
    click_on('New City')
    save_city(**args)
    yield(form) if block_given?
  end

  def edit(city, with:)
    row_for(city).click_on('Edit')
    save_city(**with)
  end

  def delete(city)
    accept_confirm { row_for(city).click_on('Destroy') }
  end

  private \
  def save_city(name:)
    form.within {
      fill_in 'Name', with: name
      form.save
    }
  end

# Assertions: Check on element properties, used with `should` and `should_not`.
  def have_city(name)
    within { have(:table_row, { 'Name' => name }) }
  end

# Background: Helpers to add/modify/delete data in the database or session.
  def given_there_is_a_city(name)
    City.create!(name: name)
  end
end
```

You can find [this working example](https://github.com/ElMassimo/capybara_test_helpers/blob/master/examples/rails_app/spec/system/cities_spec.rb) and more in the [example app] and the [Capybara tests][capybara_test_helpers_tests].

## Injecting Test Helpers

### In RSpec

To make the test helper available you can use the [`test_helpers` option][rspec_injection]
in a `describe`, `context` or `scenario`.

```ruby
RSpec.describe 'Cities', test_helpers: [:cities] do
# or
scenario 'submit the form', helpers: [:form, :users] do
```

#### Global Injection

You can [`use_test_helpers`][rspec_global_injection] in an RSpec helper module to make them available globally.

```ruby
module GlobalTestHelpers
  extend ActiveSupport::Concern

  included do
    use_test_helpers(:current_page, :routes)
  end
end

RSpec.configure do |config|
  # Make the default helpers available in all feature or system tests.
  config.include(GlobalTestHelpers, type: :feature)
  config.include(GlobalTestHelpers, type: :system)
end
```

### In Cucumber

When using Cucumber, you may call [`use_test_helpers`][cucumber_injection] in the step definitions.

```ruby
# features/step_definitions/city_steps.rb
use_test_helpers(:cities, :form, :modal)
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
