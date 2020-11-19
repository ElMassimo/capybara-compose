[testing_robots]: https://jakewharton.com/testing-robots/
[page_objects]: https://martinfowler.com/bliki/PageObject.html

# Design Patterns 📐

This library is loosely based on the concepts of [Page Objects][page_objects] and [Testing Robots][testing_robots], with a healthy dose of [dependency injection](https://martinfowler.com/articles/injection.html).

Capybara has a great DSL, so the focus of this library is to build upon it, by
allowing you to create your own actions and assertions and call them just as
fluidly as you would call `find` or `has_content?`.

This library works best when encapsulating common UI patterns in separate helpers,
such as a `FormTestHelper` or a `DropdownTestHelper`, and then reusing them in
page-specific test helpers to make the test read more semantically.

__Coming Soon__
