class ChatroomOverviewSerializer < ActiveModel::Serializer
  attributes :id, :other_user
  attribute :messages_ids, if: :messages_exist?

  def other_user
    {
      name: self.object.partner_of(current_user).name
    }
  end

  def messages_ids
    {
    messages: self.object.messages.ids
    }
  end

  def messages_exist?
    self.object.messages.any?
  end
end
