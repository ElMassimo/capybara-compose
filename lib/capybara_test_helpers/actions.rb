# frozen_string_literal: true

# Internal: Allows to pass test helpers as arguments to `evaluate_script`.
Capybara::Session.prepend(Module.new {
private

  # Override: To ensure test helpers are sent to the driver as native elements.
  def driver_args(args)
    super(args.map { |arg| arg.is_a?(CapybaraTestHelpers::TestHelper) ? arg.to_capybara_node : arg })
  end
})

# Internal: Allows to pass a test helper to `scroll_to`.
Capybara::Node::Element.prepend(Module.new {
  # Override: Unwrap capybara test helpers into a node.
  def scroll_to(pos_or_x_or_el, *args, **kwargs)
    pos_or_x_or_el = pos_or_x_or_el.to_capybara_node if pos_or_x_or_el.is_a?(CapybaraTestHelpers::TestHelper)
    super
  end
})

# Internal: Wraps Capybara actions to enable locator aliases, and to wrap the
# result with a test helper so that methods can be chained in a fluent style.
module CapybaraTestHelpers::Actions
  delegate(
    :==,  # Allows to make comparisons more transparent.
    :===, # Allows to ensure case statements inside Capybara work as expected.
    to: :to_capybara_node,
  )

  delegate(
    :[],
    :all_text,
    :checked?,
    :disabled?,
    :multiple?,
    :obscured?,
    :readonly?,
    :selected?,
    :base,
    :native,
    :path,
    :rect,
    :style,
    :tag_name,
    :text,
    :value,
    :visible?,
    :visible_text,
    to: :to_capybara_node,
  )

  delegate(
    :evaluate_script,
    :evaluate_async_script,
    to: :current_context,
  )

  %i[
    execute_script
    scroll_to
  ].each do |method_name|
    CapybaraTestHelpers.define_helper_method(self, method_name, return_self: true, inject_test_helper: false)
  end

  %i[
    click
    double_click
    drag_to
    drop
    flash
    hover
    reload
    right_click
    select_option
    send_keys
    set
    trigger
    unselect_option
  ].each do |method_name|
    CapybaraTestHelpers.define_helper_method(self, method_name, target: :to_capybara_node, return_self: true, inject_test_helper: false)
  end

  %i[
    click_on
    click_link_or_button
    click_button
    click_link
    choose
    check
    uncheck
    fill_in
    attach_file
    select
    unselect
  ].each do |method_name|
    CapybaraTestHelpers.define_helper_method(self, method_name, wrap: true)
  end

  # Public: Sets the value for the input, or presses the specified keys, one at a time.
  def type_in(*text, typing: text.size > 1 || text.first.is_a?(Symbol) || text.first.is_a?(Array), **options)
    typing ? send_keys(*text) : set(text.first, **options)
  end

  # Public: Useful to natively give focus to an element.
  def focus
    to_capybara_node.execute_script('this.focus()')
    self
  end

  # Public: Useful to natively blur an element.
  def blur
    to_capybara_node.execute_script('this.blur()')
    self
  end
end
