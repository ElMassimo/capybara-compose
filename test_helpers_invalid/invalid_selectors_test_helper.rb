# frozen_string_literal: true

class InvalidSelectorsTestHelper < Capybara::TestHelper
  aliases(
    button: '.button',
    link: '.link',
  )
end
