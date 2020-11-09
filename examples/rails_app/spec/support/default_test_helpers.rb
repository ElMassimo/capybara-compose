# frozen_string_literal: true

# Example: Include commonly used test helpers by default on every feature spec.
module DefaultTestHelpers
  extend ActiveSupport::Concern

  included do
    use_test_helpers(:current_page, :routes)

    # We delegate this method because it's used extremely often (on every test!)
    delegate :visit_page, to: :routes

    # Ensure we use a consistent screen size.
    before(:each) do |example|
      driven_by(:selenium)
      current_page.resize_to(example.metadata[:screen_size] || :desktop)
    end
  end
end
