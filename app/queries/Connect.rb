class Connect
  def initialize(user1, user2)
    @user1 = user1
    @user2 = user2
  end

  def chat
    id = @user1.chatrooms.ids & @user2.chatrooms.ids
    if id.any?
      @user1.connected!
      @user2.connected!
    else
      @chatroom = Chatroom.new
      [@user1, @user2].each do |user|
        @chatroom.users << user
        user.connected!
      end
      @chatroom.save
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
      