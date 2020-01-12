class Api::MessagesController < ApplicationController
  before_action :authenticate_request

  def send_message
    @chatroom = Chatroom.find(params[:id])
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

  def message_params
    params.require(:message).permit(:body)
  end
end
