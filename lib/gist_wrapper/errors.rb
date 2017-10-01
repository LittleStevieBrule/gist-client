module GistWrapper
  # Used for when user has not authenticated and performs an action that
  # requires authentication.
  class AuthenticationError < StandardError

    def initialize(msg = 'Authenticate is required to perform this action')
      super
    end

  end

  # used when authentication was not provided and no username was provided
  class NoUsernameDefined < StandardError

    def initialize(msg = 'No username was defined')
      super
    end

  end

  # Nil token
  class NilTokenError < StandardError
    def initialize(msg = 'Token was nil. Please set your token in the token.yaml file')
      super
    end
  end

end