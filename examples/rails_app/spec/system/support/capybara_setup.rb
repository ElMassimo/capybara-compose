# frozen_string_literal: true

Capybara.configure do |config|
  config.default_max_wait_time = 2
  config.default_normalize_ws = true
  config.match = :smart
  config.exact = true
  config.ignore_hidden_elements = true
end
