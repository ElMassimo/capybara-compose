# frozen_string_literal: true

RSpec.feature 'Development Warnings' do
  before do
    CapybaraTestHelpers.config.helpers_paths = CapybaraTestHelpers::DEFAULTS[:helpers_paths]
  end
  after do
    CapybaraTestHelpers.config.helpers_paths = CapybaraTestHelpers::DEFAULTS[:helpers_paths]
  end

  let(:html_page) { get_test_helper(:html_page) }
  let(:form_page) { get_test_helper(:form_page) }

  it 'warns when redefining DSL methods' do
    expect {
      class InvalidTestHelper < Capybara::TestHelper
        def find_element
          'something else'
        end
      end
    }.to raise_error(RuntimeError, /A method with the name :find_element/)
  end

  it 'warns when none of the available paths includes the requested test helper' do
    expect { get_test_helper(:invalid_selectors) }
      .to raise_error(LoadError, start_with(%(No 'invalid_selectors_test_helper.rb' file found in ["test_helpers"])))

    expect { get_test_helper(:invalid_selector_methods) }
      .to raise_error(LoadError, start_with(%(No 'invalid_selector_methods_test_helper.rb' file found in ["test_helpers"])))

    expect { get_test_helper(:routes) }.not_to raise_error
  end

  it 'warns when using Capybara selectors as locator aliases' do
    CapybaraTestHelpers.config.helpers_paths += ['test_helpers_invalid']

    expect { get_test_helper(:invalid_selectors) }
      .to raise_error(RuntimeError, /A selector with the name :button is already registered in Capybara/)

    expect { get_test_helper(:invalid_selector_methods) }
      .to raise_error(RuntimeError, /A method with the name :source is part of the Capybara DSL/)
  end

  it 'warns when using dynamic RSpec predicates' do
    expect(html_page.respond_to?(:random)).to eq false
    expect { html_page.random }
      .to raise_error(NoMethodError, /undefined method `random' for #<HtmlPageTestHelper .*>$/)

    expect(html_page.respond_to?(:be_checked)).to eq false
    expect { html_page.should.be_checked }
      .to raise_error(NoMethodError, /undefined method `be_checked' for #<HtmlPageTestHelper .*>\.\nUse `delegate_to_test_context/)

    expect(form_page.respond_to?(:be_checked)).to eq true
    expect { form_page.should.be_checked }
      .to raise_error(ArgumentError) # Because there's no current element.
  end
end
