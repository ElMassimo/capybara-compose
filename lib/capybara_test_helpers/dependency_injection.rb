# frozen_string_literal: true

# Internal: Provides dependency injection for RSpec and Cucumber, by using the
# test helper name and a convention for naming and organizing helpers.
module CapybaraTestHelpers::DependencyInjection
  # Public: Returns an instance of a test helper that inherits BaseTestHelper.
  #
  # NOTE: Memoizes the test helper instances, keeping one per test helper class.
  # Test helpers are not mutable, they return a new instance every time an
  # operation is performed, so it's safe to apply this optimization.
  def get_test_helper(helper_name)
    ivar_name = "@#{ helper_name }_capybara_test_helper"
    instance_variable_get(ivar_name) ||
      instance_variable_set(ivar_name, get_test_helper_class(helper_name).new(self))
  end

  # Internal: Requires a test helper file and memoizes the class for all tests.
  #
  # Returns a Class that subclasses BaseTestHelper.
  def get_test_helper_class(name)
    file_name = "#{ name }_test_helper"
    ivar_name = "@#{ file_name }_test_helper_class"
    instance_variable_get(ivar_name) || begin
      require_test_helper(file_name)
      test_helper_class = file_name.camelize.constantize
      test_helper_class.on_test_helper_load
      instance_variable_set(ivar_name, test_helper_class)
    end
  end

  # Internal: Requires a test helper file.
  def require_test_helper(name)
    CapybaraTestHelpers.config.helpers_paths.each do |path|
      require Pathname.new(File.expand_path(path)).join("#{ name }.rb").to_s
      return true # Don't check on the result, it could have been required earlier.
    rescue LoadError
      false
    end
    raise LoadError, "No '#{ name }.rb' file found in #{ CapybaraTestHelpers.config.helpers_paths.inspect }. "\
      'Check for typos, or make sure the dirs in `CapybaraTestHelpers.config.helpers_paths` are in the load path.'
  end
end

Capybara.extend(CapybaraTestHelpers::DependencyInjection)
