$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'csv_factory/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'csv_factory'
  s.version     = CsvFactory::VERSION
  s.authors     = ['Snapsheet, Inc.']
  s.email       = ['technotifications@snapsheet.me']
  # s.homepage    = ""
  s.summary     = 'Tool that builds CSV files'
  s.license     = 'UNLICENSED'

  s.files = Dir['lib/**/*', 'README.md']
end
