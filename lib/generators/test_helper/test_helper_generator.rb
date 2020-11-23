# frozen_string_literal: true

require 'capybara_test_helpers'
require 'rails/generators/named_base'

# Internal: Generates a new test helper file in the appropriate directory.
class TestHelperGenerator < Rails::Generators::NamedBase
  def base_helper?
    file_name.to_s == 'base'
  end

  def create_helper_file
    create_file("#{ CapybaraTestHelpers.config.helpers_paths.first }/#{ file_name }_test_helper.rb") {
      <<~CAPYBARA_TEST_HELPER
        # frozen_string_literal: true

        class #{ file_name.camelize }TestHelper < #{ base_helper? ? 'Capybara::TestHelper' : 'BaseTestHelper' }
        # Aliases: Semantic aliases for locators, can be used in most DSL methods.
          aliases(
            #{ base_helper? ? '# Avoid defining :el here since it will be inherited by all helpers.' : "# el: '.#{ file_name.tr('_', '-') }'," }
          )

        # Finders: A convenient way to get related data or nested elements.

        # Actions: Encapsulate complex actions to provide a cleaner interface.

        # Assertions: Check on element properties, used with `should` and `should_not`.

        # Background: Helpers to add/modify/delete data in the database or session.
        end
      CAPYBARA_TEST_HELPER
    }
  end
end
