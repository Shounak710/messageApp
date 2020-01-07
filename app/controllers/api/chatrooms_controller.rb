class Api::ChatroomsController < ApplicationController
  before_action :authenticate_request

  def index
    @chatrooms = @current_user.chatrooms
    @chatroom = []
    # TODO: Why do you use this loop here?
    # Can't you just return @current_user.chatrooms?
    # Do you have a document defining your API responses?
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
    # TODO: Do you really only return the messages? Shouldn't you also return
    # the chatroom and the participants?
    # Again, do you have an API specification?
    @chatroom = Chatroom.find(params[:id])
    @message = @chatroom.messages
    render json: {messages: @message.to_json}
  end
end
