class ConnectService
  def initialize(user, other)
    @user = user
    @other = other
  end

  def chat
    chatroom = Chatroom.create(users: [@user, @other])
    [@user, @other].each do |user|
      user.update(connection_status: :connected, active_chatroom: chatroom.id)
    end
  end
end          
      