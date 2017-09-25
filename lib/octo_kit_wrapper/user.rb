require_relative 'errors'

module OctokitWrapper

  class User

    def initialize(options = {})
      client(options) unless options[:token].nil?
    end

    def client(options = {})
      @client ||= Octokit::Client.new access_token: options[:token]
    end

    def authenticate(options = {})
      raise OctokitWrapper::AuthenticationError if @client.nil?
      client(options[:token]).login
      @logged_in = true
    end

    def authenticated?
      @logged_in ||= false
    end

    #   Create a gist
    #     Parameters:
    #       options (Hash) (defaults to: {})  Gist information.
    #       Options Hash (options):
    #         :description (String)
    #         :public (Boolean)  Sets gist visibility
    #         :files (Array<Hash>)  Files that make up this gist. Keys should be
    #          the filename, the value a Hash with a :content key with text
    #          content of the Gist.
    #       Returns:
    #         (Sawyer::Resource)  Newly created gist info
    # example:
    #           content ={
    #           description: 'the description for this gist',
    #               public: true,
    #               files: {
    #               'file1.txt' => {
    #                   content: 'String file contents'
    #               }
    #             }
    #           }
    #           User.new.create_gist(content)
    #           Result: Gist info
    def create_gist(options = {})
      authenticate unless authenticated?
      client.create_gist(options)
    end

  end

end
