require_relative 'gist_wrapper/config_object'
require_relative 'gist_wrapper/user'

require 'pry'
require 'octokit'
require_relative 'gist_wrapper/sawyer_extended/resource'

# main entry point
module GistWrapper

  # Configures the project

  def self.config(defaults = {})
    @config ||= ProjectConfig.new(defaults)
  end

  def self.configure
    yield config if block_given?
    config
  end

  def self.user(options = { token: config.token })
    GistWrapper::User.new options
  end

  def self.public_gists
    Octokit.public_gists
  end

  # custom config
  class ProjectConfig < Config
    # this could be ignorant but as of now NilTokenError is what we want
    # IMPORTANT: Keep an Eye on this
    def error_mapping
      { :token= => GistWrapper::NilTokenError }
    end
  end

end
