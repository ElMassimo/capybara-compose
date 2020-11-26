[docs]: https://capybara-test-helpers.netlify.app/
[api]: https://capybara-test-helpers.netlify.app/api/
[design patterns]: https://capybara-test-helpers.netlify.app/guide/advanced/design-patterns
[installation]: https://capybara-test-helpers.netlify.app/installation
[capybara]: https://github.com/teamcapybara/capybara
[capybara querying]: https://github.com/teamcapybara/capybara#querying
[cucumber]: https://github.com/cucumber/cucumber-ruby
[rspec]: https://github.com/rspec/rspec
[rspec matchers]: https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
[rspec-rails]: https://github.com/rspec/rspec-rails#installation
[trailing_commas]: https://maximomussini.com/posts/trailing-commas/
[testing_robots]: https://jakewharton.com/testing-robots/
[page_objects]: https://martinfowler.com/bliki/PageObject.html
[rspec_injection]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/examples/rails_app/spec/system/cities_spec.rb#L7
[rspec_global_injection]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/examples/rails_app/spec/system/support/default_test_helpers.rb#L8
[cucumber_injection]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/examples/rails_app/features/step_definitions/city_steps.rb#L3
[example app]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/examples/rails_app
[capybara_test_helpers_tests]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/spec
[positive and negative assertions]: https://maximomussini.com/posts/cucumber-to_or_not_to/
[should]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/lib/capybara_test_helpers/assertions.rb#L10-L15
[should_not]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/lib/capybara_test_helpers/assertions.rb#L17-L22
[rails_integration]: https://github.com/ElMassimo/capybara_test_helpers/commit/c512e39987215e30227dad45e775480bc1348325
[cucumber_integration]: https://github.com/ElMassimo/capybara_test_helpers/commit/68e20cb40ba409c50f88f8b745eb908fb067a0aa

<h1 align="center">
  Capybara Test Helpers
  <p align="center">
    <a href="https://github.com/ElMassimo/capybara_test_helpers/actions">
      <img alt="Build Status" src="https://github.com/ElMassimo/capybara_test_helpers/workflows/build/badge.svg"/>
    </a>
    <a href="https://codeclimate.com/github/ElMassimo/capybara_test_helpers">
      <img alt="Maintainability" src="https://codeclimate.com/github/ElMassimo/capybara_test_helpers/badges/gpa.svg"/>
    </a>
    <a href="https://codeclimate.com/github/ElMassimo/capybara_test_helpers">
      <img alt="Test Coverage" src="https://codeclimate.com/github/ElMassimo/capybara_test_helpers/badges/coverage.svg"/>
    </a>
    <a href="https://rubygems.org/gems/capybara_test_helpers">
      <img alt="Gem Version" src="https://img.shields.io/gem/v/capybara_test_helpers.svg?colorB=e9573f"/>
    </a>
    <a href="https://github.com/ElMassimo/capybara_test_helpers/blob/master/LICENSE.txt">
      <img alt="License" src="https://img.shields.io/badge/license-MIT-428F7E.svg"/>
    </a>
  </p>
</h1>

[__Capybara Test Helpers__](https://github.com/ElMassimo/capybara_test_helpers) is
an opinionated library built on top of [capybara], that encourages good testing
practices based on encapsulation and reuse.

Write tests that everyone can understand, and leverage your Ruby skills to keep them __easy to read and easy to change__.

## Documentation 📖

[Visit the documentation website][docs] to check out the guides, [API reference][api], and examples.

## Installation 💿

Add this line to your application's Gemfile:

```ruby
gem 'capybara_test_helpers'
```

To use with [RSpec], add the following to your `spec_helper.rb`:

```ruby
require 'capybara_test_helpers/rspec'
```

To use with [Cucumber], add the following to your `support/env.rb`:

```ruby
require 'capybara_test_helpers/cucumber'
```

Additional installation instructions are available in the [documentation website][installation].

## Quick Tour ⚡️

Let's say we have a list of cities, and we want to test the _Edit_ functionality using [Capybara].

```ruby
scenario 'editing a city' do
  visit('/cities')

  within('.cities') {
    find(:table_row, { 'Name' => 'NYC' }).click_on('Edit')
  }
  fill_in 'Name', with: 'New York City'
  click_on('Update City')

  within('.cities') {
    expect(page).not_to have_selector(:table_row, { 'Name' => 'NYC' })
    expect(page).to have_selector(:table_row, { 'Name' => 'New York City' })
  }
end
```

Even though it gets the job done, it takes a while to understand what the test is trying to do.

Without discipline these tests can become __hard to manage__ and require __frequent updating__.

### Using Test Helpers

We can avoid the duplication and keep the [focus on the test][design patterns] instead of its
implementation by using [__test helpers__][docs].

```ruby
scenario 'editing a city', test_helpers: [:cities] do
  cities.visit_page

  cities.edit('NYC', with: { name: 'New York City' })

  cities.should_no_longer.have_city('NYC')
  cities.should_now.have_city('New York City')
end
```

Learn more about it in the [documentation website][docs].

## Special Thanks 🙏

This library wouldn't be the same without early validation from my colleagues, and numerous improvements and bugfixes they contributed to it. Thanks for the support 😃

- [capybara]: Solid library to write integration tests in Ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
