class Chatroom < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_and_belongs_to_many :users
  validate :has_2_users, on: :create

  def partner_of(user)
    self.users.where.not(id: user.id).first
  end

  def has_2_users
    unless self.users.size == 2
      errors.add(:user_limit, "Must have only 2 users in a chatroom")
    end
  end
end
