---
sidebar: auto
---
[capybara]: https://github.com/teamcapybara/capybara
[capybara selectors]: https://www.rubydoc.info/github/teamcapybara/capybara/Capybara/Selector
[api_finders]: /api/#finders
[api_actions]: /api/#actions
[filters]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/spec/support/global_filters.rb#L10-L19
[test_id]: https://github.com/ElMassimo/capybara_test_helpers/blob/master/spec/support/global_filters.rb#L6-L8

# Capybara Selectors

Selectors are common strategies to locate elements in the page, provided by [capybara].

They are typically used when using [finders][api_finders], and certain [actions][api_actions].

Additional filters can be provided as keyword arguments, check each selector for more information.

::: tip
You can define your own [selectors][capybara selectors], or add your own [filters] to existing selectors.
:::

## Global Filters

They can be used with any of the built-in selectors.

- `:id {String | Regexp}`: matches the id attribute
- `:class {String | Array | Regexp}`: matches the class(es) provided
- `:style {String | Regexp | Hash}`: match on elements style
- `:above {Element}`: match elements above the passed element on the page
- `:below {Element}`: match elements below the passed element on the page
- `:left_of {Element}`: match elements left of the passed element on the page
- `:right_of {Element}`: match elements right of the passed element on the page
- `:near {Element}`: match elements near (within 50px) the passed element on the page

## `:css` (default)

Locates elements using a CSS selector.

- **Locator**: a CSS selector.

- **Example**:
  ```ruby
  find(:css, 'a.link, button')
  find('#main .container')
  ```

## `:button`

Locates buttons or inputs (with type `submit`, `reset`, `image`, or `button`).

- **Locator**: id, [test_id][test_id], name, value, title, text content, or image alt

- **Filters**:
  - `:name {String | Regexp}`: matches the name attribute
  - `:title {String}`: matches the title attribute
  - `:value {String}`: matches the value of an input button
  - `:type {String}`: matches the type attribute
  - `:disabled {Boolean | :all}`: whether to match disabled buttons, defaults to `false`

- **Example**:
  ```ruby
  click_button('Save')
  find(:button, type: 'submit')
  ```

## `:link`

Locates `a` elements with an `href` attribute.

- **Locator**: id, [test_id][test_id], title, text content, or image alt

- **Filters**:
  - `:title {String}`: matches the title attribute
  - `:alt {String}`: matches the alt attribute of a contained img element
  - `:href {String | Regexp | nil | false}`: matches the normalized href of the link
    - `nil` will find elements with no `href` attribute
    - `false` ignores whether the `href` is present

- **Example**:
  ```ruby
  all(:link, href: nil)
  click_link('Go to checkout')
  find_link(title: 'Add User')
  ```

## `:link_or_button`

Locates links or buttons.

- **Locator**: see [`:link`](#link) and [`:button`](#button) selectors

- **Example**:
  ```ruby
  click_on('Save')
  find(:link_or_button, 'go-back')
  ```

## `:checkbox`

Locates checkboxes.

- **Locator**: id, [test_id][test_id], name, or associated label text

- **Filters**:
  - `:name {String | Regexp}`: matches the name attribute
  - `:checked {Boolean}`: whether to match checked fields
  - `:unchecked {Boolean}`: whether to match unchecked fields
  - `:disabled {Boolean | :all}`: whether to match disabled fields, defaults to `false`
  - `:option {String | Regexp}`: matches the current value
  - `:with`: same as `:option`

- **Example**:
  ```ruby
  check('Yes')
  find(:checkbox, 'user[languages]', checked: true, visible: :hidden)
  ```

## `:field`

Locates `input`, `textarea`, and `select` elements.

Inputs of type `submit`, `image`, and `hidden` are ignored.

- **Locator**: id, [test_id][test_id], name, placeholder, or associated label text

- **Filters**:
  - `:name {String | Regexp}`: matches the name attribute
  - `:placeholder {String | Regexp}`: matches the placeholder attribute
  - `:type {String}`: matches the type attribute of the field or tag name
  - `:readonly {Boolean}`: match on the element being readonly
  - `:with {String | Regexp}`: matches the current value of the field
  - `:checked {Boolean}`: whether to match checked fields
  - `:unchecked {Boolean}`: whether to match unchecked fields
  - `:disabled {Boolean | :all}`: whether to match disabled fields, `false` by default
  - `:multiple {Boolean}`: match fields that accept multiple values
  - `:valid {Boolean}`: match fields that are valid/invalid according to HTML5 form validation
  - `:validation_message {String | Regexp}`: matches the elements current validationMessage

- **Example**:
  ```ruby
  find(:field, 'First Name')
  find_field(type: 'file', disabled: true)
  has_checked_field?('Terms and Conditions')
  ```

## `:file_field`

Locates file `input` elements.

- **Locator**: id, [test_id][test_id], name, or associated label text

- **Filters**:
  - `:name {String | Regexp}`: matches the name attribute
  - `:disabled {Boolean | :all}`: whether to match disabled fields, defaults to `false`
  - `:multiple {Boolean}`: match field that accepts multiple values

- **Example**:
  ```ruby
  all(:xpath, `.//option[@selected]`)
  ```

## `:fillable_field`

Locates an `input` or `textarea` that can be filled with text.

Inputs of type `submit`, `image`, `radio`, `checkbox`, `hidden`, and `file` are ignored.

- **Locator**: id, [test_id][test_id], name, placeholder, or associated label text

- **Filters**:
  - `:name {String | Regexp}`: matches the name attribute
  - `:placeholder {String | Regexp}`: matches the placeholder attribute
  - `:with {String | Regexp}`: matches the current value of the field
  - `:type {String}`: matches the type attribute of the field or element type for 'textarea'
  - `:disabled {Boolean | :all}`: whether to match disabled fields, defaults to `false`
  - `:multiple {Boolean}`: match fields that accept multiple values
  - `:valid {Boolean}`: match fields that are valid/invalid according to HTML5 form validation
  - `:validation_message {String | Regexp}`: matches the elements current validationMessage

- **Example**:
  ```ruby
  fill_in(currently_with: 'address@example.com', with: 'different@example.com')
  find(:fillable_field, 'Phone', type: 'phone')
  ```

## `:radio_button`

Locates radio buttons.

- **Locator**: id, [test_id][test_id], name, or associated label text

- **Filters**:
  - `:name {String | Regexp}`: matches the name attribute
  - `:checked {Boolean}`: whether to match checked fields
  - `:unchecked {Boolean}`: whether to match unchecked fields
  - `:disabled {Boolean | :all}`: whether to match disabled field, defaults to `false`
  - `:option {String | Regexp}`: matches the current value
  - `:with`: same as `:option`

- **Example**:
  ```ruby
  choose('Pizza')
  find(:radio_button, 'food_preference', with: 'Pizza')
  ```

## `:select`

Locates `select` elements.

- **Locator**: id, [test_id][test_id], name, placeholder, or associated label text

- **Filters**:
  - `:name {String | Regexp}`: matches the name attribute
  - `:placeholder {String | Placeholder}`: matches the placeholder attribute
  - `:disabled {Boolean | :all}`: whether to match disabled fields, defaults to `false`
  - `:multiple {Boolean}`: match fields that accept multiple values
  - `:options {Array}`: matches the options exactly
  - `:enabled_options {Array}`: matches the enabled options exactly
  - `:disabled_options {Array}`: matches the disabled options exactly
  - `:with_options {Array}`: matches the options (others may exist)
  - `:selected {String | Array}`: match the selection(s) exactly
  - `:with_selected {String | Array}`: match the selection(s) (others may be selected)

- **Example**:
  ```ruby
  find(:select, 'Language', selected: ['English', 'German'])
  has_select?('Locale', with_options: ['Uruguayan'])
  select('Mercedes', from: 'manufacturer')
  ```

## `:datalist_input`

Locates `input` fields with datalist completion.

- **Locator**: id, [test_id][test_id], name, placeholder, or associated label text

- **Filters**:
  - `:name {String | Regexp}`: matches the name attribute
  - `:placeholder {String | Regexp}`: matches the placeholder attribute
  - `:disabled {Boolean | :all}`: whether to match disabled fields, defaults to `false`
  - `:options {Array}`: matches the options exactly
  - `:with_options {Array}`: matches the options (others may exist)

- **Example**:
  ```ruby
  form.should.have_selector(:datalist_input, with_options: %w[Jaguar Audi Mercedes])
  select('Jaguar', from: 'form[manufacturer]')
  ```

## `:datalist_option`

Locates a `datalist` option.

- **Locator**: text or value of option

- **Filters**:
  - `:disabled {Boolean}`: whether to match disabled options

- **Example**:
  ```ruby
  datalist.find(:datalist_option, 'Jaguar', disabled: false)
  ```

## `:element`

Locates an element by tag or attributes.

- **Locator**: tag of the element

- **Filters**:
  - `Hash<{ String | Symbol}, {String | Regexp}>`: match on element attributes

- **Example**:
  ```ruby
  svg.find(:element, :linearGradient, visible: :all)
  form.find(:element, 'input', type: 'submit')
  ```

## `:fieldset`

Locates `fieldset` elements.

- **Locator**: matches id, [test_id][test_id], or contents of the legend

- **Filters**:
  - `:legend {String}`: matches contents of the legend
  - `:disabled {Boolean}`: whether to match disabled fieldsets

- **Example**:
  ```ruby
  within_fieldset('Employee') {
    fill_in 'Name', with: 'Jimmy'
  }
  ```

## `:frame`

Locates `frame` or `iframe` elements.

- **Locator**: id, [test_id][test_id], or name

- **Filters**:
  - `:name {String}`: match the name attribute

- **Example**:
  ```ruby
  find(:frame, 'embedded-chart', name: 'Q1')
  within_frame(name: 'Q2') { ... }
  ```

## `:id`

Locates elements by id, supports regular expressions.

- **Locator**: id

- **Example**:
  ```ruby
  find(:id, 'main')
  find_by_id('navbar', visible: :hidden)
  ```

## `:label`

Locates `label` elements.

- **Locator**: id, [test_id][test_id], or text contents

- **Filters**:
  - `:for {Element | String | Regexp}`: element or id of the element associated with the label

- **Example**:
  ```ruby
  find(:label, for: first_name_input)
  find(:label, 'First Name')
  ```

## `:option`

Locates `option` elements.

- **Locator**: text of the option

- **Filters**:
  - `:disabled {Boolean}`: whether to match disabled options
  - `:selected {Boolean}`: whether to match selected options

- **Example**:
  ```ruby
  locale.all(:option, selected: true)
  person_title.find(:option, 'Mrs')
  ```

## `:table`

Locates `table` elements.

- **Locator**: id, [test_id][test_id], or caption text of table

- **Filters**:
  - `:caption {String}`: match text of associated caption
  - `:with_rows {Array}`: match presence of `td` data
  - `:rows {Array}`: exact match of `td` data
  - `:with_cols {Array}`: match presence of `td` data
  - `:cols {Array}`: exact match of `td` data

- **Example**:
  ```ruby
  find(:table, 'Users', with_cols: [
    { 'First Name' => 'John' },
    { 'First Name' => 'Jane', 'Last Name' => 'Doe', 'City' => 'Unknown' },
  ])
  within_table(caption: 'Results') { ... }
  ```

## `:table_row`

Locates `tr` elements.

- **Locator**: `Array` or `Hash` of `td` contents

- **Example**:
  ```ruby
  table.should.have_selector(:table_row, { 'Name' => 'John' })
  table.should.have_selector(:table_row, ['Jane', 'Doe'])
  ```

## `:xpath`

Locates elements using an XPath expression.

- **Locator**: an XPath expression. Example: `.//option[@selected]`

- **Example**:
  ```ruby
  all(:xpath, `.//option[@selected]`)
  ```
