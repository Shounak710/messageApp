class Api::MessagesController < ApplicationController
  before_action :authenticate_request

  def send_message
    # TODO: What happens if the Chatroom can not be found?
    @chatroom = Chatroom.find(params[:id])
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
end
