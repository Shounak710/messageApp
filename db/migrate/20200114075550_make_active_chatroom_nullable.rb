class MakeActiveChatroomNullable < ActiveRecord::Migration[6.0]
  def change
    change_column_default :users, :active_chatroom, :null
  end
end
