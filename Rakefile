require 'rspec/core/rake_task'
require_relative 'utils/setup'

RSpec::Core::RakeTask.new(:tests) do |task|
  task.pattern = 'spec/'
end

task :setup do
  Setup.run
end


task :default => :spec