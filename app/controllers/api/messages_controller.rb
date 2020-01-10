class Api::MessagesController < ApplicationController
  before_action :authenticate_request

  def send_message
    # TODO: What happens if the Chatroom can not be found?
    @chatroom = Chatroom.find(params[:id])
    @message = Message.new(body: message_params[:body], chatroom: @chatroom, sender: @current_user)
    # TODO: What status does this return?
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
    params.permit(:body)
  end
end
