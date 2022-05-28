[capybara]: https://github.com/teamcapybara/capybara
[cucumber]: https://github.com/cucumber/cucumber-ruby
[rspec]: https://github.com/rspec/rspec
[rspec-rails]: https://github.com/rspec/rspec-rails#installation
[rails_integration]: https://github.com/ElMassimo/capybara_test_helpers/commit/c512e39987215e30227dad45e775480bc1348325
[cucumber_integration]: https://github.com/ElMassimo/capybara_test_helpers/commit/68e20cb40ba409c50f88f8b745eb908fb067a0aa
[using test helpers in Cucumber]: /guide/cucumber/
[use test helpers in RSpec]: /guide/essentials/injection

# Installation 💿

Add this line to your application's Gemfile:

```ruby
gem 'capybara_test_helpers'
```

And then run:

    $ bundle install

## RSpec

To use with [RSpec], require the following in `spec_helper.rb`:

```ruby
require 'capybara_test_helpers/rspec'
```

Most of the examples in the guide will cover how to [use test helpers in RSpec].

### In Rails

If using Rails, make sure you [follow the setup in `rspec-rails`][rspec-rails] first.

You can run `rails g test_helper base` to create a base test helper and require
it as well so that other test helpers can extend it without manually requiring.

```ruby
# spec/rails_helper.rb
require 'capybara_test_helpers/rspec'
require Rails.root.join('test_helpers/base_test_helper')
```

[Example][rails_integration]

## Cucumber 🥒

To use with [Cucumber], require the following in `env.rb`:

```ruby
require 'capybara_test_helpers/cucumber'
require Rails.root.join('test_helpers/base_test_helper')
```

[Example][cucumber_integration]

Read about [using test helpers in Cucumber] for more information.
