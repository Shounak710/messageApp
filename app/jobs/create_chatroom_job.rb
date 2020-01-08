class CreateChatroomJob < ApplicationJob
  queue_as :urgent

  def perform(user1, user2)
    @user1 = user1
    @user2 = user2
    @chatroom = Chatroom.create
    ChatroomsUser.create(chatroom: @chatroom, user: @user1)
    ChatroomsUser.create(chatroom: @chatroom, user: @user2)
    @user1.update(active: 2)
    @user2.update(active: 2)
    if @user1 == @current_user or @user2 == @current_user
      render json: { 
        chatroom: @chatroom.id,
        message: "You are now connected to a chatroom" 
      }
    end
  end
end
