class ConnectService
  def initialize(user, other)
    @user = user
    @other = other
  end

  def chat
    @chatroom = Chatroom.create
    [@user, @other].each do |user|
      @chatroom.users << user
      user.connected!
      user.update(active_chatroom: @chatroom.id)
    end
  end
end          
      