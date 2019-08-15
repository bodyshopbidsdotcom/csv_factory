$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'csv_factory/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'csv_factory'
  spec.version     = CsvFactory::VERSION
  spec.authors     = ['Snapsheet, Inc.']
  spec.email       = ['technotifications@snapsheet.me']
  # spec.homepage    = ""
  spec.summary     = 'Tool that builds CSV files'
  spec.homepage    = 'https://github.com/snapsheet/csv_factory'
  spec.license     = 'MIT'

  # Files included in this gem.
  # https://guides.rubygems.org/specification-reference/#files
  spec.files = Dir['lib/**/*', 'README.md']

  # Paths in the gem to add to $LOAD_PATH when this gem is activated.
  # https://guides.rubygems.org/specification-reference/#require_paths=
  spec.require_paths = ['lib']

  # Only with ruby 2.x
  spec.required_ruby_version = '~> 2.2'

  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'pry', '~> 0.12'
end
