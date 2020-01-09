class Api::UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[login register]

  def login
    authenticate(user_params[:name], user_params[:password])
  end

  def register
    @user = User.create(user_params)
    if @user.save
      authenticate(user_params[:name], user_params[:password], 'User created successfully')
    else
      render json: @user.errors, status: :bad
    end
  end

  def connect
    @current_user.pending!
    if User.where(connection_status: :pending).count > 1
      @other = User.where(connection_status: :pending).where.not(id: @current_user.id).first
      Connect.new(@other, @current_user).chat
      render status: :ok
    else
      render json: { message: "Requesting for a user" }
    end
  end
  
  private

  def user_params
    params.permit(
      :name,
      :password
    )
  end

  def authenticate(name, password, message = nil)
    message ||= 'Login Successful'
    authenticator = AuthenticateUser.new(name, password)
    if authenticator.call
      render json: {
        access_token: authenticator.token,
        message: message
      }, status: :ok
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end
end
