require_relative 'octo_kit_wrapper/config_object'
require_relative 'octo_kit_wrapper/user'

require 'pry'
require 'octokit'

module OctokitWrapper

  # Configures the project

  def self.config(defaults = {})
    @config ||= Config.new(defaults)
  end

  def self.configure
    yield config if block_given?
    config
  end

  def self.user(options = { token: config.token })
    OctokitWrapper::User.new options
  end

end
