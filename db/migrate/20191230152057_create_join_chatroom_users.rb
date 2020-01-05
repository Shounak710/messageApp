class CreateJoinChatroomUsers < ActiveRecord::Migration[6.0]
  def change
    create_join_table :users, :chatrooms, column_options: { null: true }
  end
end
