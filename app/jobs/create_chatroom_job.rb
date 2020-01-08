class CreateChatroomJob < ApplicationJob
  queue_as :urgent

  def perform(user1, user2)
    @user1 = user1
    @user2 = user2
    @chatroom = Chatroom.create
    [@user1, @user2].each do |user|
      ChatroomsUser.create(user: user, chatroom: @chatroom)
      user.update(active: 2)
    end
  end
end
