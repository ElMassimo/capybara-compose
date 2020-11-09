# frozen_string_literal: true

class ResultsTestHelper < BaseTestHelper
# Selectors: Semantic aliases for elements, a very useful abstraction.

# Getters: A convenient way to get related data or nested elements.

# Actions: Encapsulate complex actions to provide a cleaner interface.

# Assertions: Allow to check on element properties while keeping it DRY.
  def have_results(field, value)
    should.have_xpath("//pre[@id='results']")
    results = YAML.load Capybara::HTML(page.body).xpath("//pre[@id='results']").first.inner_html.lstrip
    expect(results[field]).to eq value
  end

# Background: Helpers to add/modify/delete data in the database or session.
end
