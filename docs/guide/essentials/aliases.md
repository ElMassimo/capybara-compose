[el convention]: /guide/essentials/current-context.html#el-convention
[actions]: /guide/essentials/actions
[finders]: /guide/essentials/finders
[assertions]: /guide/essentials/assertions
[matchers]: /guide/essentials/matchers
[capybara selectors]: https://www.rubydoc.info/github/teamcapybara/capybara/Capybara/Selector
[trailing_commas]: https://maximomussini.com/posts/trailing-commas/

# Locator Aliases 🔍

You can encapsulate locators for commonly used elements to avoid hardcoding them
in different tests.

As a result, if the UI changes there are less places that need to be updated in
the tests 😃

```ruby
class FormTestHelper < BaseTestHelper
  aliases(
    el: '.form',
    error_summary: ['#error_explanation', visible: true],
    name_input: [:fillable_field, 'Name'],
    save_button: [:button, type: 'submit'],
  )
end
```

You can then leverage these aliases on any of the [actions], [finders], [matchers], or [assertions]:

```ruby
# Finding an element
form.find(:save_button, visible: false)

# Interacting with an element
form.fill_in(:name_input, with: 'Jane')

# Making an assertion
form.has_selector?(:error_summary, text: "Can't be blank")

# Scoping interactions or assertions
form.within { form.should.have(:name_input, with: 'Jane') }
```

In the [next section][el convention] we will learn about how `:el` plays a special role.

## Getters

To avoid repetition, getters are available for every defined alias:

```ruby
form.name_input
# same as
form.find(:name_input)

form.error_summary(text: "Can't be blank")
# same as
form.find(:error_summary, text: "Can't be blank")
```

## Capybara Selectors

All [built-in selectors][capybara selectors] in Capybara can be used in the aliases.

You can omit the selector when using the default one, which is usually `css` but [can be changed](https://github.com/teamcapybara/capybara#xpath-css-and-selectors).

```ruby
class ExampleTestHelper < BaseTestHelper
  aliases(
    popover_toggle: '.popover .popover-toggle',
    parent: [:xpath, '../..'],
    city_input: [:field, 'City', readonly: false],
    back_button: [:link_or_button, 'Go Back'],
    contact_info: [:fieldset, legend: 'Contact Information'] ,
  )
end
```

When passing options to an alias, any keyword arguments will be merged:

```ruby
example.city_input(with: 'Montevideo')
# same as
example.find(:field, 'City', readonly: false, with: 'Montevideo')
```

## Nested Aliases

When using `css` or `xpath`, you can reference other aliases in the test helper,
and they will be joined together.

```ruby
class ContainerTestHelper < BaseTestHelper
  aliases(
    el: '.container',
    wide: [:el, '.wide'],
    column: [:el, ' .column'],
    sibling: [:el, ' + ', :el],
  )
end

container.wide
# same as
find('.container.wide')

container.has?(:column)
# same as
has_selector?('.container .column')

container.should.have(:sibling)
# same as
expect(page).to have_selector('.container + .container')
```

## Formatting 📏

It's highly recommend to write one alias per line, sorting them alphabetically (most editors can do it for you), and
[always using a trailing comma][trailing_commas].

```ruby
class DropdownTestHelper < BaseTestHelper
  aliases(
    el: '.dropdown',
    toggle: '.dropdown-toggle',
  )
end
```

It will minimize the amount of git conflicts, and keep the history a lot cleaner and more meaningful when using `git blame`.
