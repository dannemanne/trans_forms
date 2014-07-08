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

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 2'
  s.add_development_dependency 'rspec-rails', '~> 2'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'database_cleaner'

  s.add_dependency 'virtus'
  s.add_dependency 'rails', '~> 3'
  s.add_dependency 'activemodel', '~> 3'
end
