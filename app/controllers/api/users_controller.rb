class Api::UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[login register index]

  def login
    authenticate params[:email], params[:password]
  end

  def test
    render json: {
          message: 'You have passed authentication and authorization test'
        }
  end
	
	def index
		i = {"user" => "Hello world!"}
		render json: i
	end

  def register
    @user = User.create(user_params)
    if @user.save
      response = { message: 'User created successfully' }
      render json: response, status: :created
    else
      render json: @user.errors, status: :bad
    end
  end

  def user_params
    params.permit(
      :name,
      :email,
      :password
    )
  end

  private

  def authenticate(email, password)
    command = AuthenticateUser.new(email, password).call

    if command
      render json: {
        access_token: command,
        message: 'Login Successful'
      }
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end
end
