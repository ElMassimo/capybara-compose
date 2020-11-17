<h1 align="center">
Capybara Test Helpers
<p align="center">
<a href="https://github.com/ElMassimo/capybara_test_helpers/actions"><img alt="Build Status" src="https://github.com/ElMassimo/capybara_test_helpers/workflows/build/badge.svg"/></a>
<a href="https://inch-ci.org/github/ElMassimo/capybara_test_helpers"><img alt="Inline docs" src="https://inch-ci.org/github/ElMassimo/capybara_test_helpers.svg"/></a>
<a href="https://codeclimate.com/github/ElMassimo/capybara_test_helpers"><img alt="Maintainability" src="https://codeclimate.com/github/ElMassimo/capybara_test_helpers/badges/gpa.svg"/></a>
<a href="https://codeclimate.com/github/ElMassimo/capybara_test_helpers"><img alt="Test Coverage" src="https://codeclimate.com/github/ElMassimo/capybara_test_helpers/badges/coverage.svg"/></a>
<a href="https://rubygems.org/gems/capybara_test_helpers"><img alt="Gem Version" src="https://img.shields.io/gem/v/capybara_test_helpers.svg?colorB=e9573f"/></a>
<a href="https://github.com/ElMassimo/capybara_test_helpers/blob/master/LICENSE.txt"><img alt="License" src="https://img.shields.io/badge/license-MIT-428F7E.svg"/></a>
</p>
</h1>

[__Capybara Test Helpers__](https://github.com/ElMassimo/capybara_test_helpers) is
an opinionated library built on top of [capybara], that encourages good testing
practices based on encapsulation and reuse.

Write tests that everyone can understand, and leverage your Ruby skills to keep them __easy to read and easy to change__.

[capybara]: https://github.com/teamcapybara/capybara
[capybara dsl]: https://github.com/teamcapybara/capybara#the-dsl
[capybara querying]: https://github.com/teamcapybara/capybara#querying
[cucumber]: https://github.com/cucumber/cucumber-ruby
[rspec]: https://github.com/rspec/rspec
[rspec matchers]: https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers
[rspec-rails]: https://github.com/rspec/rspec-rails#installation
[trailing_commas]: https://maximomussini.com/posts/trailing-commas/
[testing_robots]: https://jakewharton.com/testing-robots/
[page_objects]: https://martinfowler.com/bliki/PageObject.html
[rspec_injection]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/examples/rails_app/spec/system/cities_spec.rb#L7
[rspec_global_injection]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/examples/rails_app/spec/support/default_test_helpers.rb#L8
[cucumber_injection]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/examples/rails_app/features/step_definitions/city_steps.rb#L3
[example app]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/examples/rails_app
[capybara_test_helpers_tests]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/spec
[positive and negative assertions]: https://maximomussini.com/posts/cucumber-to_or_not_to/
[should]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/lib/capybara_test_helpers/assertions.rb#L10-L15
[should_not]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/lib/capybara_test_helpers/assertions.rb#L17-L22
[rails_integration]: https://github.com/ElMassimo/capybara_test_helpers/commit/c512e39987215e30227dad45e775480bc1348325
[cucumber_integration]: https://github.com/ElMassimo/capybara_test_helpers/commit/68e20cb40ba409c50f88f8b745eb908fb067a0aa

## Why? 🤔

[`capybara`][capybara] is a great library for integration tests in Ruby,
commonly used in combination with [RSpec] or [cucumber].

Although [cucumber] encourages good practices such as writing steps at a high
level, thinking in terms of the user rather than the interactions required, it
__doesn't scale well__ in a large project. Steps are available for all tests,
and there's no way to partition or isolate them.

At the same time, Gherkin is very limited as a language, it can be very awkward
to use when steps require parameters, and it's hard to find and detect duplicate
steps, and very __time consuming__ to refactor them.

In contrast, writing tests in [RSpec] has a very low barrier since Ruby is a joy
to work with, but you are on your own to encapsulate code to avoid coupling
tests to the current UI. Small changes to the UI should not require rewriting
dozens of tests, but __without clear guidelines__ it's hard to achieve good tests.

This library provides __a solid foundation__ of simple and repeatable patterns
that can be used to write better tests.

## Features ⚡️

- Leverage your __Ruby__ skills for keeping tests in good shape
- Powerful syntax for __assertions__ (without monkey patching)
- __Aliases__ for element locators to avoid repetition
- __Composability__: define interactions with your UI once, and [focus on the tests][testing robots] many times
- Dependency injection to make tests __predictable and robust__
- Full access to the __[Capybara DSL]__

## Installation 💿

Add this line to your application's Gemfile:

```ruby
gem 'capybara_test_helpers'
```

And then run:

    $ bundle install

### RSpec

To use with [RSpec], require the following in `spec_helper.rb`:

```ruby
require 'capybara_test_helpers/rspec'
```

#### In Rails

If using Rails, make sure you [follow the setup in `rspec-rails`][rspec-rails] first.

You can run `rails g test_helper base` to create a base test helper and require
it as well so that other test helpers can extend it without manually requiring.

```ruby
# spec/rails_helper.rb
require 'capybara_test_helpers/rspec'
require Rails.root.join('test_helpers/base_test_helper')
```

[Check this example][rails_integration] to see how you can get started.

### Cucumber

To use with [Cucumber], require the following in `env.rb`:

```ruby
require 'capybara_test_helpers/cucumber'
require Rails.root.join('test_helpers/base_test_helper')
```

Have in mind that RSpec is a much better fit, as Gherkin is very limited.

That said, test helpers do provide [a nice way to share code](https://github.com/ElMassimo/capybara_test_helpers/blob/master/examples/rails_app/features/step_definitions/city_steps.rb) if you are migrating
from Cucumber to RSpec.

[Check this example][cucumber_integration] to see how you can get started.

## Usage 🚀

You can define a test helper by subclassing `Capybara::TestHelper`, which has
full access to the Capybara DSL.

```ruby
class UsersTestHelper < Capybara::TestHelper
# Selectors: Semantic aliases for elements, a useful abstraction.
  SELECTORS = {
    el: 'table.users',
    form: '.user-form',
    submit_button: [:button, type: 'submit'],
  }

# Getters: A convenient way to get related data or nested elements.
  def row_for(user)
    within { find(:table_row, { 'Name' => user.name }) }
  end

# Actions: Encapsulate complex actions to provide a cleaner interface.
  def add(attrs)
    click_on('Add User')
    save_user(**attrs)
  end

  def edit(user, with:)
    row_for(user).click_on('Edit')
    save_user(**with)
  end

  def delete(user)
    accept_confirm { row_for(user).click_on('Delete') }
  end

  private \
  def save_user(name:, language:)
    within(:form) {
      fill_in('Name', with: name)
      choose('Language', option: language)
      submit_button.click
    }
  end

# Assertions: Allow to check on element properties while keeping it DRY.
  def have_user(name:, language:)
    columns = { 'Name' => name, 'Language' => language }
    within { have(:table_row, columns) }
  end
end
```

When using Rails, you can generate a test helper by running:

    $ rails g test_helper users

### Writing a Test with Helpers ✅

You can find [this working example](https://github.com/ElMassimo/capybara_test_helpers/blob/master/examples/rails_app/spec/system/cities_spec.rb) and more in the [example app] and the [Capybara tests][capybara_test_helpers_tests].

```ruby
require 'rails_helper'

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

To make the test helper available you can use the [`test_helpers` option][rspec_injection]
in a `describe`, `context` or `scenario` as seen above.

When using Cucumber, you may call [`use_test_helpers`][cucumber_injection] in the step definitions.

Finally, for test helpers that you expect to use very often, you can [`use_test_helpers`][rspec_global_injection] in an RSpec helper module to make them available globally.

## DSL 🛠

A documentation website with the full API and examples is coming soon :shipit:

Every single method in the [Capybara DSL] is available inside test helpers, as
well as the [built-in RSpec matchers][rspec matchers].

### Selectors 🔍

You can encapsulate locators for commonly used elements to avoid hardcoding them
in different tests.

As a result, if the implementation changes, there are less places that need to
be updated, making it faster to update tests after UI changes.

```ruby
class FormTestHelper < BaseTestHelper
  SELECTORS = {
    el: '.form',
    error_summary: ['#error_explanation', visible: true],
    name_input: [:fillable_field, 'Name'],
    save_button: [:button, type: 'submit'],
  }
```

You can then leverage these aliases on any Capybara method:

```ruby
# Finding an element
form.find(:save_button, visible: false)

# Interacting with an element
form.fill_in(:name_input, with: 'Jane')

# Making an assertion
form.has_selector?(:error_summary, text: "Can't be blank")
```

#### Syntax Sugar

To avoid repetition, getters are available for every selector alias:

```ruby
form.find(:name_input)
# same as
form.name_input

form.find(:error_summary, text: "Can't be blank")
# same as
form.error_summary(text: "Can't be blank")
```

#### `:el` convention

By convention, `:el` is the top-level element of the component or page the test
helper is encapsulating, which will be used automatically when calling a
Capybara operation that requires a node, such as `click` or `value`.

```ruby
form.within { save_button.click }
# same as
form.within(:el) { save_button.click }
# same as
form.el.within { save_button.click }
```

### Assertions ☑️

You can use any of the [RSpec matchers provided by Capybara][capybara querying],
but the way to use them in test helpers is slightly different.

Before using an assertion, you must call [`should`][should] or [`should_not`][should_not], and then
chain the RSpec matcher or your own custom assertion.

```ruby
users.find(:table)
  .should.have_selector(:table_row, ['Jane', 'Doe']
  .should_not.have_selector(:table_row, ['John', 'Doe'])
```

#### Custom Assertions 🎩

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

Notice that you don't need to define both the [positive and negative assertions],
they are both available because we are using an existing assertion.

#### Advanced Assertions ⚙️

Sometimes built-in assertions are not enough, and you need to use an expectation
directly. Test helpers provide [`to_or` and `not_to` methods][positive and negative assertions] that you
can use to implement an assertion that you can use with `should` or `should_not`.

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

You can make the assertion retry automatically until the Capybara timeout by
using `synchronize_expectation`:

```ruby
  def be_fullscreen
    synchronize_expectation {
      expect(fullscreen?).to_or not_to, eq(true)
    }
  end
```

## Design 📐

This library is loosely based on the concepts of [Page Objects][page_objects] and [Testing Robots][testing_robots], with a healthy dose of [dependency injection](https://martinfowler.com/articles/injection.html).

Capybara has a great DSL, so the focus of this library is to build upon it, by
allowing you to create your own actions and assertions and call them just as
fluidly as you would call `find` or `has_content?`.

This library works best when encapsulating common UI patterns in separate helpers,
such as a `FormTestHelper` or a `DropdownTestHelper`, and then reusing them in
page-specific test helpers to make the test read more semantically.

## Formatting 📏

Regarding selectors, I highly recommend writing one attribute per line, sorting
them alphabetically (most editors can do it for you), and
[always using a trailing comma][trailing_commas].

```ruby
class DropdownTestHelper < BaseTestHelper
# Selectors: Semantic aliases for elements, a useful abstraction.
  SELECTORS = {
    el: '.dropdown',
    toggle: '.dropdown-toggle',
  }
```

It will minimize the amount of git conflicts, and keep the history a lot cleaner and more meaningful when using `git blame`.

## Special Thanks 🙏

This library wouldn't be the same without the early validation from my colleagues, and numerous improvements and bugfixes they contributed to it. Thanks for the support 😃

- [capybara]: Solid library to write integration tests in Ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
