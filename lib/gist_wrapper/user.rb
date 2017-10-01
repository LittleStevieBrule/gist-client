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

    # Edit a gist
    #
    # @param options [Hash] Gist information.
    # @option options [String] :description
    # @option options [Hash] :files Files that make up this gist. Keys
    #   should be the filename, the value a Hash with a :content key with text
    #   content of the Gist.
    #
    #   NOTE: All files from the previous version of the
    #   gist are carried over by default if not included in the hash. Deletes
    #   can be performed by including the filename with a null hash.
    # @return
    #   [Sawyer::Resource] Newly created gist info
    # @see https://developer.github.com/v3/gists/#edit-a-gist
    # @example Update a gist
    #   @client.edit_gist({ :id => 'some_id',
    #     :files => {"boo.md" => {"content" => "updated stuff"}}
    #   })
    def edit_gist(options = {})
      authenticate unless authenticated?
      client.edit_gist options[:id], options
    end

    # Star a gist
    #
    # @param options [String] Gist options
    # @option options [String] :id id of gist
    # @return [Boolean] Indicates if gist is starred successfully
    # @see https://developer.github.com/v3/gists/#star-a-gist
    def star_gist(options = {})
      authenticate unless authenticated?
      client.star_gist options[:id]
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
      Octokit.gist options[:id]
    end

    # User has at least one gist?
    # @return [Boolean] true if the user has at least one gist
    def gist?
      !gists.empty?
    end

    # Check if a gist is starred
    #
    # @param options [Hash] options
    # @option options [String] :id Gist ID
    # @return [Boolean] Indicates if gist is starred
    # @see https://developer.github.com/v3/gists/#check-if-a-gist-is-starred
    def gist_starred?(options = {})
      client.gist_starred? options[:id]
    end

    # List the authenticated user’s starred gists
    #
    # @return [Array<String>] A list of gist ids
    # @see https://developer.github.com/v3/gists/#list-gists
    def starred_gists
      client.starred_gists.map do |gist|
        gist[:id]
      end
    end

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
