class PreventDuplicatesInChatroomsUser < ActiveRecord::Migration[6.0]
  def change
    add_index :chatrooms_users, [:user_id, :chatroom_id], unique: true
  end
end
