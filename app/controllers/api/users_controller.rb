class Api::UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[login register]

  def login
    authenticate params[:name], params[:password]
  end

	def index
		i = {"user" => "Hello world!"}
		render json: i
	end

  def register
    @user = User.create(user_params)
    if @user.save
      response = { message: 'User created successfully' }
      render json: {
        message: response,
        access_token: AuthenticateUser.new(user_params[:name], user_params[:password]).call
      },
      status: :created
    else
      render json: @user.errors, status: :bad
    end
  end

  def user_params
    params.permit(
      :name,
      :password
    )
  end

  def connect
    @current_user.update(active: 1)
    3.times do
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
        sleep(20)
      end
    end
  end

  def set_current_user
    @current_user = AuthorizeApiRequest.new(request.headers).call
  end

  private

  def authenticate(name, password)
    command = AuthenticateUser.new(name, password).call
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
