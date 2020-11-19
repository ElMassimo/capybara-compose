[library]: https://github.com/ElMassimo/capybara_test_helpers
[capybara]: https://github.com/teamcapybara/capybara
[capybara dsl]: https://github.com/teamcapybara/capybara#the-dsl
[testing_robots]: https://jakewharton.com/testing-robots/
[cucumber]: https://github.com/cucumber/cucumber-ruby
[rspec]: https://github.com/rspec/rspec

# Introduction

[__Capybara Test Helpers__][library] is
an opinionated library built on top of [capybara], that encourages good testing
practices based on encapsulation and reuse.

Write integration tests that everyone can understand, and leverage your Ruby skills to keep them __easy to read and easy to change__.

## Features ⚡️

- Leverage your __Ruby__ skills for keeping tests in good shape
- Powerful syntax for __assertions__ (without monkey patching)
- __Aliases__ for element locators to avoid repetition
- __Composability__: define interactions with your UI once, and [focus on the tests][testing robots] many times
- Dependency injection to make tests __predictable and robust__
- Full access to the __[Capybara DSL]__

[Get started](/installation/), or check the [API reference](/api/).

## Why 🤔

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
