class ChatroomMessagesSerializer < ActiveModel::Serializer
  attributes :id, :body, :sent_by, :created_at

  def sent_by
    self.object.sender == current_user ? 'self' : 'other'
  end
end
