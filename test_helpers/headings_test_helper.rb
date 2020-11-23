# frozen_string_literal: true

class HeadingsTestHelper < BaseTestHelper
# Aliases: Semantic aliases for locators, can be used in most DSL methods.
  aliases(
    title: 'h1',
    subtitle: 'h2',
    paragraph: 'p',
  )

# Finders: A convenient way to get related data or nested elements.
  def subtitles
    all(:subtitle) { |element| element[:class] == 'head' }
  end

# Actions: Encapsulate complex actions to provide a cleaner interface.
# Assertions: Allow to check on element properties while keeping it DRY.
# Background: Helpers to add/modify/delete data in the database or session.
end
