class Message < ApplicationRecord
  alias_attribute :sender, :user
  belongs_to :user
  belongs_to :chatroom
  validates :body, presence: true
end
