# frozen_string_literal: true

require 'webdrivers'
require 'capybara/cuprite'

Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(
    app,
    **{
      browser_options: { 'no-sandbox' => nil },
      process_timeout: 10,
      inspector: true,
      headless: %w[true 1 yes].include?(ENV['HEADLESS']),
    },
  )
end
