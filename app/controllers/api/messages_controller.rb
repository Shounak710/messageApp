class Api::MessagesController < ApplicationController
  before_action :authenticate_request

  def send_message
    @chatroom = Chatroom.find(2)
    @message = Message.create(body: params[:body], chatroom: @chatroom, sender: @current_user)
    if @message.save
      response = { message: 'Message sent' }
      render json: response
    end
  end
end
