# frozen_string_literal: true

# Example: Extend all built-in selectors to support a `data-qa` filter.
Capybara::Selector.all.each_value do |selector|
  selector.instance_eval do
    expression_filter(:qa) do |expression, value|
      builder(expression).add_attribute_conditions('data-qa': value)
    end
  end
end
