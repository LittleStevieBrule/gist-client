require_relative '../lib/gist_wrapper'

OctokitWrapper.configure do |config|
  config.token = ENV['GISTTOKEN']
end