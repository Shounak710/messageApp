class Api::MessagesController < ApplicationController
  before_action :authenticate_request, :validate_user

  def send_message
    @message = Message.new(body: message_params[:body], chatroom: @chatroom, sender: @current_user)
    if @message.save
      render json: {
        message: {
          id: @message.id,
          body: @message.body,
          sender: @current_user.name,
          created_at: @message.created_at
        }
      }, status: :ok
    else
      render json: { errors: @message.errors }, status: :unprocessable_entity
    end
  end

  private

  def chatroom_params
    params.permit(:id)
  end

  def message_params
    params.require(:message).permit(:body)
  end

  def validate_user
    @chatroom = Chatroom.find(chatroom_params[:id])
    unless @chatroom.users.include? @current_user
      render status: :forbidden
    end
  end 
end
