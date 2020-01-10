class Api::ChatroomsController < ApplicationController
  before_action :authenticate_request

  def index
    @chatrooms = @current_user.chatrooms
    @chatroom = []
    @chatrooms.each do |chatroom|
      c = Hash.new
      c["chatroom_id"] = chatroom.id
      chatroom.users.each do |user|
        if user != @current_user
          c["username"] = user.name
        end
      end
      c["lastmessage"] = chatroom.messages.last
      if c.has_key? 'username'
        @chatroom << c
      end
    end
    render json: {
      chatrooms: @chatroom.to_json
    }
  end

  def show
    @chatroom = Chatroom.find(chatroom_params[:id])
    @message = @chatroom.messages
    @messages = []
    @message.each do |message|
      m = Hash.new
      m["message"] = message.body
      m["created_at"] = message.created_at
      if message.sender == @current_user
        m["sender"] = 1
      else
        m["sender"] = 0
      end
      @messages << m
    end
    render json: {
      messages: @messages.to_json
    }
  end

  def get_connect
    if @current_user.connected?
      @chatroom = @current_user.chatrooms.order("created_at desc").first
      @other = @chatroom.users.where.not(id: @current_user.id).first
      render json: {
        chatroom: "#{@chatroom.id}",
        user: @other.name
      }
    else
      render json: {message: "Searching for a user"}
    end
  end
  
  private

  def chatroom_params
    params.permit(:id)
  end
end