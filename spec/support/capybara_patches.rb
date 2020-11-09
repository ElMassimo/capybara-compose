# frozen_string_literal: true

# TODO: Remove this once Capybara releases the fix for drop.
class Capybara::Node::Element
  def drop(*args)
    options = args.map { |arg| arg.respond_to?(:to_path) ? arg.to_path : arg }
    synchronize { base.drop(*options) }
    self
  end
end
