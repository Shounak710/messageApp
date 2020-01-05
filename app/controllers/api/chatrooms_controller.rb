class Api::ChatroomsController < ApplicationController
  before_action :authenticate_request

  def index
    @chatrooms = @current_user.chatrooms
    @messages = []
    @chatrooms.each do |chatroom|
      @messages << chatroom.messages.last
    end
    render json: {
      chatrooms: @chatrooms.to_json,
      messages: @messages.to_json
    }
  end

  def show
    @chatroom = Chatroom.find(params[:id])
    @message = @chatroom.messages
    render json: {messages: @message.to_json}
  end
end
