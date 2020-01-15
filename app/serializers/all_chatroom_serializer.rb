class AllChatroomSerializer < ActiveModel::Serializer
  attributes :id, :other_user
  attribute :last_message, if: :messages_exist?

  def other_user
    {
      name: self.object.partner_of(current_user).name
    }
  end

  def last_message
    {
      id: self.object.messages.last.id,
      body: self.object.messages.last.body,
      sender: self.object.messages.last.sent_by?(current_user),
      created_at: self.object.messages.last.created_at
    }
  end

  def messages_exist?
    self.object.messages.any?
  end
end
