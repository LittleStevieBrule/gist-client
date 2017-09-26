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

    def client
      @client ||= Octokit::Client.new access_token: @options.token
    end

    def authenticated?
      @logged_in ||= false
    end

    #   Create a gist
    #     Parameters:
    #       options (Hash) (defaults to: {})  Gist information.
    #         Options Hash (options):
    #           :description (String)
    #           :public (Boolean)  Sets gist visibility
    #           :files (Array<Hash>)  Files that make up this gist. Keys should be
    #            the filename, the value a Hash with a :content key with text
    #            content of the Gist.
    #       Returns:
    #         (Sawyer::Resource)  Newly created gist info
    # example:
    #           content = {
    #             description: 'the description for this gist',
    #             public: true,
    #             files: {
    #               'file1.txt' => {
    #                  content: 'String file contents'
    #               }
    #             }
    #           }
    #           User.new.create_gist(content)
    #           Result: Gist info
    def create_gist(options = {})
      authenticate unless authenticated?
      client.create_gist(options)
    end

    # Delete a gist #
    #   Parameters:
    #     options (Hash) (defaults to: {}) delete options
    #       Options:
    #         gist (String) Gist ID
    #   Returns:
    #     (Boolean) Indicating success of deletion
    # example:
    #  options = {gist: dee9c42e4998ce2ea439}
    #  User.new.delete_gist(options)
    #  Result: true
    def delete_gist(options = {})
      authenticate unless authenticated?
      client.delete_gist(options[:gist])
    end

    # Gets your Gist(s)
    def gists
      if authenticated?
        client.gists
      else
        Octokit.gists(@options.username)
      end
    end

    private

    def authenticate
      client.login
      @logged_in = true
    end

  end

  # I feel smart for once
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
