class Api::UsersController < ApplicationController
	
	def index
		i = {"user" => "Hello world!"}
		render json: i
	end
end
