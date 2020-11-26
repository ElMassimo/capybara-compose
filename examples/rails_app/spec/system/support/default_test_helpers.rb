# frozen_string_literal: true

# Example: Include commonly used test helpers by default on every feature spec.
module DefaultTestHelpers
  extend ActiveSupport::Concern

  included do
    use_test_helpers(:current_page, :navigation)

    # We delegate this method because it's used extremely often (on every test!)
    delegate :visit_page, to: :navigation

    # Ensure we use a consistent screen size.
    before(:each) do |example|
      current_page.resize_to(example.metadata[:screen_size] || :desktop)
    end
  end
end
