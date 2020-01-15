class Message < ApplicationRecord
  alias_attribute :sender, :user
  belongs_to :user
  belongs_to :chatroom
  validates :body, presence: true

  def sent_by?(user)
    if self.sender == user
      return 'self'
    else
      return 'other'
    end
  end
end
