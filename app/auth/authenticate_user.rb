class AuthenticateUser
	# TODO: Why do you define attr_accessors here?
	attr_accessor :name, :password

	def initialize(name, password)
		@name = name
		@password = password
	end

	# TODO: This method should better return true if user can be authenticated,
	# false else.
	# Then add a method #token to get the access_token
	# (You can also use an attr_reader here and set the token on successful auth)
	def call
		JsonWebToken.encode(user_id: user.id) if user
	end

	private

	def user
		user = User.find_by_name(name)
    if user && user.authenticate(password)
      return user
    else
      user.errors.add :user_authentication, 'Invalid credentials'
      nil
    end
  end
end
