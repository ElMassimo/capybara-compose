# frozen_string_literal: true

# Example: Include commonly used test helpers by default on every feature spec.
module DefaultTestHelpers
  def self.included(base)
    base.instance_eval do
      use_test_helpers(:current_page, :routes)

      # We delegate this method because it's used extremely often (on every test!)
      delegate :visit_page, to: :routes

      # Ensure we use a consistent screen size.
      before(:each, :screen_size) do |example|
        current_page.resize_to(example.metadata[:screen_size])
      end
    end
  end

  def be_an_invalid_element_error
    satisfy { |error| page.driver.invalid_element_errors.any? { |e| error.is_a? e } }
  end

  def silence_stream(stream)
    old_stream = stream.dup
    stream.reopen('/dev/null')
    stream.sync = true
    yield
  ensure
    stream.reopen(old_stream)
  end

  def quietly
    silence_stream(STDOUT) do
      silence_stream(STDERR) do
        yield
      end
    end
  end
end
