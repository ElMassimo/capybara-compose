# frozen_string_literal: true

class TableTestHelper < BaseTestHelper
# Aliases: Semantic aliases for locators, can be used in most DSL methods.

# Finders: A convenient way to get related data or nested elements.
  def row_for(*cells)
    find(:table_row, cells)
  end

# Actions: Encapsulate complex actions to provide a cleaner interface.

# Assertions: Check on element properties, used with `should` and `should_not`.

# Background: Helpers to add/modify/delete data in the database or session.
end
