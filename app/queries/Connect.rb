class Connect
  def initialize(user1, user2)
    @user1 = user1
    @user2 = user2
  end

  def chat
    @chatroom = Chatroom.create
    [@user1, @user2].each do |user|
      ChatroomsUser.create(user: user, chatroom: @chatroom)
      user.update(active: 2)
    end
  end
end
=begin    
    @user = User.where(active: 1).order(:updated_at)
    if @user.count > 1
      @user.each_slice(2) do |user1, user2|
        if user1.present? and user2.present?
          CreateChatroomJob.perform_now(user1, user2)
        end
      end
    end
  end
=end
=begin
          @user1 = user1
          @user2 = user2
          @chatroom = Chatroom.create
          ChatroomsUser.create(chatroom: @chatroom, user: @user1)
          ChatroomsUser.create(chatroom: @chatroom, user: @user2)
          @user1.update(active: 2)
          @user2.update(active: 2)
        end
        if user1 == @current_user or user2 == @current_user
          render json: "You've joined the chat"
        end
=end          
      