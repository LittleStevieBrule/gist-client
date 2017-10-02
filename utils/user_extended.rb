require_relative '../lib/gist_wrapper/user'

module GistWrapper
  class User
    def initialize(options)
      @options = options
      authenticate
    end

    def authenticate
      client.user.login
      @logged_in = true
    end

    def client
      @client ||= Octokit::Client.new @options
    end
  end
end