require_relative 'octo_kit_wrapper/config_object'
require_relative 'octo_kit_wrapper/user'

require 'pry'
require 'octokit'

module OctokitWrapper

  # Configures the project

  def self.config(defaults = {})
    @config ||= CustomConfig.new(defaults)
  end

  def self.configure
    yield config if block_given?
    config
  end

  def self.user(options = { token: config.token })
    OctokitWrapper::User.new options
  end

  # custom config
  class CustomConfig < Config
    # this could be ignorant but as of now NilTokenError is what we want
    # IMPORTANT: Keep an Eye on this
    def error_mapping
      { :token= => OctokitWrapper::NilTokenError }
    end
  end

end
