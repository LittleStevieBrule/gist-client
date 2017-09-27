require_relative 'errors'
require_relative 'config_object'

module GistWrapper

  # user class TODO: Doucmentation
  class User

    attr_accessor :options

    def initialize(options)
      @options = UserConfig.new(options)
      authenticate if options[:token]
    end

    # @return [Boolean]
    def authenticated?
      @logged_in ||= false
    end

    # Create a gist
    #
    # @param options [Hash] Gist information.
    # @option options [String] :description
    # @option options [Boolean] :public Sets gist visibility
    # @option options [Array<Hash>] :files Files that make up this gist. Keys
    #   should be the filename, the value a Hash with a :content key with text
    #   content of the Gist.
    # @return [Sawyer::Resource] Newly created gist info
    # @see https://developer.github.com/v3/gists/#create-a-gist
    def create_gist(options = {})
      authenticate unless authenticated?
      client.create_gist options
    end

    # Delete a gist
    # @param options
    # @option id [String] Gist ID
    # @return [Boolean] Indicating success of deletion
    # @see https://developer.github.com/v3/gists/#delete-a-gist
    def delete_gist(options = {})
      authenticate unless authenticated?
      client.delete_gist options[:id]
    end

    # The users Gists
    #
    # @return [Array<Sawyer::Resource>] the users gists
    def gists
      if authenticated?
        client.gists
      else
        Octokit.gists @options.username
      end
    end

    # Get a single gist
    #
    # @param options [Hash] gist options
    # @option gist [String] ID of gist to fetch
    # @option options [String] :sha Specific gist revision SHA
    # @return [Sawyer::Resource] Gist information
    # @see https://developer.github.com/v3/gists/#get-a-single-gist
    # @see https://developer.github.com/v3/gists/#get-a-specific-revision-of-a-gist
    def gist(options = {})
      Ocktokit.gist options[:id]
    end

    # User has at least one gist?
    # @return [Boolean] true if the user has at least one gist
    def gist?
      !gists.empty?
    end

    private

    # Octokit client
    def client
      @client ||= Octokit::Client.new access_token: @options.token
    end

    # authenticates the user
    def authenticate
      client.login
      @logged_in = true
    end

  end

  # I think this will work although it could be overly complex for what I need.
  # Update: Turns out this is really useful
  class UserConfig < Config
    def error_mapping
      {
        username: GistWrapper::NoUsernameDefined,
        token: GistWrapper::AuthenticationError
      }
    end
  end

end
