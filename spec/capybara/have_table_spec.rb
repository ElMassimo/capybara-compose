# frozen_string_literal: true

RSpec.feature 'have_table', helpers: [:html_page] do
  before do
    visit('/tables')
  end

  it 'should be true if the table is on the page' do
    html_page.should.have_table('Villain')
    html_page.should.have_table('villain_table')
    html_page.should.have_table(:villain_table)
  end

  it 'should accept rows with column header hashes' do
    html_page.should.have_table(:horizontal_table, with_rows:
      [
        { 'First Name' => 'Vern', 'Last Name' => 'Konopelski', 'City' => 'Everette' },
        { 'First Name' => 'Palmer', 'Last Name' => 'Sawayn', 'City' => 'West Trinidad' },
      ])

    expect { html_page.should_not.have_table(:horizontal_table) }
      .to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  it 'should accept rows with partial column header hashses' do
    html_page.should.have_table('Horizontal Headers', with_rows:
      [
        { 'First Name' => 'Thomas' },
        { 'Last Name' => 'Sawayn', 'City' => 'West Trinidad' },
      ])
  end

  it 'should accept rows with array of cell values' do
    html_page.should.have_table('Horizontal Headers', with_rows:
      [
        %w[Thomas Walpole Oceanside],
        ['Ratke', 'Lawrence', 'East Sorayashire'],
      ])
  end

  it 'should consider order of cells in each row' do
    html_page.should_not.have_table('Horizontal Headers', with_rows:
      [
        %w[Thomas Walpole Oceanside],
        ['Lawrence', 'Ratke', 'East Sorayashire'],
      ])
  end

  it 'should accept all rows with array of cell values' do
    html_page.should.have_table('Horizontal Headers', rows:
      [
        %w[Thomas Walpole Oceanside],
        %w[Danilo Wilkinson Johnsonville],
        %w[Vern Konopelski Everette],
        ['Ratke', 'Lawrence', 'East Sorayashire'],
        ['Palmer', 'Sawayn', 'West Trinidad'],
      ])
  end

  it 'should match with vertical headers' do
    html_page.should.have_table('Vertical Headers', with_cols:
      [
        { 'First Name' => 'Thomas' },
        { 'First Name' => 'Danilo', 'Last Name' => 'Wilkinson', 'City' => 'Johnsonville' },
        { 'Last Name' => 'Sawayn', 'City' => 'West Trinidad' },
      ])
  end

  it 'should match col with array of cell values' do
    html_page.should.have_table('Vertical Headers', with_cols:
      [
        %w[Vern Konopelski Everette],
      ])
  end

  it 'should match cols with array of cell values' do
    html_page.should.have_table('Vertical Headers', with_cols:
      [
        %w[Danilo Wilkinson Johnsonville],
        %w[Vern Konopelski Everette],
      ])
  end

  it 'should match all cols with array of cell values' do
    html_page.should.have_table('Vertical Headers', cols:
      [
        %w[Thomas Walpole Oceanside],
        %w[Danilo Wilkinson Johnsonville],
        %w[Vern Konopelski Everette],
        ['Ratke', 'Lawrence', 'East Sorayashire'],
        ['Palmer', 'Sawayn', 'West Trinidad'],
      ])
  end

  it "should not match if the order of cell values doesn't match" do
    html_page.should_not.have_table('Vertical Headers', with_cols:
      [
        %w[Vern Everette Konopelski],
      ])
  end

  it "should not match with vertical headers if the columns don't match" do
    html_page.should_not.have_table('Vertical Headers', with_cols:
      [
        { 'First Name' => 'Thomas' },
        { 'First Name' => 'Danilo', 'Last Name' => 'Walpole', 'City' => 'Johnsonville' },
        { 'Last Name' => 'Sawayn', 'City' => 'West Trinidad' },
      ])
  end

  it 'should be false if the table is not on the page' do
    html_page.should_not.have_table('Monkey')
  end

  it 'should find row by header and cell values' do
    html_page.horizontal_table
      .should.have_table_row({ 'First Name' => 'Thomas', 'Last Name' => 'Walpole' })
      .should.have_table_row({ 'Last Name' => 'Walpole' })
      .should_not.have_table_row({ 'First Name' => 'Walpole' })
  end

  it 'should find row by cell values' do
    html_page.find(:table, :horizontal_table)
      .should.have_table_row(%w[Thomas Walpole])
      .should.have_table_row(%w[Thomas])
      .should.have_table_row(%w[Walpole])
      .should_not.have_table_row(%w[Walpole Thomas])
      .should_not.have_table_row(%w[Other])
  end
end

RSpec.feature 'have_no_table', helpers: [:html_page] do
  before do
    visit('/tables')
  end

  it 'should be false if the table is on the page' do
    html_page.should_not.have_no_table('Villain')
    html_page.should_not.have_no_table('villain_table')
  end

  it 'should be true if the table is not on the page' do
    html_page.should.have_no_table('Monkey')
  end

  it 'should consider rows' do
    html_page.should.have_no_table('Horizontal Headers', with_rows:
     [
       { 'First Name' => 'Thomas', 'City' => 'Los Angeles' },
     ])
  end

  context 'using :with_cols' do
    it 'should consider a single column' do
      html_page.should.have_no_table('Vertical Headers', with_cols:
        [
          { 'First Name' => 'Joe' },
        ])
    end

    it 'should be true even if the last column does exist' do
      html_page.should.have_no_table('Vertical Headers', with_cols:
        [
          {
            'First Name' => 'What?',
            'What?' => 'Walpole',
            'City' => 'Oceanside', # This line makes the example fail
          },
        ])
    end

    it 'should be true if none of the columns exist' do
      html_page.should.have_no_table('Vertical Headers', with_cols:
        [
          {
            'First Name' => 'What?',
            'What?' => 'Walpole',
            'City' => 'What?',
          },
        ])
    end

    it 'should be true if the first column does match' do
      html_page.should.have_no_table('Vertical Headers', with_cols:
        [
          {
            'First Name' => 'Thomas',
            'Last Name' => 'What',
            'City' => 'What',
          },
        ])
    end

    it 'should be true if none of the columns match' do
      html_page.should.have_no_table('Vertical Headers', with_cols:
        [
          {
            'First Name' => 'What',
            'Last Name' => 'What',
            'City' => 'What',
          },
        ])
    end
  end
end
