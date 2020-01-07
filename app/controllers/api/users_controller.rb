class Api::UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[login register]

  def login
    # TODO: Don't use user params directly, always sanitize user input!
    # Here: use user_params instead of params
    authenticate params[:name], params[:password]
  end

	def index
    # TODO: I guess this is a placeholder for now, right?
		i = {"user" => "Hello world!"}
		render json: i
	end

  def register
    @user = User.create(user_params)
    if @user.save
      response = { message: 'User created successfully' }
      render json: {
        message: response,
        # TODO: What happens, if the AuthenticateUser call fails?
        access_token: AuthenticateUser.new(user_params[:name], user_params[:password]).call
      },
      status: :created
    else
      render json: @user.errors, status: :bad
    end
  end

  # TODO: This method should be private
  def user_params
    params.permit(
      :name,
      :password
    )
  end

  # TODO: Make a plan on how to connect users first, then implement accordingly.
  # Discuss with Naveen
  def connect
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

  # TODO: This method should be private
  # Also, why don't you use authenticate_request of ApplicationController instead?
  # That method also sets the current_user
  def set_current_user
    # TODO: What hapens if the request can not be authorized?
    @current_user = AuthorizeApiRequest.new(request.headers).call
  end

  private

  def authenticate(name, password)
    # TODO: command is a very strange variable name here, why did you choose that?
    # Could you choose a better variable name?
    command = AuthenticateUser.new(name, password).call
    # It would probably be better to return true or false on the authentication call,
    # and then store the token within the AuthenticateUser class.
    # Then you could do this like
    # authenticator = AuthenticateUser.new(name, password)
    # if authenticator.call
    #   render authenticator.token
    # else
    #   render json: { error: "Invalid credentials" }, status: :unauthorized
    # end
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
