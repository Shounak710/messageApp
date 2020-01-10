class Api::UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[login register]

  def login
    if authenticate(user_params[:name], user_params[:password])
      render json: {
        access_token: @token
      }, status: :ok
    else
      render json: @user.errors, status: :bad
    end
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

  def connect
    @current_user.pending!
    if User.where(connection_status: :pending).count > 1
      @other = User.where(connection_status: :pending).where.not(id: @current_user.id).first
      ConnectService.new(@current_user, @other).chat
      render status: :created
    else
      render status: :ok
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
      return false
    end
  end
end
