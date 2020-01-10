class Api::UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[login register]

  def login
    if authenticator.invalid?
      render json: authenticator.errors, status: :unprocessable_entity 
    else
      if authenticator.authenticated
        user = User.find_by_name(user_params[:name])
        render json: {
          id: user.id,
          name: user.name,
          access_token: authenticator.token
        }, status: :ok
      else
        head :forbidden
      end
    end
  end

  def register
    @user = User.new(user_params)
    if @user.save
      authenticator.authenticated
      render json: {
        id: @user.id,
        name: @user.name,
        access_token: authenticator.token
      }, status: :created
    else
      if authenticator.invalid?
        render json: { errors: authenticator.errors }, status: :unprocessable_entity
      else
        render json: { errors: @user.errors }, status: :conflict
      end
    end
  end

  def connect
    @current_user.pending!
    if User.where(connection_status: :pending).count > 1
      @other = User.where(connection_status: :pending).where.not(id: @current_user.id).first
      ConnectService.new(@current_user, @other).chat
      render json: {connection: "pending"}, status: :created
    else
      render status: :ok
    end
  end
  
  private

  def user_params
    # require user here on master branch
    params.permit(
      :name,
      :password
    )
  end

  def authenticator
    @authenticator ||= AuthenticateUser.new(user_params[:name], user_params[:password])
  end
end