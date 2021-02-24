# frozen_string_literal: true

require_relative 'lib/capybara/compose/version'

Gem::Specification.new do |spec|
  spec.name          = 'capybara-compose'
  spec.version       = Capybara::Compose::VERSION
  spec.authors       = ['Maximo Mussini']
  spec.email         = ['maximomussini@gmail.com']

  spec.summary       = 'Easily write fluent Page Objects for Capybara in Ruby.'
  spec.description   = 'Write tests that everyone can understand, and leverage your Ruby skills to keep them easy to read and easy to change.'
  spec.homepage      = 'https://github.com/ElMassimo/capybara-compose'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/ElMassimo/capybara-compose'
  spec.metadata['changelog_uri'] = 'https://github.com/ElMassimo/capybara-compose/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  spec.files         = Dir.glob('{lib}/**/*.rb') + %w[README.md CHANGELOG.md]
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'capybara'
  spec.add_dependency 'zeitwerk'
end
