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
    render json: {
      messages: @message.to_json,
      current_user: @current_user.id
    }
  end

  def send_message
    # TODO: What happens if the Chatroom can not be found?
    @chatroom = Chatroom.find(chatroom_params[:id])
    @message = Message.create(body: params[:body], chatroom: @chatroom, sender: @current_user)
    # TODO: When using #create, the object will automatically be saved, so no need to
    # call save here again. Either user 'if Message.create' directly, or initialize
    # the object with Message.new, then call #save
    if @message.save
      response = { message: 'Message sent' }
      # TODO: What status does this return?
      render json: response
    end
  end

  private

  def chatroom_params
    params.permit(:id)
  end
end
