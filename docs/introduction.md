[library]: https://github.com/ElMassimo/capybara_test_helpers
[capybara]: https://github.com/teamcapybara/capybara
[api]: /api/
[testing_robots]: https://jakewharton.com/testing-robots/
[cucumber]: https://github.com/cucumber/cucumber-ruby
[rspec]: https://github.com/rspec/rspec
[aliases]: /guide/essentials/aliases
[assertions]: /guide/essentials/assertions
[synchronization]: /guide/advanced/synchronization
[injection]: /guide/essentials/injection
[debugging]: /guide/advanced/debugging
[testing_robots]: https://jakewharton.com/testing-robots/
[page_objects]: https://martinfowler.com/bliki/PageObject.html

# Introduction

[__Capybara Test Helpers__][library] is a flexible testing library built on top of [capybara], that encourages good practices based on encapsulation and reuse.

Write integration tests that everyone can understand, and leverage your Ruby skills to keep them __easy to read and easy to change__.

[Get started](/guide/), or check the [API reference](/api/).

## Features ⚡️

[Locator Aliases][aliases] work with every [Capybara] method, allowing you to encapsulate CSS selectors and labels, and avoid coupling tests with the implementation.

The [entire Capybara DSL is available][api], and element results are [wrapped automatically](https://capybara-test-helpers.netlify.app/guide/essentials/current-context) so that you can chain your own assertions and actions fluently.

A [powerful syntax for assertions](https://capybara-test-helpers.netlify.app/guide/essentials/assertions) and convenient primitives for [synchronization](https://capybara-test-helpers.netlify.app/guide/advanced/synchronization) enable you to write async-aware expectations: say goodbye to flaky tests.

Conventions make it easier to provide [great debugging capabilities][debugging].

Finally, since it's plain Ruby, you can leverage your existing skills to modularize code and keep tests in good shape.

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

## Design 📐

This library provides __a solid foundation__ of simple and repeatable patterns
that can be used to write better tests.

Its design is loosely based on the concepts of [Page Objects][page_objects] and [Testing Robots][testing_robots], with a healthy dose of [dependency injection](https://martinfowler.com/articles/injection.html).

Capybara has a great DSL, so the focus of this library is to build upon it, by
allowing you to create your own actions and assertions and call them just as
fluidly as you would call `find` or `has_content?`.

This library works best when encapsulating common UI patterns in separate helpers,
such as a `FormTestHelper` or a `DropdownTestHelper`, and then reusing them in
page-specific test helpers to write higher-level tests that are easier to read and maintain.
