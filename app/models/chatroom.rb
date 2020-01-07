class Chatroom < ApplicationRecord
  # TODO: You should validate that there are exactly two users in a Chatroom

  has_many :messages, dependent: :destroy
  has_and_belongs_to_many :users
end
