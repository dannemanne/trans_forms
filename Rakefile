require 'rake'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

task 'default' => 'ci'

desc 'Run all tests for CI'
task 'ci' => 'spec'

desc 'Run all specs'
task 'spec' => 'spec:all'

namespace 'spec' do
  task 'all' => ['trans_forms', 'generators']

  def spec_task(name)
    desc "Run #{name} specs"
    RSpec::Core::RakeTask.new(name) do |t|
      t.pattern = "spec/#{name}/**/*_spec.rb"
    end
  end

  spec_task 'trans_forms'
  spec_task 'generators'

end

