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
=begin
    @current_user.update(active: 1)
    # TODO: Never do this kind of loop in a controller!
    5.times do
      if User.where(active: 1).count>1
        @chatroom = Chatroom.create
        @user1 = User.where(active: 1).order(:updated_at).first
        @user2 = User.where(active: 1).order(:updated_at).second
        ChatroomsUser.create(chatroom: @chatroom, user: @user1)
        ChatroomsUser.create(chatroom: @chatroom, user: @user2)
        @user1.update(active: 2)
        @user2.update(active: 2)
        if @user1 == @current_user or @user2 == @current_user
          render json: {
            chatroom_id: @chatroom.id,
            message: "Chatroom created"
          }
        end
        break
      else
        # TODO: Never use sleep() within a controller!
        sleep(5)
      end
    end
  end
=end
    @current_user.update(active: 1)
    Connect.chat
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

  def conjo(user)
    user.name
  end
end
