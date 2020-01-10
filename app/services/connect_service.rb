class ConnectService
  def initialize(user, other)
    @user = user
    @other = other
  end

  def chat
    @chatroom = Chatroom.new
    [@user, @other].each do |user|
      @chatroom.users << user
      user.connected!
    end
    @chatroom.save
  end
end          
      