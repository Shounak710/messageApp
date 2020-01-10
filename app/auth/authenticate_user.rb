class AuthenticateUser
  include ActiveModel::Validations
  validate :params_present
  attr_reader :token, :user

	def initialize(name, password)
		@name = name
		@password = password
	end

	def authenticated
		if user
      @token = JsonWebToken.encode(user_id: @user.id)
      return true
    else
      return false
    end
	end

  def params_present
    if @name.blank?
      errors.add(:name, "Must exist")
    elsif @password.blank?
      errors.add(:password, "Must exist")
    end
  end

	private

  def user
    @user = User.find_by_name(@name)
    return false unless @user
    return @user.authenticate(@password)
  end
end
