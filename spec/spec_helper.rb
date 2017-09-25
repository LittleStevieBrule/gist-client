require_relative '../lib/octo_kit_wrapper'

OctokitWrapper.configure do |config|
  config.token = ENV['GISTTOKEN']
end