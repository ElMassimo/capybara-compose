[el convention]: /guide/essentials/current-context.html#current-element
[actions]: /guide/essentials/actions
[finders]: /guide/essentials/finders
[assertions]: /guide/essentials/assertions
[matchers]: /guide/essentials/querying
[capybara selectors]: https://www.rubydoc.info/github/teamcapybara/capybara/Capybara/Selector
[trailing_commas]: https://maximomussini.com/posts/trailing-commas/

# Locator Aliases 🔍

You can encapsulate locators for commonly used elements by defining `aliases`.

These aliases can then be used on any of the [actions], [finders], [matchers], or [assertions].

As a result, when the UI changes it will be significantly easier to update the tests, because selectors and labels are not hardcoded all over the place 😃

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

In a [next section][el convention] we will learn about how `:el` plays a special role.

## Aliases Shortcuts

To avoid repetition and to keep things concise, getters are available for every defined alias.

```ruby
form.name_input
# same as
form.find(:fillable_field, 'Name')
```

You may provide options to the getter, which will be merged with any options defined in the alias.

```ruby
form.error_summary(text: "Can't be blank")
# same as
form.find('#error_explanation', visible: true, text: "Can't be blank")
```

## Capybara Selectors

All [selectors][capybara selectors] defined in Capybara can be used in the aliases, including any custom ones you define.

You can omit the selector when using the default one, which is [usually `css`](https://github.com/teamcapybara/capybara#xpath-css-and-selectors).

```ruby
class FormTestHelper < BaseTestHelper
  aliases(
    el: 'form',
    city_input: [:field, 'City', readonly: false],
    save_button: [:link_or_button, 'Save'],
    contact_info: [:fieldset, legend: 'Contact Information'] ,
    parent: [:xpath, '../..'],
  )
end
```
```ruby
form.within(:contact_info) {
  form.city_input.fill_in('Montevideo')
  form.click_on(:save_button)
}
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

Writing one alias per line and [always using a trailing comma][trailing_commas] is highly recommended.

```ruby
class DropdownTestHelper < BaseTestHelper
  aliases(
    el: '.dropdown',
    toggle: '.dropdown-toggle',
  )
end
```

It will minimize the amount of git conflicts, and keep the history a lot cleaner and more meaningful when using `git blame`.
