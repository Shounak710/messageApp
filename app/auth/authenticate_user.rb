class AuthenticateUser
	attr_accessor :name, :password

	def initialize(name, password)
		@name = name
		@password = password
	end

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
