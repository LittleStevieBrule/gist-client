module OctokitWrapper
  # Used for when user has not authenticated and performs an action that
  # requires authentication.
  class AuthenticationError < StandardError

    def initialize(msg = 'Authenticate is required to perform this action')
      super
    end

  end

end