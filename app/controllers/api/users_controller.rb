class Api::UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[login register]

  def login
    if authenticate(user_params[:name], user_params[:password])
      render json: {
        access_token: @token
      }, status: :ok
    end
  end

  def register
    @user = User.create(user_params)
    if authenticate(user_params[:name], user_params[:password])
      render json: {
        access_token: @token
      }, status: :ok
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

  def authenticate(name, password)
    authenticator = AuthenticateUser.new(name, password)
    if authenticator.call
      @token = authenticator.token
      return true
    else
      render json: { error: authenticator.errors }, status: :unauthorized
    end
  end
end
