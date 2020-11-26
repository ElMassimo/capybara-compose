# frozen_string_literal: true

# Example: Allow built-in selectors to support a `data-qa` attribute
#
# find_link('users.checkout') # <a data-qa="users.checkout">Checkout</a>
Capybara.configure do |config|
  config.test_id = 'data-qa'
end

# Example: Allow built-in selectors to receive an explicit `:qa` filter option.
#
# find_link(qa: 'users.checkout') # <a data-qa="users.checkout">Checkout</a>
Capybara::Selector.all.each_value do |selector|
  selector.instance_eval do
    expression_filter(:qa) do |expression, value|
      builder(expression).add_attribute_conditions('data-qa': value)
    end
  end
end
