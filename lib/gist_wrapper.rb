require_relative 'gist_wrapper/config_object'
require_relative 'gist_wrapper/user'
require_relative 'gist_wrapper/sawyer_extended/resource'

require 'pry'
require 'octokit'
require 'psych'

# main entry point
module GistWrapper

  # Configures the project

  def self.config(defaults = {token: Psych.load_file(GistWrapper::YAML_PATH)[:token]})
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

  def self.test_token
    begin
      new_user = user
      new_user.authenticate
      sleep 1
      new_user.authenticated?
    rescue Octokit::Unauthorized
      false
    end
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
