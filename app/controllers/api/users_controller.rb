class Api::UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[login register]

  def login
    authenticate(user_params[:name], user_params[:password])
  end

  def register
    @user = User.create(user_params)
    if @user.valid?
      authenticate(user_params[:name], user_params[:password])
      render json: {
        access_token: @token
      }, status: :created
    else
      if @user.errors[:name].any? and @user.errors[:password].any?
        render json: {errors: @user.errors}, status: :bad_request
      else
        render json: {errors: @user.errors}, status: :unprocessable_entity
      end
    end
  end

  def chatroom
    if @current_user.active == 2
      @chatroom = @current_user.chatrooms.order("created_at desc").first
      @user = @chatroom.users.where.not(id: @current_user.id)[0]
      render json: {
        chatroom: "#{@chatroom.id}",
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
      render status: :ok
    else
      render json: { message: "Requesting for a user" }
    end
  end
  
  private

  def user_params
    params.require(:user).permit(
                              :name,
                              :password
                            )
  end

  def authenticate(name, password)
    authenticator = AuthenticateUser.new(name, password)
    if authenticator.call
      @token = authenticator.token
      return true
    else
      return false
    end
  end
end
