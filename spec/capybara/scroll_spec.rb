# frozen_string_literal: true

RSpec.feature 'scroll', driver: :chrome_headless, test_helpers: [:scroll_page] do
  before do
    scroll_page.visit_page
  end

  it 'can scroll an element to the top of the viewport' do
    el = scroll_page.scroller
    scroll_page.scroll_to(el, align: :top)
    el.should.be_at_the(:top)
  end

  it 'can scroll an element to the bottom of the viewport' do
    el = scroll_page.scroller
    scroll_page.scroll_to(el, align: :bottom)
    el.should.be_at_the(:bottom)
  end

  it 'can scroll an element to the center of the viewport' do
    el = scroll_page.scroller
    scroll_page.scroll_to(el, align: :center)
    el.should.be_at_the(:center)
  end

  it 'can scroll the window to the vertical top' do
    scroll_page
      .scroll_to(:bottom)
      .scroll_to(:top)
      .should.have_scrolled_to(0, 0)
  end

  it 'can scroll the window to the vertical bottom' do
    scroll_page
      .scroll_to(:bottom)
      .should.have_scrolled_to(0, scroll_page.max_scroll)
  end

  it 'can scroll the window to the vertical center' do
    scroll_page
      .scroll_to(:center)
      .should.have_scrolled_to(0, scroll_page.max_scroll / 2.0)
  end

  it 'can scroll the window to specific location' do
    scroll_page
      .scroll_to(100, 100)
      .should.have_scrolled_to(100, 100)
  end

  it 'can scroll an element to the top of the scrolling element' do
    scrolling_element = scroll_page.scrollable
    el = scrolling_element.inside_scrollable
    scrolling_element.scroll_to(el, align: :top)
    expect(el.top).to be_within(3).of(scrolling_element.top)
  end

  it 'can scroll an element to the bottom of the scrolling element' do
    scrolling_element = scroll_page.scrollable
    el = scrolling_element.inside_scrollable
    scrolling_element.scroll_to(el, align: :bottom)
    scroller_bottom = scrolling_element.evaluate_script('this.getBoundingClientRect().top + this.clientHeight')
    expect(el.bottom).to be_within(1).of(scroller_bottom)
  end

  it 'can scroll an element to the center of the scrolling element' do
    scrolling_element = scroll_page.scrollable
    el = scrolling_element.inside_scrollable
    scrolling_element.scroll_to(el, align: :center)
    scrollable_center = scrolling_element.evaluate_script('(this.clientHeight / 2) + this.getBoundingClientRect().top')
    expect(el.center).to be_within(1).of(scrollable_center)
  end

  it 'can scroll the scrolling element to the top' do
    scroll_page.scrollable
      .scroll_to(:bottom)
      .scroll_to(:top)
      .should.have_scroll_coordinates(0, 0)
  end

  it 'can scroll the scrolling element to the bottom' do
    el = scroll_page.scrollable.scroll_to(:bottom)
    el.should.have_scroll_coordinates(0, el.max_scroll)
  end

  it 'can scroll the scrolling element to the vertical center' do
    el = scroll_page.scrollable.scroll_to(:center)
    el.should.have_scroll_coordinates(0, el.max_scroll / 2.0)
  end

  it 'can scroll the scrolling element to specific location' do
    scroll_page.scrollable
      .scroll_to(100, 100)
      .should.have_scroll_coordinates(100, 100)
  end

  it 'can scroll the window by a specific amount' do
    scroll_page
      .scroll_to(:current, offset: [50, 75])
      .should.have_scrolled_to(50, 75)
  end

  it 'can scroll the scroll the scrolling element by a specific amount' do
    scroll_page.scrollable
      .scroll_to(100, 100)
      .scroll_to(:current, offset: [-50, 50])
      .should.have_scroll_coordinates(50, 150)
  end
end
