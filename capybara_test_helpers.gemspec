# frozen_string_literal: true

require_relative 'lib/capybara_test_helpers/version'

Gem::Specification.new do |spec|
  spec.name          = 'capybara_test_helpers'
  spec.version       = CapybaraTestHelpers::VERSION
  spec.authors       = ['Maximo Mussini']
  spec.email         = ['maximomussini@gmail.com']

  spec.summary       = 'Easily write fluent Page Objects for Capybara in Ruby.'
  spec.description   = 'Write tests that everyone can understand, and leverage your Ruby skills to keep them easy to read and easy to change.'
  spec.homepage      = 'https://github.com/ElMassimo/capybara_test_helpers'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/ElMassimo/capybara_test_helpers'
  spec.metadata['changelog_uri'] = 'https://github.com/ElMassimo/capybara_test_helpers/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  spec.files         = Dir.glob('{lib}/**/*.rb') + %w[README.md CHANGELOG.md]
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'capybara'
end
