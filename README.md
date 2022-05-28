[docs]: https://capybara-test-helpers.netlify.app/
[guide]: https://capybara-test-helpers.netlify.app/guide/
[api]: https://capybara-test-helpers.netlify.app/api/
[design patterns]: https://capybara-test-helpers.netlify.app/guide/advanced/design-patterns
[installation]: https://capybara-test-helpers.netlify.app/guide/installation
[capybara]: https://github.com/teamcapybara/capybara
[cucumber]: https://github.com/cucumber/cucumber-ruby
[current context]: https://capybara-test-helpers.netlify.app/guide/essentials/current-context
[rspec]: https://github.com/rspec/rspec
[aliases]: https://capybara-test-helpers.netlify.app/guide/essentials/aliases
[assertions]: https://capybara-test-helpers.netlify.app/guide/essentials/assertions
[synchronization]: https://capybara-test-helpers.netlify.app/guide/advanced/synchronization

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

[__Capybara Test Helpers__](https://github.com/ElMassimo/capybara_test_helpers) allows you to easily encapsulate logic in your integration tests.

Write tests that everyone can understand, and leverage your Ruby skills to keep them __easy to read and easy to change__.

## Features ⚡️

[Locator Aliases][aliases] work with every [Capybara] method, allowing you to encapsulate CSS selectors and labels, and avoid coupling tests with the implementation.

The [entire Capybara DSL is available][api], and element results are [wrapped automatically][current context] so that you can chain your own assertions and actions fluently.

A [powerful syntax for assertions][assertions] and convenient primitives for [synchronization] enable you to write async-aware expectations: say goodbye to flaky tests.

## Documentation 📖

Visit the [documentation website][docs] to check out the [guides][guide], searchable [__API reference__][api], and examples.

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

## Quick Tour 🛣

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

- [capybara]: Excellent library to write integration tests in Ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
