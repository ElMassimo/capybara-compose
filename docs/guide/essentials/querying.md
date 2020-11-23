[api]: /api/
[capybara querying]: https://github.com/teamcapybara/capybara#querying
[matcher caveats]: https://github.com/teamcapybara/capybara#asynchronous-javascript-ajax-and-friends
[selectors]: /guide/essentials/aliases
[actions]: /guide/essentials/actions
[assertions]: /guide/essentials/assertions
[to_capybara_node]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/lib/capybara_test_helpers/test_helper.rb#L56-L58

# Querying ❔

All of the matchers provided by the [Capybara DSL][capybara querying] are available to be used in test helpers.

You can use them to query the page or an element for the existence of certain elements, matchers always return a boolean value.

<!-- You can check the [API Reference][api] for information about the available matchers. -->

```ruby
current_page.has_selector?('table tr')
table.has?(:table_row)

form.has_field?('Name')
form.has_button?(type: 'submit', disabled: true)
```

Have in mind that [matchers have some caveats][matcher caveats], so it's preferable to [use assertions instead][assertions] whenever possible.

## Custom Queries ⚡️

Just like with [actions], it's often convenient to create more specific queries to encapsulate a certain check you need to perform.

```ruby
class TableTestHelper < BaseTestHelper
  def has_row?
    within_table { has?(:table_row) }
  end
end

table.has_row?
# same as
within_table { has_selector?(:table_row) }
```

In practice, [assertions] are used more frequently than matchers, because they provide better error messages, as well as more reliable [async semantics][matcher caveats].
