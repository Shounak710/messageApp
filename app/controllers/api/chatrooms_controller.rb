class Api::ChatroomsController < ApplicationController

  def index
    @chatroom = Chatroom.find(params[:id])
    @message = @chatroom.messages
    render json: {messages: @message.to_json}
  end

end
