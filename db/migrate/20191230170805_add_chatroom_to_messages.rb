class AddChatroomToMessages < ActiveRecord::Migration[6.0]
  def change
    add_belongs_to :messages, :chatroom
  end
end
