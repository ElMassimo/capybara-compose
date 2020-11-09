# frozen_string_literal: true

class TableTestHelper < BaseTestHelper
# Selectors: Semantic aliases for elements, a useful abstraction.

# Getters: A convenient way to get related data or nested elements.
  def row_for(*cells)
    find(:table_row, cells)
  end

# Actions: Encapsulate complex actions to provide a cleaner interface.

# Assertions: Check on element properties, used with `should` and `should_not`.

# Background: Helpers to add/modify/delete data in the database or session.
end
