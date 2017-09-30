require_relative '../lib/gist_wrapper'
require_relative '../lib/gist_wrapper/constants'
require 'psych'
require 'pry'

GistWrapper.configure do |config|
  config.token = Psych.load_file(GistWrapper::YAML_PATH)[:token]
end