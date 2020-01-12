class AllChatroomSerializer < ActiveModel::Serializer
  attributes :id, :user
  attribute :last_message, if: :messages_exist?

  def user
    {
      name: self.object.users.where.not(id: current_user.id).first.name
    }
  end

  def last_message
    {
      id: self.object.messages.last.id,
      body: self.object.messages.last.body,
      sender: self.object.messages.last.sender == current_user ? 'self' : 'other',
      created_at: self.object.messages.last.created_at
    }
  end

  def messages_exist?
    true if self.object.messages.any?
  end
end
