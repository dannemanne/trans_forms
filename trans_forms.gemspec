require File.expand_path('../lib/trans_forms/version', __FILE__)

Gem::Specification.new do |s|
  s.authors     = ['Daniel Viklund']
  s.email       = ['dannemanne@gmail.com']
  s.summary     = 'Gem to create Form records that handles multiple changes wrapped in a transaction'
  s.description = 'Gem to create Form records that handles multiple changes wrapped in a transaction'
  s.homepage    = 'https://github.com/dannemanne/trans_forms'
  s.license     = 'MIT'

  s.name        = 'trans_forms'
  s.version     = TransForms::VERSION
  s.date        = '2014-07-08'

  s.files         = Dir['{lib}/**/*'] + ['README.md']
  s.test_files    = Dir['{spec}/**/*']
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'virtus'
  s.add_dependency 'activemodel', '>= 3.1.0'
  s.add_dependency 'activesupport', '>= 3.1.0'

  s.add_development_dependency 'activerecord', '>= 3.1.0'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'codeclimate-test-reporter'
end
