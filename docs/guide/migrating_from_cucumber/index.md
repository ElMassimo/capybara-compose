# Migrating to RSpec from Cucumber

Test helpers can be helpful by providing [a nice way to share code](https://github.com/ElMassimo/capybara_test_helpers/blob/master/examples/rails_app/features/step_definitions/city_steps.rb) if you are migrating
from Cucumber to RSpec.

By extracting code from Cucumber steps into test helpers, you can make the transition more gradually, and ensure it's performing the same actions.

```ruby
use_test_helpers(:cities)

When('I edit the {string} city with:') do |name, table|
  cities.edit(name, with: table.rows_hash.symbolize_keys)
end

When('I delete the {string} city') do |name|
  cities.delete(name)
end

Then(/^there should( not)? be an? "(.+?)" city$/) do |or_should_not, name|
  cities.should(or_should_not).have_city(name)
end
```

More examples coming soon.
