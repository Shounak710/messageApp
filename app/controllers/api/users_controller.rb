class Api::UsersController < ApplicationController
	
	def index
		i = {"user" => "Hello world!"}
		render json: i
	end

  def register
    @user = User.create(user_params)
    if @user.save
      response = { message: 'User created successfully' }
      render json: response, status: :created
    else
      render json: @user.errors, status: :bad
    end
  end

  def user_params
    params.permit(
      :name,
      :email,
      :password
    )
  end
end
