# frozen_string_literal: true

require 'webdrivers'
require 'selenium/webdriver'

def create_chrome_driver(app)
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--disable-infobars')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_preference(:download,
    directory_upgrade: true,
    prompt_for_download: false,
    default_directory: Capybara.get_test_helper_class(:downloads)::DOWNLOADS_DIR.to_s)
  yield(options) if block_given?

  Capybara::Selenium::Driver.new(app, browser: :chrome, native_displayed: true, options: options)
end

Capybara.register_driver :chrome do |app|
  create_chrome_driver(app)
end

Capybara.register_driver :chrome_headless do |app|
  create_chrome_driver(app) do |options|
    options.add_argument('--headless')
  end
end
