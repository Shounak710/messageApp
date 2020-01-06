class Api::ChatroomsController < ApplicationController
  before_action :authenticate_request

  def index
    @chatrooms = @current_user.chatrooms
    @chatroom = []
    @messages = []
    @users = []
    @chatrooms.each do |chatroom|
      @chatroom << chatroom.id
      chatroom.users.each do |user|
        if user != @current_user
          @users << user.name
        end
      end
      @messages << chatroom.messages.last
    end
    render json: {
      chatrooms: @chatroom.to_json,
      messages: @messages.to_json,
      users: @users.to_json
    }
  end

  def show
    @chatroom = Chatroom.find(params[:id])
    @message = @chatroom.messages
    render json: {messages: @message.to_json}
  end
end
