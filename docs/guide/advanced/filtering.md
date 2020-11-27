[adding a filter]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/spec/support/global_filters.rb#L10-L19
[finders]: /guide/essentials/finders
[api]: /api/#finders
[capybara selectors]: https://www.rubydoc.info/github/teamcapybara/capybara/Capybara/Selector
[wrapping]: /api/#wrap-element

# Filtering with Blocks 🌪️

If you need to restrict the [found elements][finders] based on additional checks on the elements, you can do so by passing a __filter block__ to any of the [finders][api].

The filter block will be invoked once per found element, and should return a _truthy_ value if the element meets the condition, or _falsy_ to discard it from the results.

Elements passed to the block are [wrapped][wrapping], so you can call any of the test helper methods.

```ruby
class UsersTestHelper < BaseTestHelper
  def admin?
    has_content?('Admin')
  end

  def find_admin(name)
    find('tr.user', text: name) { |user_row| user_row.admin? }
  end
end
```
```ruby
users.find_admin('John')

# same as

find('tr.user', text: 'John') { |row| row.has_content?('Admin') }

# similar but with more guarantees around ambiguity than

find_all('tr.user', text: 'John').select { |row| row.has_content?('Admin') }.first
```

Filter blocks provide a huge amount of flexibility, and can be an elegant solution in certain scenarios.

Depending on the type of checks you perform in the block, you might be better off adding a [custom selector][capybara selectors], or [adding a filter to an existing selector][adding a filter], which you can then easily reuse.
