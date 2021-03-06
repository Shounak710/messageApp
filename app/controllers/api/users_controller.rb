class Api::UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[login register]

  def login
    if authenticator.invalid?
      render json: {errors: authenticator.errors}, status: :unprocessable_entity 
    else
      if authenticator.authenticated
        user = authenticator.user
        render json: {
          user: {
            id: user.id,
            name: user.name,
            access_token: authenticator.token
          }
        }, status: :ok
      else
        head :forbidden
      end
    end
  end

  def register
    @user = User.new(user_params)
    if @user.save
      if authenticator.authenticated
        render json: {
          user: {
            id: @user.id,
            name: @user.name,
            access_token: authenticator.token
          }
        }, status: :created
      else
        render json: {errors: authenticator.errors}, status: :unprocessable_entity
      end
    else
      render json: {errors: @user.errors}, status: :unprocessable_entity
    end
  end

  def connect
    @current_user.pending!
    if User.where(connection_status: :pending).count > 1
      @other = User.where(connection_status: :pending).where.not(id: @current_user.id).first
      ConnectService.new(@current_user, @other).chat
    end
    render json: {
      connection: { 
        status: "pending"
      }
    }, status: :ok
  end

  def disconnect
    @current_user.update(connection_status: :inactive, active_chatroom: nil)
    render json: {
      connection: {
        status: "#{@current_user.connection_status}"
      }
    }, status: :ok
  end  

  
  private

  def user_params
    params.require(:user).permit(
      :name,
      :password
    )
  end

  def authenticator
    @authenticator ||= AuthenticateUser.new(user_params[:name], user_params[:password])
  end
end