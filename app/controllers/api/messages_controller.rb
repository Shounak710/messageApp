class Api::MessagesController < ApplicationController
  before_action :authenticate_request

  def send_message
    # TODO: What happens if the Chatroom can not be found?
    @chatroom = Chatroom.find(chatroom_params[:id])
    @message = Message.create(body: params[:body], chatroom: @chatroom, sender: @current_user)
    response = { message: 'Message sent' }
    # TODO: What status does this return?
    render json: response
  end

  
end
