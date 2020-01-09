class AuthenticateUser
  attr_reader :token

	def initialize(name, password)
		@name = name
		@password = password
	end

	# TODO: This method should better return true if user can be authenticated,
	# false else.
	# Then add a method #token to get the access_token
	# (You can also use an attr_reader here and set the token on successful auth)
	def call
		if user
      @token = JsonWebToken.encode(user_id: user.id)
    end
	end

	private

	def user
		user = User.find_by_name(@name)
    if user && user.authenticate(@password)
      return user
    else
      user.errors.add :user_authentication, 'Invalid credentials'
    end
  end
end
