class Chatroom < ApplicationRecord
  # TODO: You should validate that there are exactly two users in a Chatroom
  has_many :messages, dependent: :destroy
  has_and_belongs_to_many :users
  #validate :has_only_2_users, :on => :create

  def has_only_2_users
    if self.users.count != 2
      render json: { error: "There must be exactly 2 users present in the chatroom!" }
    end
  end
end
