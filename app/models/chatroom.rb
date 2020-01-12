class Chatroom < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_and_belongs_to_many :users
  #validate :has_2_users

  def has_2_users
    if self.users.count != 2
      errors.add(:user_limit, "There can only be 2 users!")
    end
  end
end
