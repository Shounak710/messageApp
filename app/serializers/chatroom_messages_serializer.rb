class ChatroomMessagesSerializer < ActiveModel::Serializer
  attributes :id, :body, :sent_by, :created_at

  def sent_by
    self.object.sent_by?(current_user)
  end
end
