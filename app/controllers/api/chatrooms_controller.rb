class Api::ChatroomsController < ApplicationController
  before_action :authenticate_request
  before_action :validate_user, only: [:show, :all_messages]

  def index
    @chatroom = @current_user.chatrooms
    render json: @chatroom, root: 'chatrooms', each_serializer: AllChatroomSerializer, adapter: :json
  end

  def all_messages
    render json: @chatroom, root: 'chatroom', serializer: ChatroomOverviewSerializer, adapter: :json
  end

  def show
    @messages = @chatroom.messages
    render json: @messages, root: 'messages', each_serializer: ChatroomMessagesSerializer, adapter: :json
  end

  def get_connect
    if @current_user.connected?
      @chatroom = Chatroom.find(@current_user.active_chatroom)
      @other = @chatroom.users.where.not(id: @current_user.id).first
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
          status: "pending",
        }
      }, status: :ok
    end
  end
  
  private

  def chatroom_params
    params.permit(:id)
  end

  def validate_user
    @chatroom = Chatroom.find(chatroom_params[:id])
    unless @chatroom.users.include? @current_user
      render status: :forbidden
    end
  end
end