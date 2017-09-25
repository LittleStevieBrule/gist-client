require_relative '../lib/gist_wrapper'

GistWrapper.configure do |config|
  config.token = ENV['GISTTOKEN']
end