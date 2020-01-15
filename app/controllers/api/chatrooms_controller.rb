class Api::ChatroomsController < ApplicationController
  before_action :authenticate_request
  before_action :validate_user_in_chatroom, only: [:show, :all_messages]

  def index
    render json: @current_user.chatrooms, root: 'chatrooms', each_serializer: AllChatroomSerializer, adapter: :json
  end

  def all_messages
    render json: @chatroom, root: 'chatroom', serializer: ChatroomOverviewSerializer, adapter: :json
  end

  def show
    render json: @chatroom.messages, root: 'messages', each_serializer: ChatroomMessagesSerializer, adapter: :json
  end

  def get_connect
    if @current_user.connected?
      @chatroom = Chatroom.find(@current_user.active_chatroom)
      @other = @chatroom.partner_of(@current_user)
      render json: {
        connection: {
          status: "connected",
          chatroom: "#{@chatroom.id}",
          other_name: @other.name
        }
      }, status: :ok
    else
      render json: {
        connection: {
          status: "#{@current_user.connection_status}",
        }
      }, status: :ok
    end
  end
  
  private

  def chatroom_params
    params.permit(:id)
  end
end