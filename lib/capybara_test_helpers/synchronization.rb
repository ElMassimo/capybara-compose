# frozen_string_literal: true

# Internal: Provides helper functions to perform asynchronous assertions.
module CapybaraTestHelpers::Synchronization
  # Internal: Necessary because the RSpec exception is not a StandardError and
  # thus capybara does not rescue it, so it wouldn't attempt to retry it.
  class ExpectationError < StandardError; end

  # Internal: Errors that will be retried in a `synchronize_expectation` block.
  EXPECTATION_ERRORS = [
    ExpectationError,
    Capybara::ElementNotFound,
    (Selenium::WebDriver::Error::StaleElementReferenceError if defined?(Selenium::WebDriver::Error::StaleElementReferenceError)),
  ].compact.freeze

protected

  # Public: Can be used to make an asynchronous expectation, that will be
  # retried until the max wait time configured in Capybara.
  def synchronize_expectation(retry_on_errors: [], **options)
    synchronize(errors: EXPECTATION_ERRORS + retry_on_errors, **options) {
      begin
        yield
      rescue RSpec::Expectations::ExpectationNotMetError => error
        # NOTE: Rethrow as ExpectationError because the RSpec exception is not
        # a StandardError so capybara wouldn't rescue it inside synchronize.
        raise ExpectationError, error
      end
    }
  rescue ExpectationError => error
    raise error.cause # Unwrap this internal error and raise the original error.
  end

  # Public: Used to implement more specific synchronization helpers.
  #
  # By default Capybara's methods like `find` and `have_css` already use
  # synchronize to achieve asynchronicity, so it's not necessary to use this.
  def synchronize(wait: Capybara.default_max_wait_time == 0 ? Capybara.default_max_wait_time : 3, **options, &block)
    (current_element? ? current_context : page.document).synchronize(wait, **options, &block)
  end
end
