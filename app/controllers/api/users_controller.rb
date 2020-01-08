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

  def chatroom
    if @current_user.active == 2
      @chatroom = @current_user.chatrooms.order("created_at desc").first
      @user = @chatroom.users.where.not(id: @current_user.id)[0]
      render json: {
        chatroom: @chatroom.id,
        user: @user.name
      }
    else
      render json: {message: "Searching for a user"}
    end
  end

  def connect
    @current_user.update(active: 1)
    if User.where(active: 1).count > 1
      @user1 = User.where(active: 1).order(:updated_at).first
      Connect.new(@user1, @current_user).chat
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
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end
end
