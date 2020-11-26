## Capybara Test Helpers 1.0.4 (2020-11-26) ##

* Add `have_no` alias for `have_no_selector`.
* Add `has_no?` alias for `has_no_selector?`.
* Remove internal method `wrap_test_helper`.
* Allow to use locator aliases in `assert_` methods as well, for consistency.

## Capybara Test Helpers 1.0.3 (2020-11-24) ##

* Add `CapybaraTestHelpers::BenchmarkHelpers`

## Capybara Test Helpers 1.0.2 (2020-11-23) ##

*   Add `aliases` DSL to define `SELECTORS`.

## Capybara Test Helpers 1.0.1 (2020-11-19) ##

*   Add `has?` alias for `has_selector?`.
*   Delegate `have` to the RSpec collection matcher when passing an Integer.

## Capybara Test Helpers 1.0.0 (2020-11-17) ##

*   Initial Release.
