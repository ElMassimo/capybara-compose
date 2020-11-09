# frozen_string_literal: true

RSpec.feature '#within', helpers: [:scopes_page] do
  before do
    scopes_page.visit_page
  end

  it 'should allow to escape a within restriction using within_document' do
    scopes_page.within_element(:first_section) do
      scopes_page.should_not.have_content('First Name')

      scopes_page.within_document do
        scopes_page.should.have_content('First Name')
      end

      scopes_page.should_not.have_content('First Name')
    end
  end

  context 'with CSS selector' do
    it 'should click links in the given scope' do
      scopes_page.within(:first_item) {
        scopes_page.click_link('Go')
      }
      scopes_page.should.have_content('Bar')
    end

    it 'should assert content in the given scope' do
      scopes_page.first_section.within do
        scopes_page.should_not.have_content('First Name')
      end
      scopes_page.should.have_content('First Name')
    end

    it 'should accept additional options' do
      scopes_page.within(:css, :list_item, text: 'With Simple HTML') do
        scopes_page.click_link('Go')
      end
      scopes_page.should.have_content('Bar')
    end

    it 'should reload the node if the page is changed' do
      scopes_page.within(:first_section) do
        current_page.visit('/with_scope_other')
        scopes_page.should.have_content('Different text')
      end
    end

    it 'should reload multiple nodes if the page is changed' do
      scopes_page.within(:css, '#for_bar') do
        scopes_page.within(:css, 'form[action="/redirect"]') do
          scopes_page.refresh
          scopes_page.should.have_content('First Name')
        end
      end
    end

    it 'should error if the page is changed and a matching node no longer exists' do
      scopes_page.within(:first_section) do
        current_page.visit('/')
        expect { scopes_page.text }.to raise_error(StandardError)
      end
    end
  end

  context 'with XPath selector' do
    it 'should click links in the given scope' do
      scopes_page.within(:xpath, "//div[@id='for_bar']//li[contains(.,'With Simple HTML')]") do
        scopes_page.click_link('Go')
      end
      scopes_page.should.have_content('Bar')
    end
  end

  context 'with Node rather than selector' do
    it 'should click links in the given scope' do
      node_of_interest = scopes_page.find(:css, :list_item, text: 'With Simple HTML')

      scopes_page.within(node_of_interest) do
        scopes_page.click_link('Go')
      end
      scopes_page.should.have_content('Bar')
    end
  end

  context 'with the default selector set to CSS' do
    it 'should use CSS' do
      scopes_page.within(:list_item, text: 'With Simple HTML') do
        scopes_page.click_link('Go')
      end
      scopes_page.should.have_content('Bar')
    end
  end

  context 'with nested scopes' do
    it 'should respect the inner scope' do
      scopes_page.within(:xpath, "//div[@id='for_bar']") do
        scopes_page.within(:xpath, ".//li[contains(.,'Bar')]") do
          scopes_page.click_link('Go')
        end
      end
      scopes_page.should.have_content('Another World')
    end

    it 'should respect the outer scope' do
      scopes_page.within(:xpath, "//div[@id='another_foo']") do
        scopes_page.find(:xpath, ".//li[contains(.,'With Simple HTML')]").within do
          scopes_page.click_link('Go')
        end
      end
      scopes_page.should.have_content('Hello world')
    end
  end

  it 'should raise an error if the scope is not found on the page' do
    expect do
      scopes_page.within(:xpath, "//div[@id='doesnotexist']") do
      end
    end.to raise_error(Capybara::ElementNotFound)
  end

  it 'should restore the scope when an error is raised' do
    expect do
      scopes_page.within(:xpath, "//div[@id='for_bar']") do
        expect do
          expect do
            scopes_page.within(:xpath, ".//div[@id='doesnotexist']") do
            end
          end.to raise_error(Capybara::ElementNotFound)
        end.not_to change { scopes_page.has_xpath?(".//div[@id='another_foo']") }.from(false)
      end
    end.not_to change { scopes_page.has_xpath?(".//div[@id='another_foo']") }.from(true)
  end

  it 'should fill in a field and click a button' do
    scopes_page.within(:xpath, "//li[contains(.,'Bar')]") do
      scopes_page.click_button('Go')
    end
    scopes_page.should.have_results('first_name', 'Peter')
    current_page.visit('/with_scope')
    scopes_page.within(:xpath, "//li[contains(.,'Bar')]") do
      scopes_page.fill_in('First Name', with: 'Dagobert')
      scopes_page.click_button('Go')
    end
    scopes_page.should.have_results('first_name', 'Dagobert')
  end
end

RSpec.feature '#within_fieldset', helpers: [:scopes_page] do
  before do
    page.visit('/fieldsets')
  end

  it 'should restrict scope to a fieldset given by id' do
    scopes_page.within_fieldset('villain_fieldset') do
      scopes_page.fill_in('Name', with: 'Goldfinger')
      scopes_page.click_button('Create')
    end
    scopes_page.should.have_results('villain_name', 'Goldfinger')
  end

  it 'should restrict scope to a fieldset given by legend' do
    scopes_page.within_fieldset('Villain') do
      scopes_page.fill_in('Name', with: 'Goldfinger')
      scopes_page.click_button('Create')
    end
    scopes_page.should.have_results('villain_name', 'Goldfinger')
  end
end

RSpec.feature '#within_table', helpers: [:scopes_page] do
  before do
    page.visit('/tables')
  end

  it 'should restrict scope to a fieldset given by id' do
    scopes_page.within_table('girl_table') do
      scopes_page.fill_in('Name', with: 'Christmas')
      scopes_page.click_button('Create')
    end
    scopes_page.should.have_results('girl_name', 'Christmas')
  end

  it 'should restrict scope to a fieldset given by legend' do
    scopes_page.within_table('Villain') do
      scopes_page.fill_in('Name', with: 'Quantum')
      scopes_page.click_button('Create')
    end
    scopes_page.should.have_results('villain_name', 'Quantum')
  end
end
