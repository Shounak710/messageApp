class Api::ChatroomsController < ApplicationController
  before_action :authenticate_request

  def index
    @chatrooms = @current_user.chatrooms
    @chatrooms.each do |chatroom|
      render json: {
        chatrooms: chatroom.to_json,
        messages: chatroom.messages.to_json
      }
    end
  end

  def show
    @chatroom = Chatroom.find(params[:id])
    @message = @chatroom.messages
    render json: {messages: @message.to_json}
  end
end
