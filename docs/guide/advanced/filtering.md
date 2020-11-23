[api]: /api/
[capybara finding]: https://github.com/teamcapybara/capybara#finding
[selectors]: /guide/essentials/aliases
[actions]: /guide/essentials/actions
[assertions]: /guide/essentials/assertions
[to_capybara_node]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/lib/capybara_test_helpers/test_helper.rb#L56-L58
[adding a filter]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/spec/support/global_filters.rb#L6-L8
[el convention]: /guide/essentials/current-context.html#el-convention
[finders]: /guide/essentials/finders

# Advanced Filtering 🌪️

If you need to restrict the [found elements][finders] based on additional checks on the elements, you can do so by passing a __filter block__, which will be called once per element found.

The filter block should return a _truthy_ value if the element meets the condition, or _falsy_ to discard it from the results.

All methods defined in the test helper are available in the element inside the block.

```ruby
class UsersTestHelper < BaseTestHelper
  def find_user(*name, &filter_block)
    find('table.users').find(:table_row, name, &filter_block)
  end

  def find_admin(name)
    find_user(name) { |user_row| user_row.admin? }
  end

  def admin?
    has_content?('Admin')
  end
end

users.find_admin('John')
# same as
find('table.users').find(:table_row, name) { |user_row| user_row.has_content?('Admin') }
```

If you find yourself needing to use this a lot you may be better off adding a custom selector, or [adding a filter to an existing selector][adding a filter].
