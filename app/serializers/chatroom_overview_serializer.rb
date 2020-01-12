class ChatroomOverviewSerializer < ActiveModel::Serializer
  attributes :id, :other_user
  attribute :messages_id, if: :messages_exist?

  def other_user
    {
      name: self.object.users.where.not(id: current_user.id).first.name
    }
  end

  def messages_id
    {
    messages: self.object.messages.ids
    }
  end

  def messages_exist?
    true if self.object.messages.any?
  end
end
