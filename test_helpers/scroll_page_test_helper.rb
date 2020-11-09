# frozen_string_literal: true

class ScrollPageTestHelper < BaseTestHelper
# Selectors: Semantic aliases for elements, a very useful abstraction.
  SELECTORS = {
    scroller: '#scroll',
    scrollable: '#scrollable',
    inside_scrollable: '#inner',
  }.freeze

# Getters: A convenient way to get related data or nested elements.
  def center
    evaluate_script('(rect => (rect.top + rect.bottom) / 2)(this.getBoundingClientRect())')
  end

  def bottom
    evaluate_script('this.getBoundingClientRect().bottom')
  end

  def top
    evaluate_script('this.getBoundingClientRect().top')
  end

  def viewport_bottom
    evaluate_script('document.body.clientHeight')
  end

  def max_scroll
    if current_element?
      evaluate_script('this.scrollHeight - this.clientHeight')
    else
      evaluate_script('document.documentElement.scrollHeight - document.body.clientHeight')
    end
  end

# Actions: Encapsulate complex actions to provide a cleaner interface.

# Assertions: Allow to check on element properties while keeping it DRY.
  def be_at_the(location)
    case location
    when :top then expect(top).to be_within(1).of(0)
    when :bottom then expect(bottom).to be_within(1).of(viewport_bottom)
    when :center then expect(center).to be_within(2).of(viewport_bottom / 2)
    else raise ArgumentError, location
    end
  end

  def have_scrolled_to(*coordinates)
    synchronize_expectation {
      current_coordinates = evaluate_script('[window.scrollX || window.pageXOffset, window.scrollY || window.pageYOffset]')

      # Testing access to RSpec matcher.
      expect(current_coordinates).to all(be_a(Numeric))

      expect(current_coordinates).to eq coordinates
    }
  end

  def have_scroll_coordinates(*coordinates)
    synchronize_expectation {
      expect(evaluate_script('[this.scrollLeft, this.scrollTop]')).to eq coordinates
    }
  end

# Background: Helpers to add/modify/delete data in the database or session.
end
