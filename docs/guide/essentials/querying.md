[api]: /api/#matchers
[retry]: /guide/advanced/synchronization
[aliases]: /guide/essentials/aliases
[actions]: /guide/essentials/actions
[assertions]: /guide/essentials/assertions
[to_capybara_node]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/lib/capybara_test_helpers/test_helper.rb#L56-L58
[wait]: /api/#using-wait-time

# Querying ❔

[Matchers][api] allow you to query the page or an element for the existence of certain elements.

Unlike [assertions], they **do not cause a test to fail**, they instead return a `Boolean` value.

You can check the [API Reference][api] for information.

```ruby
current_page.has_selector?('table tr')
table.has?(:table_row)

form.has_field?('Name')
form.has_button?(type: 'submit', disabled: false)
```

## Custom Queries ❓

Just like with [actions], it's often convenient to create more specific queries to encapsulate a certain check you need to perform.

```ruby
class FormTestHelper < BaseTestHelper
  def can_save?
    has_button?(type: 'submit', disabled: false)
  end
end

form.can_save?
```

## Query Caveats ⚠️

Capybara will [retry] a query until the expected condition is fulfilled, or the [wait time][wait] runs out.

That means that the following are not equivalent (applies to [all matchers][api] and their negated version):

```ruby
has_selector?('a') !== !has_no_selector?('a')
```

- When using `has_selector?`:
  - If the link is found it will return `true` immediately.
  - If the link is not found, it will retry until it appears, or return `false` if it times out.

- When using `has_no_selector?`:
  - If the link is found, it will retry until it disappears, or return `false` if it times out.
  - If the link is not found it will return `false` immediately.

For this reason, it's usually preferrable to use [assertions] instead whenever possible, since they provide simpler [async semantics][retry], as well as better error messages.
