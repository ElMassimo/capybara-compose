# frozen_string_literal: true

RSpec.feature '#matches_style?', driver: :chrome_headless, helpers: [:html_page] do
  before do
    html_page.visit_page
  end

  it 'should be true if the element has the given style' do
    html_page.find('#first').should.match_style(display: 'block')
    expect(html_page.find('#first').matches_style?(display: 'block')).to be true
    html_page.find('#second').should.match_style('display' => 'inline')
    expect(html_page.find('#second').matches_style?('display' => 'inline')).to be true
  end

  it 'should be false if the element does not have the given style' do
    expect(html_page.find('#first').matches_style?('display' => 'inline')).to be false
    expect(html_page.find('#second').matches_style?(display: 'block')).to be false
  end

  it 'allows Regexp for value matching' do
    html_page.find('#first').should.match_style(display: /^bl/)
    expect(html_page.find('#first').matches_style?('display' => /^bl/)).to be true
    expect(html_page.find('#first').matches_style?(display: /^in/)).to be false
  end

  it 'deprecated has_style?' do
    expect { html_page.find('#first').should.have_style(display: /^bl/) }.to \
      output(/have_style is deprecated/).to_stderr

    expect { expect(html_page.find('#first').has_style?('display' => /^bl/)).to eq true }.to \
      output(/has_style\? is deprecated/).to_stderr
  end
end
