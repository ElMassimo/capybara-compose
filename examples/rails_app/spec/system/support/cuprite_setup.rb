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
      headless: !ENV['HEADLESS'].in?(%w[n 0 no false]),
    },
  )
end

Capybara.default_driver = Capybara.javascript_driver = :cuprite
