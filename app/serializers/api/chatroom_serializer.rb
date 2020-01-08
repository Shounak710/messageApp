class Api::ChatroomSerializer < ActiveModel::Serializer
  has_many :messages
  has_and_belongs_to_many :users
  attributes :id, :last_message

  def last_message
    {
      last_message: self.messages.last.body,
      created_at: self.messages.last.created_at
    }
  end
end
