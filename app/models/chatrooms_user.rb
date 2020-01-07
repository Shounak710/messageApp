class ChatroomsUser < ApplicationRecord
  # TODO: Since you are using a has_and_belongs_to_many relationship on Chatroom and User,
  # this class is unnecessary

  belongs_to :chatroom
  belongs_to :user
end
