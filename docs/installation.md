[capybara]: https://github.com/teamcapybara/capybara
[cucumber]: https://github.com/cucumber/cucumber-ruby
[rspec]: https://github.com/rspec/rspec
[rspec-rails]: https://github.com/rspec/rspec-rails#installation
[rails_integration]: https://github.com/ElMassimo/capybara_test_helpers/commit/c512e39987215e30227dad45e775480bc1348325
[cucumber_integration]: https://github.com/ElMassimo/capybara_test_helpers/commit/68e20cb40ba409c50f88f8b745eb908fb067a0aa
[migration guide]: /guide/migrating_from_cucumber/

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

### In Rails

If using Rails, make sure you [follow the setup in `rspec-rails`][rspec-rails] first.

You can run `rails g test_helper base` to create a base test helper and require
it as well so that other test helpers can extend it without manually requiring.

```ruby
# spec/rails_helper.rb
require 'capybara_test_helpers/rspec'
require Rails.root.join('test_helpers/base_test_helper')
```

[Check this example][rails_integration] to see how you can get started.

## Cucumber 🥒

To use with [Cucumber], require the following in `env.rb`:

```ruby
require 'capybara_test_helpers/cucumber'
require Rails.root.join('test_helpers/base_test_helper')
```

[Check this example][cucumber_integration] to see how you can get started.

Have in mind that RSpec is a much better fit, as Gherkin is very limited in its expresiveness.

That said, test helpers do provide [a nice way to share code](https://github.com/ElMassimo/capybara_test_helpers/blob/master/examples/rails_app/features/step_definitions/city_steps.rb) if you are migrating
from Cucumber to RSpec. Check out the [migration guide] for more details.

