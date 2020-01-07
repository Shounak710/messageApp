class Api::ChatroomsController < ApplicationController
  before_action :authenticate_request

  def index
    @chatrooms = @current_user.chatrooms
    Api::ChatroomSerializer.new(@chatrooms).as_json
  end

  def show
    # TODO: Do you really only return the messages? Shouldn't you also return
    # the chatroom and the participants?
    # Again, do you have an API specification?
    @chatroom = Chatroom.find(params[:id])
    @messages = @chatroom.messages
    @users = @chatroom.users
    render json: {
      messages: @messages.to_json,
      users: @users.to_json
    }
  end

  def send_message
    # TODO: What happens if the Chatroom can not be found?
    @chatroom = Chatroom.find(params[:id])
    @message = Message.new(body: params[:body], chatroom: @chatroom, sender: @current_user)
    # TODO: When using #create, the object will automatically be saved, so no need to
    # call save here again. Either user 'if Message.create' directly, or initialize
    # the object with Message.new, then call #save
    if @message.save
      response = { message: 'Message sent' }
      # TODO: What status does this return?
      render json: response, status: :ok
    end
  end
end
