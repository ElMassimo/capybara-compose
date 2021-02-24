[pry-rescue]: https://github.com/ConradIrwin/pry-rescue
[pry-stack-explorer]: https://github.com/pry/pry-stack_explorer

# Debugging 🐞

In order to keep track of the interactions being performed in the test, it can be very convenient to print any test helper methods as they are executed, which can also help to detect slow paths.

You can easily achieve this by adding `Capybara::Compose::BenchmarkHelpers` to your `BaseTestHelper`:

```ruby
require 'capybara/compose/benchmark_helpers' if ENV['CI']

class BaseTestHelper < Capybara::TestHelper
  include Capybara::Compose::BenchmarkHelpers if ENV['CI']
end
```

In the snippet above, we skip the extra output if we are running tests in a continuous integration server.

These helpers need the `rainbow` gem to be installed for nicer output:

```ruby
gem :development, :test do
  gem 'rainbow'
end
```

And the result:

![benchmark_helpers](/images/benchmark_helpers.svg)

## Pausing on Failures 🦸

When running tests locally, it can be really helpful to pause and debug when an assertion or find fails.

[`pry-rescue`][pry-rescue] is excellent for this purpose when running integration tests in RSpec. You can install it by adding the following to your Gemfile:

```ruby
group :development do
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
end
```

and then requiring it in `spec_helper.rb`, `base_test_helper.rb`, or similar:

```ruby
require 'pry-rescue/rspec' unless ENV['CI']
```

Whenever a test fails, it will start an interactive session, allowing you to query the page contents and call any test helper methods:

![benchmark_helpers](/images/pry-rescue.svg)

You can navigate through the stack by running the [`up` and `down` commands][pry-stack-explorer].
