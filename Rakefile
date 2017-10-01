require 'rspec/core/rake_task'
require_relative 'utils/setup'
require_relative 'lib/gist_wrapper'

# GistWrapper.configure do |config|
#   config.token = Psych.load_file(GistWrapper::YAML_PATH)[:token]
# end

RSpec::Core::RakeTask.new(:tests) do |task|
  task.pattern = 'spec/'
end

task :setup do
  Setup.run
end

task :both do
  Rake::Task[:setup].invoke
  Rake::Task[:tests].invoke
end


task :default => :both