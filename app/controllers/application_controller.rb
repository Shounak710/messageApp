class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user

  include ExceptionHandler

  private

  def authenticate_request
    if request.headers['Authorization'].present?
      @current_user = AuthorizeApiRequest.new(request.headers).call
      render status: :forbidden unless @current_user
    else
      render status: :unauthorized
    end
  end

  def validate_user_in_chatroom
    @chatroom = @current_user.chatrooms.find(chatroom_params[:id])
  end
end
