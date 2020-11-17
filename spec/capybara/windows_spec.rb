# frozen_string_literal: true

RSpec.describe 'new windows', type: :feature, driver: :chrome_headless, test_helpers: [:windows_page] do
  it 'should become closed' do
    windows_page.visit_page
    current_page.should.be(:windows_page)
    current_page.should.have_title('With Windows')

    # Closing it manually after a certain time.
    current_page.after_opening_new_tab(-> { windows_page.open_window }, close_afterwards: false) { |new_window|
      windows_page.close_with_delay(500)
      current_page.should.have_title('Title of the first popup')
      expect(new_window).to become_closed(wait: 5)
    }

    current_page.should.have_title('With Windows')

    # Closing it automatically after holding a reference to the window.
    current_page.after_opening_new_tab(-> { windows_page.open_window(delay: true) }) { |window|
      current_page.should.have_title('Title of the first popup')
      @other_window = window
    }
    expect(@other_window).to become_closed(wait: 5)
    current_page.should.have_title('With Windows')
  end
end
