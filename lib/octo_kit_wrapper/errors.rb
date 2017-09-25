module OctokitWrapper
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
    def initialize(msg = 'Token was nil. Store you oauth token as the enviroment
      variable $GISTTOKEN see http://linuxcommand.org/lc3_man_pages/exporth.html
       or man export')
      super
    end
  end

end