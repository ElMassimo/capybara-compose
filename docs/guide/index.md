[capybara]: https://github.com/teamcapybara/capybara
[capybara dsl]: https://github.com/teamcapybara/capybara#the-dsl
[rspec_injection]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/examples/rails_app/spec/system/cities_spec.rb#L7
[rspec_global_injection]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/examples/rails_app/spec/system/support/default_test_helpers.rb#L8
[cucumber_injection]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/examples/rails_app/features/step_definitions/city_steps.rb#L3
[example app]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/examples/rails_app
[capybara_test_helpers_tests]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/spec
[rspec matchers]: https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
[actions]: /guide/essentials/actions
[api]: /api/

# Getting Started 🚀

If you have used [Capybara] before, using Capybara Test Helpers should feel very natural.

Every single method in the [Capybara DSL] is available in test helpers, check the [API Reference][api].

The advantage is that when we add test helpers to the mix, it becomes easier to
encapsulate and modularize the interactions with different pages or UI components.

## A Small Example 🌆

Let's say we have a list of cities, and we want to test the _Edit_ functionality.

We can create an RSpec feature or system test to make sure things are working as expected.

```ruby
RSpec.feature 'Cities', test_helpers: [:cities] do
  let!(:nyc) { cities.given_there_is_a_city('NYC') }

  before { visit(cities_path) }

  scenario 'editing a city' do
    cities.edit('NYC', with: { name: 'New York City' })
    cities.should_no_longer.have_city('NYC')
    cities.should_now.have_city('New York City')
  end
end
```

<details>
  <summary>See this test <b>without</b> test helpers</summary>

```ruby
RSpec.describe 'Cities' do
  let!(:nyc) { City.create!(name: 'NYC') }

  before { visit(cities_path) }

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
end
```
</details>

Now that we have a test with a clear intent, let's create a test helper to perform these interactions.

```ruby
class CitiesTestHelper < Capybara::TestHelper
  use_test_helpers(:form)

# Aliases: Semantic aliases for locators, can be used in most DSL methods.
  aliases(
    el: 'table.cities',
  )

# Finders: A convenient way to get related data or nested elements.
  def row_for(name)
    within { find(:table_row, { 'Name' => name }) }
  end

# Actions: Encapsulate complex actions to provide a cleaner interface.
  def edit(name, with:)
    row_for(name).click_on('Edit')
    form.within {
      fill_in 'Name', with: with[:name]
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

Although it might seem overkill for this small example, using a test helper brings the test a lot of clarity, making it easier to understand and to maintain in the future.

The advantages of this approach become apparent when [several](https://github.com/ElMassimo/capybara_test_helpers/blob/master/examples/rails_app/spec/system/cities_spec.rb) scenarios work with the same elements, or when the interactions are complex.

[Read on][actions] to find out more about test helpers.
