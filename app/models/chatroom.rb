class Chatroom < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_and_belongs_to_many :users

  def partner_of(user)
    self.users.where.not(id: user.id).first
  end
end
