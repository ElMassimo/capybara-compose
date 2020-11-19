# Selectors 🔍

You can encapsulate locators for commonly used elements to avoid hardcoding them
in different tests.

As a result, if the UI changes there are less places that need to be updated in
the tests 😃

```ruby
class FormTestHelper < BaseTestHelper
  SELECTORS = {
    el: '.form',
    error_summary: ['#error_explanation', visible: true],
    name_input: [:fillable_field, 'Name'],
    save_button: [:button, type: 'submit'],
  }
end
```

You can then leverage these aliases on any Capybara method:

```ruby
# Finding an element
form.find(:save_button, visible: false)

# Interacting with an element
form.fill_in(:name_input, with: 'Jane')

# Making an assertion
form.has_selector?(:error_summary, text: "Can't be blank")
```

## Getters

To avoid repetition, getters are available for every selector alias:

```ruby
form.find(:name_input)
# same as
form.name_input

form.find(:error_summary, text: "Can't be blank")
# same as
form.error_summary(text: "Can't be blank")
```

## `:el` convention

By convention, `:el` is the top-level element of the component or page the test
helper is encapsulating, which will be used automatically when calling a
Capybara operation that requires a node, such as `click` or `value`.

```ruby
form.within { save_button.click }
# same as
form.within(:el) { save_button.click }
# same as
form.el.within { save_button.click }
```

This is convenient when using test helpers to encapsulate components:


```ruby
class DropdownTestHelper < BaseTestHelper
  SELECTORS = {
    el: '.dropdown',
    toggle: '.dropdown-toggle',
  }

  def toggle_menu
    within { toggle.click }
  end
end

dropdown.toggle_menu
```

## Capybara Built-in Selectors

All built-in selectors in Capybara can be used in the aliases, though you may
omit it when using the default selector (usually `css`, but sometimes `xpath`).

```ruby
class ExampleTestHelper < BaseTestHelper
  SELECTORS = {
    popover_toggle: '.popover .popover-toggle',
    parent: [:xpath, '../..'],
    city_input: [:field, 'City', readonly: false],
    back_button: [:link_or_button, 'Go Back'],
    contact_info: [:fieldset, legend: 'Contact Information'] ,
  }
end
```

When using a selector alias with additional options they will be merged:

```ruby
example.city_input(with: 'Montevideo')
# same as
example.find(:field, 'City', readonly: false, with: 'Montevideo')
```

## Nested Selectors

When using `css` or `xpath`, you can reference other aliases in the test helper,
and they will be joined together.

```ruby
class ContainerTestHelper < BaseTestHelper
  SELECTORS = {
    el: '.container',
    wide: [:el, '.wide'],
    column: [:el, ' .column'],
    sibling: [:el, ' + ', :el],
  }
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

