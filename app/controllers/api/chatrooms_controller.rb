class Api::ChatroomsController < ApplicationController
  before_action :authenticate_request

  def index
    @chatroom = @current_user.chatrooms
    @chatrooms = []
    @chatroom.each do |chatroom|
      c = Hash.new
      c["id"] = chatroom.id
      c["username"] = chatroom.users.where.not(id: @current_user.id).first.name
      c["last_message"] = { 
        id: chatroom.messages.last.id,
        body: chatroom.messages.last.body,
        sender: chatroom.messages.last.sender == @current_user ? 'self' : 'other',
        created_at: chatroom.messages.last.created_at
      }
       unless chatroom.messages.count == 0
      if c.has_key? 'username'
        @chatrooms << c
      end
    end
    render json: {
      chatrooms: @chatrooms
    }
  end

  def all_messages
    @chatroom = Chatroom.find(chatroom_params[:id])
    @messages = @chatroom.messages
    @other = @chatroom.users.where.not(id: @current_user.id).first
    @message = []
    @messages.each do |message|
      @message << message.id
    end
    render json: {
      chatroom: {
        id: @chatroom.id,
        username: @other.name,
        messages: @message.to_json
      }
    }
  end

  def show
    @chatroom = Chatroom.find(chatroom_params[:id])
    if @chatroom.users.include?(@current_user)
      @message = @chatroom.messages
      @messages = []
      @message.each do |message|
        m = Hash.new
        m["id"] = message.id
        m["body"] = message.body
        m["sender"] = message.sender == @current_user ? 'self' : 'other'
        m["created_at"] = message.created_at
        @messages << m
      end
      render json: {
        messages: @messages
      }
    else
      render json: {
        message: "You cannot view this chat"
      }
    end
  end

  def get_connect
    if @current_user.connected?
      @chatroom = Chatroom.find(@current_user.active_chatroom)
      @other = @chatroom.users.where.not(id: @current_user.id).first
      render json: {
        connection: {
          status: "connected",
          chatroom: "#{@chatroom.id}",
          user: @other.name
        }
      }, status: :ok
    else
      render json: {
        connection: {
          status: "pending",
        }
      }, status: :ok
    end
  end
  
  private

  def chatroom_params
    params.permit(:id)
  end
end